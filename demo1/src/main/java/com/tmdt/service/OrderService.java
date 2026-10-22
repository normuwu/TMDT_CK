package com.tmdt.service;

import com.tmdt.dao.OrderDAO;
import com.tmdt.dao.OrderItemDAO;
import com.tmdt.dao.ProductDAO;
import com.tmdt.model.Cart;
import com.tmdt.model.CartItem;
import com.tmdt.model.CartProduct;
import com.tmdt.model.Order;
import com.tmdt.model.OrderItem;
import com.tmdt.model.OrderStatus;
import com.tmdt.model.PaymentMethod;
import com.tmdt.model.PaymentStatus;
import com.tmdt.model.ProductMaterial;
import com.tmdt.util.DBConnection;
import com.tmdt.util.ValidationUtil;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.math.BigDecimal;
import java.math.RoundingMode;
import java.sql.Connection;
import java.sql.SQLException;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import java.util.Optional;
import java.util.concurrent.atomic.AtomicInteger;

/**
 * Nghiệp vụ đặt hàng + lịch sử mua hàng.
 *
 * Nguyên tắc quan trọng:
 *  - Giá và tồn kho luôn đọc lại từ DB (không tin giá trong session/trình duyệt).
 *  - Toàn bộ đơn hàng nằm trong MỘT transaction, lỗi ở bất kỳ bước nào → rollback.
 *  - orders.shop_id là NOT NULL, nên giỏ có nhiều xưởng sẽ tạo nhiều đơn
 *    (mỗi xưởng một đơn) trong cùng transaction.
 */
public class OrderService {

    private static final Logger LOG = LoggerFactory.getLogger(OrderService.class);
    private static final DateTimeFormatter CODE_TIME = DateTimeFormatter.ofPattern("yyMMddHHmmssSSS");
    private static final AtomicInteger CODE_SEQ = new AtomicInteger();
    private static final int MAX_NOTE = 500;          // orders.note VARCHAR(500)
    private static final int MAX_ADDRESS = 300;       // orders.shipping_address VARCHAR(300)

    private final OrderDAO orderDAO = new OrderDAO();
    private final OrderItemDAO orderItemDAO = new OrderItemDAO();
    private final ProductDAO productDAO = new ProductDAO();

    public enum PlaceStatus {
        SUCCESS, VALIDATION_ERROR, EMPTY_CART, PRODUCT_UNAVAILABLE, OUT_OF_STOCK,
        SHOP_NOT_FOUND, SYSTEM_ERROR
    }

    public record PlaceOutcome(PlaceStatus status, Map<String, String> fieldErrors,
                               String message, List<Order> orders) {
        public boolean success() {
            return status == PlaceStatus.SUCCESS;
        }
    }

    // ---------------------------------------------------------------------
    // Đặt hàng COD
    // ---------------------------------------------------------------------

    public PlaceOutcome placeCodOrder(int userId, Cart cart, String fullName,
                                      String phone, String address, String note) {
        Map<String, String> errors = validateRecipient(fullName, phone, address, note);
        if (!errors.isEmpty()) {
            return new PlaceOutcome(PlaceStatus.VALIDATION_ERROR, errors,
                    "Vui lòng kiểm tra lại thông tin nhận hàng.", List.of());
        }
        if (cart == null || cart.isEmpty()) {
            return new PlaceOutcome(PlaceStatus.EMPTY_CART, Map.of(),
                    "Giỏ hàng đang trống, chưa thể đặt hàng.", List.of());
        }

        String name = fullName.trim();
        String normPhone = ValidationUtil.normalizePhone(phone);
        String shipAddress = address.trim();
        String noteValue = note == null ? "" : note.trim();

        try (Connection conn = DBConnection.getConnection()) {
            conn.setAutoCommit(false);
            try {
                Map<Integer, CartProduct> locked = lockCartProducts(conn, cart);

                // Gom các dòng theo xưởng — mỗi xưởng sẽ thành một đơn riêng.
                LinkedHashMap<Integer, List<OrderLine>> bySupplier = new LinkedHashMap<>();
                for (CartItem cartItem : cart.getItems()) {
                    CartProduct product = locked.get(cartItem.getProductId());
                    if (product == null) {
                        return rollback(conn, new PlaceOutcome(PlaceStatus.PRODUCT_UNAVAILABLE, Map.of(),
                                "Sản phẩm \"" + cartItem.getName() + "\" không còn bán. Vui lòng xóa khỏi giỏ.",
                                List.of()));
                    }
                    if (cartItem.getQuantity() > product.getStockQuantity()) {
                        return rollback(conn, new PlaceOutcome(PlaceStatus.OUT_OF_STOCK, Map.of(),
                                "Sản phẩm \"" + product.getName() + "\" chỉ còn "
                                        + product.getStockQuantity() + " sản phẩm.",
                                List.of()));
                    }

                    BigDecimal unitPrice = BigDecimal.valueOf(product.getPrice())
                            .setScale(2, RoundingMode.HALF_UP);
                    String lineName = product.getName();

                    if (cartItem.getMaterialId() != null) {
                        Optional<ProductMaterial> material = productDAO.findMaterial(
                                conn, product.getProductId(), cartItem.getMaterialId(), true);
                        if (material.isEmpty()) {
                            return rollback(conn, new PlaceOutcome(PlaceStatus.PRODUCT_UNAVAILABLE, Map.of(),
                                    "Vật liệu của sản phẩm \"" + product.getName()
                                            + "\" không còn khả dụng. Vui lòng chọn lại.",
                                    List.of()));
                        }
                        unitPrice = BigDecimal.valueOf(material.get().getPrice())
                                .setScale(2, RoundingMode.HALF_UP);
                        lineName = lineName + " (" + material.get().getName() + ")";
                    }

                    bySupplier.computeIfAbsent(product.getSupplierId(), k -> new ArrayList<>())
                            .add(new OrderLine(product, cartItem.getQuantity(), unitPrice, lineName));
                }

                List<Order> created = new ArrayList<>();
                LocalDateTime now = LocalDateTime.now();

                for (Map.Entry<Integer, List<OrderLine>> entry : bySupplier.entrySet()) {
                    Optional<Integer> shopId = orderDAO.findShopIdBySupplier(conn, entry.getKey());
                    if (shopId.isEmpty()) {
                        LOG.warn("Supplier {} chưa có shop trong bảng shops", entry.getKey());
                        return rollback(conn, new PlaceOutcome(PlaceStatus.SHOP_NOT_FOUND, Map.of(),
                                "Xưởng in của sản phẩm trong giỏ chưa mở cửa hàng. Vui lòng chọn sản phẩm khác.",
                                List.of()));
                    }

                    List<OrderLine> lines = entry.getValue();
                    BigDecimal subtotal = BigDecimal.ZERO;
                    for (OrderLine line : lines) {
                        subtotal = subtotal.add(line.unitPrice()
                                .multiply(BigDecimal.valueOf(line.quantity())));
                    }
                    subtotal = subtotal.setScale(2, RoundingMode.HALF_UP);

                    Order order = new Order();
                    order.setOrderCode(nextCode());
                    order.setUserId(userId);
                    order.setShopId(shopId.get());
                    order.setShopName(lines.get(0).product().getSupplierName());
                    order.setRecipientName(name);
                    order.setRecipientPhone(normPhone);
                    order.setShippingAddress(shipAddress);
                    order.setNote(noteValue.isEmpty() ? null : noteValue);
                    order.setSubtotalAmount(subtotal);
                    order.setShippingFee(BigDecimal.ZERO.setScale(2));
                    order.setDiscountAmount(BigDecimal.ZERO.setScale(2));
                    order.setTotalAmount(subtotal); // miễn phí vận chuyển
                    order.setStatus(OrderStatus.PENDING);
                    order.setPaymentMethod(PaymentMethod.COD);
                    order.setPaymentStatus(PaymentStatus.PENDING);
                    order.setCreatedAt(now);

                    orderDAO.insert(conn, order);

                    List<OrderItem> savedItems = new ArrayList<>();
                    for (OrderLine line : lines) {
                        OrderItem item = new OrderItem();
                        item.setProductId(line.product().getProductId());
                        item.setProductName(line.name());
                        item.setUnitPrice(line.unitPrice());
                        item.setQuantity(line.quantity());
                        item.setLineTotal(line.unitPrice()
                                .multiply(BigDecimal.valueOf(line.quantity()))
                                .setScale(2, RoundingMode.HALF_UP));
                        orderItemDAO.insert(conn, order.getOrderId(), item);
                        savedItems.add(item);

                        if (!productDAO.decreaseStock(conn, line.product().getProductId(), line.quantity())) {
                            throw new SQLException("Không đủ tồn kho khi cập nhật sản phẩm "
                                    + line.product().getProductId());
                        }
                    }
                    order.setItems(savedItems);

                    // COD: đơn mới → chờ xác nhận, thanh toán chưa thực hiện.
                    orderDAO.insertPayment(conn, order.getOrderId(), PaymentMethod.COD,
                            order.getTotalAmount(), PaymentStatus.PENDING);

                    created.add(order);
                }

                conn.commit();
                LOG.info("Đã tạo {} đơn COD cho userId={}", created.size(), userId);
                return new PlaceOutcome(PlaceStatus.SUCCESS, Map.of(),
                        "Đặt hàng thành công.", created);
            } catch (SQLException e) {
                conn.rollback();
                LOG.error("Đặt hàng thất bại, đã rollback (userId={})", userId, e);
                return new PlaceOutcome(PlaceStatus.SYSTEM_ERROR, Map.of(),
                        "Không lưu được đơn hàng, vui lòng thử lại sau.", List.of());
            } catch (RuntimeException e) {
                conn.rollback();
                throw e;
            }
        } catch (SQLException e) {
            LOG.error("Không kết nối được DB để đặt hàng (userId={})", userId, e);
            return new PlaceOutcome(PlaceStatus.SYSTEM_ERROR, Map.of(),
                    "Không kết nối được cơ sở dữ liệu, vui lòng thử lại sau.", List.of());
        }
    }

    // ---------------------------------------------------------------------
    // Lịch sử / chi tiết
    // ---------------------------------------------------------------------

    public List<Order> history(int userId) {
        try {
            return orderDAO.findByUserId(userId);
        } catch (SQLException e) {
            throw new IllegalStateException("Không tải được lịch sử mua hàng", e);
        }
    }

    /** Chi tiết đơn kèm kiểm tra chủ sở hữu (userId lấy từ session). */
    public Optional<Order> detail(int userId, int orderId) {
        try {
            Optional<Order> order = orderDAO.findByIdAndUser(orderId, userId);
            if (order.isPresent()) {
                order.get().setItems(orderItemDAO.findByOrderId(orderId));
            }
            return order;
        } catch (SQLException e) {
            throw new IllegalStateException("Không tải được chi tiết đơn hàng", e);
        }
    }

    /**
     * Các đơn vừa tạo cho trang "đặt hàng thành công". Chỉ trả về đơn thuộc
     * đúng user đang đăng nhập — id trên URL không đủ để xem đơn người khác.
     */
    public List<Order> successOrders(int userId, List<Integer> orderIds) {
        List<Order> result = new ArrayList<>();
        for (Integer id : orderIds) {
            if (id == null) continue;
            detail(userId, id).ifPresent(result::add);
        }
        return result;
    }

    // ---------------------------------------------------------------------
    // Helpers
    // ---------------------------------------------------------------------

    private Map<String, String> validateRecipient(String fullName, String phone,
                                                  String address, String note) {
        Map<String, String> errors = new LinkedHashMap<>();
        String name = fullName == null ? "" : fullName.trim();
        String normPhone = ValidationUtil.normalizePhone(phone);
        String addr = address == null ? "" : address.trim();
        String noteValue = note == null ? "" : note.trim();

        if (!ValidationUtil.isValidFullName(name)) {
            errors.put("fullName", "Vui lòng nhập họ và tên người nhận (tối đa 100 ký tự).");
        }
        if (!ValidationUtil.isValidVnPhone(normPhone)) {
            errors.put("phone", "Số điện thoại chưa hợp lệ (10 số, bắt đầu bằng 0).");
        }
        if (addr.isEmpty() || addr.length() > MAX_ADDRESS) {
            errors.put("address", "Vui lòng nhập địa chỉ nhận hàng (tối đa " + MAX_ADDRESS + " ký tự).");
        }
        if (noteValue.length() > MAX_NOTE) {
            errors.put("note", "Ghi chú tối đa " + MAX_NOTE + " ký tự.");
        }
        return errors;
    }

    private Map<Integer, CartProduct> lockCartProducts(Connection conn, Cart cart) throws SQLException {
        List<Integer> ids = new ArrayList<>();
        for (CartItem item : cart.getItems()) {
            ids.add(item.getProductId());
        }
        Map<Integer, CartProduct> byId = new HashMap<>();
        for (CartProduct p : productDAO.findCartProductsForUpdate(conn, ids)) {
            byId.put(p.getProductId(), p);
        }
        return byId;
    }

    /** Rollback rồi trả outcome lỗi cho servlet (giữ nguyên giỏ hàng). */
    private static PlaceOutcome rollback(Connection conn, PlaceOutcome outcome) throws SQLException {
        conn.rollback();
        return outcome;
    }

    private static String nextCode() {
        return "PK" + LocalDateTime.now().format(CODE_TIME)
                + String.format("%02d", Math.floorMod(CODE_SEQ.incrementAndGet(), 100));
    }

    private record OrderLine(CartProduct product, int quantity,
                             BigDecimal unitPrice, String name) {
    }
}
