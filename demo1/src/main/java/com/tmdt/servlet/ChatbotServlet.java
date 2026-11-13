package com.tmdt.servlet;

import com.tmdt.dao.ProductDAO;
import com.tmdt.model.Product;
import com.tmdt.util.GeminiUtil;
import com.tmdt.util.JsonUtil;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;

@WebServlet("/api/chatbot")
public class ChatbotServlet extends HttpServlet {
    private ProductDAO productDAO;

    @Override
    public void init() throws ServletException {
        productDAO = new ProductDAO();
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setContentType("application/json; charset=UTF-8");

        String userMessage = request.getParameter("message");
        System.out.println("[CHATBOT] 1. nhận message: " + userMessage);

        if (userMessage == null || userMessage.trim().isEmpty()) {
            response.getWriter().write("{\"reply\":\"Bạn hãy nhập câu hỏi nhé.\"}");
            return;
        }

        // 1. Lấy dữ liệu sản phẩm từ DB (lỗi DB thì bỏ qua, vẫn trả lời được)
        StringBuilder dbContext = new StringBuilder();
        try {
            List<Product> products = productDAO.getTopNewProducts(5);
            System.out.println("[CHATBOT] 2. DB xong, số sp: "
                    + (products == null ? 0 : products.size()));
            if (products != null && !products.isEmpty()) {
                dbContext.append("Danh sách sản phẩm cửa hàng đang bán (Giá VNĐ):\n");
                for (Product p : products) {
                    dbContext.append("- ").append(p.getName())
                            .append(": Giá ").append(p.getPrice()).append(" VNĐ\n");
                }
            }
        } catch (Exception e) {
            System.err.println("[CHATBOT] DB lỗi: " + e);
            e.printStackTrace();
        }

        // 2. System prompt
        String systemPrompt = "Bạn là trợ lý AI ảo của hệ thống In 3D PrintKraft. "
                + "Bạn chỉ được trả lời thông tin dựa trên dữ liệu sau đây. "
                + "Nếu khách hàng hỏi ngoài lề (thời tiết, toán học, chính trị, code, v.v.), "
                + "hãy từ chối lịch sự và nói rằng bạn chỉ hỗ trợ dịch vụ PrintKraft.\n\n"
                + "Chính sách của PrintKraft:\n"
                + "- Phí vận chuyển: Miễn phí cho đơn từ 500k. Đơn dưới 500k phí 30k.\n"
                + "- Thời gian in: Mô hình 3D (1-3 ngày), Áo thun (3-5 ngày).\n"
                + "- Trả hàng: Đổi trả trong 7 ngày nếu lỗi từ xưởng.\n\n"
                + dbContext;

        // 3. Gọi Gemini
        System.out.println("[CHATBOT] 3. gọi Gemini...");
        String aiReply = GeminiUtil.askGemini(systemPrompt, userMessage);
        System.out.println("[CHATBOT] 4. Gemini xong: " + aiReply);

        // 4. Trả JSON
        response.getWriter().write("{\"reply\":" + JsonUtil.quote(aiReply) + "}");
    }
}