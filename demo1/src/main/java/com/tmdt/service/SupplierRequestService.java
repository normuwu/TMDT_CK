package com.tmdt.service;

import com.tmdt.dao.SupplierRequestDAO;
import com.tmdt.dao.UserDAO;
import com.tmdt.model.Role;
import com.tmdt.model.SupplierRequest;
import com.tmdt.model.User;
import com.tmdt.model.UserStatus;
import com.tmdt.util.DBConnection;
import com.tmdt.util.ValidationUtil;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.sql.Connection;
import java.sql.SQLException;
import java.sql.SQLIntegrityConstraintViolationException;
import java.util.LinkedHashMap;
import java.util.Map;
import java.util.Optional;

/**
 * Nghiệp vụ "Xin làm Nhà cung cấp" phía người dùng.
 *
 * Quy tắc:
 *  - Chỉ tài khoản đang ACTIVE và có role CUSTOMER mới được gửi yêu cầu.
 *  - Mỗi user chỉ có tối đa một yêu cầu PENDING (chặn cả ở service và ở
 *    UNIQUE KEY uq_supplier_requests_pending của DB).
 *  - Gửi yêu cầu KHÔNG đổi users.role; role chỉ đổi khi Admin duyệt
 *    (xem AdminSupplierRequestService).
 *  - Bị từ chối thì được gửi lại: mỗi lần gửi là một dòng mới, giữ lịch sử.
 *
 * Người dùng không bao giờ truyền role/status/userId vào service này —
 * userId lấy từ session ở servlet.
 */
public class SupplierRequestService {

    private static final Logger LOG = LoggerFactory.getLogger(SupplierRequestService.class);

    /** Độ dài tối đa mirror cột trong supplier_requests. */
    public static final int SHOP_NAME_MAX = 150;
    public static final int ADDRESS_MAX = 300;
    public static final int DESCRIPTION_MAX = 2000;

    public static final String MSG_SENT =
            "Đã gửi yêu cầu trở thành Nhà cung cấp. Vui lòng chờ Admin phê duyệt.";

    private final SupplierRequestDAO dao = new SupplierRequestDAO();
    private final UserDAO userDAO = new UserDAO();

    public enum SubmitStatus { SUCCESS, DUPLICATE, NOT_ELIGIBLE, VALIDATION_ERROR, SYSTEM_ERROR }

    /** `fieldErrors` chỉ có giá trị khi status = VALIDATION_ERROR. */
    public record SubmitOutcome(SubmitStatus status, Map<String, String> fieldErrors) {
        static SubmitOutcome ok() {
            return new SubmitOutcome(SubmitStatus.SUCCESS, Map.of());
        }

        static SubmitOutcome of(SubmitStatus status) {
            return new SubmitOutcome(status, Map.of());
        }

        static SubmitOutcome invalid(Map<String, String> errors) {
            return new SubmitOutcome(SubmitStatus.VALIDATION_ERROR, errors);
        }
    }

    /** Yêu cầu mới nhất của user, rỗng nếu chưa từng gửi. */
    public Optional<SupplierRequest> latest(int userId) throws SQLException {
        return dao.findLatestByUser(userId);
    }

    /** Tài khoản đang đăng nhập, đọc mới từ DB (null nếu đã bị xóa). */
    public User loadUser(int userId) throws SQLException {
        return userDAO.findById(userId).orElse(null);
    }

    public SubmitOutcome submit(int userId, String shopNameRaw, String contactPhoneRaw,
                                String addressRaw, String descriptionRaw) {
        Map<String, String> errors = new LinkedHashMap<>();

        String shopName = shopNameRaw == null ? "" : shopNameRaw.trim();
        String phone = ValidationUtil.normalizePhone(contactPhoneRaw);
        String address = addressRaw == null ? "" : addressRaw.trim();
        String description = descriptionRaw == null ? "" : descriptionRaw.trim();

        if (shopName.isEmpty()) {
            errors.put("shopName", "Vui lòng nhập tên cửa hàng / xưởng in.");
        } else if (shopName.length() > SHOP_NAME_MAX) {
            errors.put("shopName", "Tên cửa hàng tối đa " + SHOP_NAME_MAX + " ký tự.");
        }
        if (!ValidationUtil.isValidVnPhone(phone)) {
            errors.put("contactPhone",
                    "Số điện thoại chưa hợp lệ (10 số, bắt đầu bằng 0, ví dụ 0901234567).");
        }
        if (address.isEmpty()) {
            errors.put("address", "Vui lòng nhập địa chỉ xưởng.");
        } else if (address.length() > ADDRESS_MAX) {
            errors.put("address", "Địa chỉ tối đa " + ADDRESS_MAX + " ký tự.");
        }
        if (description.length() > DESCRIPTION_MAX) {
            errors.put("description", "Mô tả tối đa " + DESCRIPTION_MAX + " ký tự.");
        }
        if (!errors.isEmpty()) {
            return SubmitOutcome.invalid(errors);
        }

        String descriptionOrNull = description.isEmpty() ? null : description;

        try (Connection conn = DBConnection.getConnection()) {
            conn.setAutoCommit(false);
            try {
                Optional<User> current = userDAO.findById(conn, userId);
                if (current.isEmpty() || current.get().getStatus() == UserStatus.LOCKED) {
                    conn.rollback();
                    return SubmitOutcome.of(SubmitStatus.NOT_ELIGIBLE);
                }
                if (current.get().getRole() != Role.CUSTOMER) {
                    conn.rollback();
                    return SubmitOutcome.of(SubmitStatus.NOT_ELIGIBLE);
                }
                // Đã là nhà cung cấp (có hồ sơ) thì không nhận yêu cầu mới.
                if (dao.hasSupplierProfile(conn, userId)) {
                    conn.rollback();
                    return SubmitOutcome.of(SubmitStatus.NOT_ELIGIBLE);
                }
                if (dao.findPending(conn, userId).isPresent()) {
                    conn.rollback();
                    return SubmitOutcome.of(SubmitStatus.DUPLICATE);
                }

                dao.insertPending(conn, userId, shopName, phone, address, descriptionOrNull);
                conn.commit();
                LOG.info("Supplier request submitted userId={}", userId);
                return SubmitOutcome.ok();
            } catch (SQLIntegrityConstraintViolationException e) {
                conn.rollback();
                String message = e.getMessage() == null ? "" : e.getMessage();
                if (message.contains("uq_supplier_requests_pending")) {
                    // Hai request đồng thời: DB là chốt chặn cuối cùng.
                    return SubmitOutcome.of(SubmitStatus.DUPLICATE);
                }
                LOG.error("Supplier request insert constraint failure userId={}", userId, e);
                return SubmitOutcome.of(SubmitStatus.SYSTEM_ERROR);
            } catch (SQLException e) {
                conn.rollback();
                throw e;
            }
        } catch (SQLException e) {
            LOG.error("Supplier request DB failure userId={}", userId, e);
            return SubmitOutcome.of(SubmitStatus.SYSTEM_ERROR);
        }
    }
}
