package com.tmdt.service;

import com.tmdt.dao.ProductDAO;
import com.tmdt.model.Cart;
import com.tmdt.model.CartItem;
import com.tmdt.model.CartProduct;
import com.tmdt.model.ProductMaterial;

import java.sql.SQLException;
import java.util.Optional;

/**
 * Nghiệp vụ giỏ hàng. Mọi giá và tồn kho đọc từ DB; dữ liệu trình duyệt gửi lên
 * chỉ gồm productId, materialId, quantity và đều được kiểm tra lại ở đây.
 */
public class CartService {

    private final ProductDAO productDAO = new ProductDAO();

    public enum AddStatus { ADDED, NOT_FOUND, INVALID_QUANTITY, OUT_OF_STOCK, SYSTEM_ERROR }

    public record AddOutcome(AddStatus status, String message, int addedQuantity) {
    }

    /**
     * Thêm sản phẩm vào giỏ. Cùng productId + materialId sẽ cộng dồn số lượng.
     * Số lượng được chặn theo tồn kho thật đọc từ DB.
     */
    public AddOutcome add(Cart cart, int productId, Integer materialId, int quantity) {
        if (quantity < 1 || quantity > 999) {
            return new AddOutcome(AddStatus.INVALID_QUANTITY,
                    "Số lượng không hợp lệ.", 0);
        }
        try {
            Optional<CartProduct> productOpt = productDAO.findCartProduct(productId);
            if (productOpt.isEmpty()) {
                return new AddOutcome(AddStatus.NOT_FOUND,
                        "Sản phẩm không tồn tại hoặc đã ngừng bán.", 0);
            }
            CartProduct product = productOpt.get();
            if (product.getStockQuantity() <= 0) {
                return new AddOutcome(AddStatus.OUT_OF_STOCK,
                        "Sản phẩm đã hết hàng.", 0);
            }

            long unitPrice = product.getPrice();
            String materialName = null;
            if (materialId != null) {
                Optional<ProductMaterial> materialOpt = productDAO.findMaterial(productId, materialId);
                if (materialOpt.isEmpty()) {
                    return new AddOutcome(AddStatus.NOT_FOUND,
                            "Vật liệu đã chọn không còn khả dụng.", 0);
                }
                ProductMaterial material = materialOpt.get();
                unitPrice = material.getPrice();
                materialName = material.getName();
            }

            int wanted = Math.min(quantity, product.getStockQuantity());
            CartItem item = new CartItem();
            item.setProductId(product.getProductId());
            item.setSupplierId(product.getSupplierId());
            item.setMaterialId(materialId);
            item.setMaterialName(materialName);
            item.setName(product.getName());
            item.setThumbnailUrl(product.getThumbnailUrl());
            item.setUnitPrice(unitPrice);
            item.setQuantity(wanted);
            item.setMaxStock(product.getStockQuantity());

            int added = cart.add(item);
            if (added == 0) {
                return new AddOutcome(AddStatus.OUT_OF_STOCK,
                        "Giỏ hàng đã có tối đa số lượng còn lại của sản phẩm này.", 0);
            }
            String message = added < quantity
                    ? "Chỉ còn " + product.getStockQuantity() + " sản phẩm, đã thêm " + added + " vào giỏ hàng."
                    : "Đã thêm " + added + " sản phẩm vào giỏ hàng.";
            return new AddOutcome(AddStatus.ADDED, message, added);
        } catch (SQLException e) {
            throw new IllegalStateException("Không thêm được sản phẩm vào giỏ hàng", e);
        }
    }

    /** Đổi số lượng một dòng; false khi dòng không tồn tại hoặc vượt tồn kho. */
    public boolean updateQuantity(Cart cart, String key, int quantity) {
        CartItem item = cart.get(key);
        if (item == null) return false;
        if (quantity < 1 || quantity > item.getMaxStock()) return false;
        return cart.updateQuantity(key, quantity);
    }

    public void remove(Cart cart, String key) {
        cart.remove(key);
    }
}
