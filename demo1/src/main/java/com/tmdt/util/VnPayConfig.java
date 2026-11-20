package com.tmdt.util;

import jakarta.servlet.http.HttpServletRequest;

import javax.crypto.Mac;
import javax.crypto.spec.SecretKeySpec;
import java.io.InputStream;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.time.LocalDateTime;
import java.time.ZoneId;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.Collections;
import java.util.Enumeration;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.Properties;

/**
 * Cấu hình và tiện ích ký số HMAC-SHA512 cho cổng thanh toán VNPay Sandbox (v2.1.0).
 * Có thể cấu hình qua file src/main/resources/vnpay.properties hoặc sửa trực tiếp hằng số DEFAULT_*.
 */
public final class VnPayConfig {

    public static final String VNP_PAY_URL = "https://sandbox.vnpayment.vn/paymentv2/vpcpay.html";
    public static final String VNP_VERSION = "2.1.0";
    public static final String VNP_COMMAND = "pay";
    public static final String VNP_ORDER_TYPE = "other";

    // Thay bằng mã TMN_CODE và HASH_SECRET từ email đăng ký VNPay Sandbox của bạn
    private static final String DEFAULT_TMN_CODE = "CGXZLS0Z";
    private static final String DEFAULT_HASH_SECRET = "XNBCJFAKAZQSGTARRLGCHVZWCIOIGSHN";

    private static final String TMN_CODE;
    private static final String HASH_SECRET;

    private static final DateTimeFormatter VNP_TIME_FMT = DateTimeFormatter.ofPattern("yyyyMMddHHmmss");
    private static final ZoneId VN_ZONE = ZoneId.of("Asia/Ho_Chi_Minh");

    static {
        Properties props = new Properties();
        try (InputStream in = VnPayConfig.class.getClassLoader().getResourceAsStream("vnpay.properties")) {
            if (in != null) {
                props.load(in);
            }
        } catch (Exception ignored) {
        }
        TMN_CODE = props.getProperty("vnp.tmnCode",
                System.getProperty("vnp.tmnCode", DEFAULT_TMN_CODE)).trim();
        HASH_SECRET = props.getProperty("vnp.hashSecret",
                System.getProperty("vnp.hashSecret", DEFAULT_HASH_SECRET)).trim();
    }

    private VnPayConfig() {
    }

    /**
     * Tạo URL chuyển hướng sang cổng thanh toán VNPay Sandbox.
     *
     * @param request   HttpServletRequest để lấy IP và tạo ReturnUrl động theo contextPath
     * @param txnRef    Mã tham chiếu giao dịch duy nhất (chứa danh sách orderId)
     * @param amountVnd Số tiền thanh toán (VNĐ) — VNPay quy định nhân 100
     * @param orderInfo Nội dung thanh toán (không dấu)
     */
    public static String buildPaymentUrl(HttpServletRequest request, String txnRef,
                                         long amountVnd, String orderInfo) {
        Map<String, String> vnpParams = new HashMap<>();
        vnpParams.put("vnp_Version", VNP_VERSION);
        vnpParams.put("vnp_Command", VNP_COMMAND);
        vnpParams.put("vnp_TmnCode", TMN_CODE);
        vnpParams.put("vnp_Amount", String.valueOf(Math.max(0L, amountVnd) * 100L));
        vnpParams.put("vnp_CurrCode", "VND");
        vnpParams.put("vnp_TxnRef", txnRef);
        vnpParams.put("vnp_OrderInfo", orderInfo);
        vnpParams.put("vnp_OrderType", VNP_ORDER_TYPE);
        vnpParams.put("vnp_Locale", "vn");
        vnpParams.put("vnp_ReturnUrl", buildReturnUrl(request));
        vnpParams.put("vnp_IpAddr", getClientIp(request));

        LocalDateTime now = LocalDateTime.now(VN_ZONE);
        vnpParams.put("vnp_CreateDate", now.format(VNP_TIME_FMT));
        vnpParams.put("vnp_ExpireDate", now.plusMinutes(15).format(VNP_TIME_FMT));

        List<String> fieldNames = new ArrayList<>(vnpParams.keySet());
        Collections.sort(fieldNames);

        StringBuilder hashData = new StringBuilder();
        StringBuilder query = new StringBuilder();

        Iterator<String> itr = fieldNames.iterator();
        while (itr.hasNext()) {
            String fieldName = itr.next();
            String fieldValue = vnpParams.get(fieldName);
            if (fieldValue != null && !fieldValue.isEmpty()) {
                String encodedName = URLEncoder.encode(fieldName, StandardCharsets.US_ASCII);
                String encodedValue = URLEncoder.encode(fieldValue, StandardCharsets.US_ASCII);

                hashData.append(fieldName).append('=').append(encodedValue);
                query.append(encodedName).append('=').append(encodedValue);

                if (itr.hasNext()) {
                    hashData.append('&');
                    query.append('&');
                }
            }
        }

        String vnpSecureHash = hmacSHA512(HASH_SECRET, hashData.toString());
        query.append("&vnp_SecureHash=").append(vnpSecureHash);
        return VNP_PAY_URL + "?" + query;
    }

    /**
     * Kiểm tra tính toàn vẹn chữ ký vnp_SecureHash khi VNPay redirect về.
     */
    public static boolean verifyReturn(HttpServletRequest request) {
        String receivedHash = request.getParameter("vnp_SecureHash");
        if (receivedHash == null || receivedHash.isBlank()) {
            return false;
        }

        Map<String, String> fields = new HashMap<>();
        Enumeration<String> params = request.getParameterNames();
        while (params.hasMoreElements()) {
            String paramName = params.nextElement();
            if ("vnp_SecureHash".equals(paramName) || "vnp_SecureHashType".equals(paramName)) {
                continue;
            }
            if (paramName != null && paramName.startsWith("vnp_")) {
                String paramValue = request.getParameter(paramName);
                if (paramValue != null && !paramValue.isEmpty()) {
                    fields.put(paramName, URLEncoder.encode(paramValue, StandardCharsets.US_ASCII));
                }
            }
        }

        List<String> fieldNames = new ArrayList<>(fields.keySet());
        Collections.sort(fieldNames);

        StringBuilder hashData = new StringBuilder();
        for (int i = 0; i < fieldNames.size(); i++) {
            String key = fieldNames.get(i);
            String val = fields.get(key);
            if (val != null && !val.isEmpty()) {
                if (hashData.length() > 0) {
                    hashData.append('&');
                }
                hashData.append(key).append('=').append(val);
            }
        }

        String calculatedHash = hmacSHA512(HASH_SECRET, hashData.toString());
        return calculatedHash.equalsIgnoreCase(receivedHash.trim());
    }

    public static String hmacSHA512(String key, String data) {
        try {
            if (key == null || data == null) return "";
            Mac hmac512 = Mac.getInstance("HmacSHA512");
            SecretKeySpec secretKey = new SecretKeySpec(key.getBytes(StandardCharsets.UTF_8), "HmacSHA512");
            hmac512.init(secretKey);
            byte[] result = hmac512.doFinal(data.getBytes(StandardCharsets.UTF_8));
            StringBuilder sb = new StringBuilder(2 * result.length);
            for (byte b : result) {
                sb.append(String.format("%02x", b & 0xff));
            }
            return sb.toString();
        } catch (Exception e) {
            return "";
        }
    }

    private static String buildReturnUrl(HttpServletRequest request) {
        String scheme = request.getScheme();
        String serverName = request.getServerName();
        int serverPort = request.getServerPort();
        String contextPath = request.getContextPath();

        StringBuilder url = new StringBuilder();
        url.append(scheme).append("://").append(serverName);
        if (("http".equalsIgnoreCase(scheme) && serverPort != 80)
                || ("https".equalsIgnoreCase(scheme) && serverPort != 443)) {
            url.append(':').append(serverPort);
        }
        url.append(contextPath).append(Views.VNPAY_RETURN_URL);
        return url.toString();
    }

    private static String getClientIp(HttpServletRequest request) {
        String ip = request.getHeader("X-Forwarded-For");
        if (ip != null && !ip.isBlank()) {
            ip = ip.split(",")[0].trim();
        } else {
            ip = request.getRemoteAddr();
        }
        if (ip == null || ip.isBlank() || "0:0:0:0:0:0:0:1".equals(ip) || "::1".equals(ip)) {
            return "127.0.0.1";
        }
        return ip;
    }
}