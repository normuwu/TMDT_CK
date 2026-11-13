package com.tmdt.util;

import java.io.BufferedReader;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.io.OutputStream;
import java.net.HttpURLConnection;
import java.net.SocketTimeoutException;
import java.net.URL;
import java.nio.charset.StandardCharsets;

public class GeminiUtil {

    private static final String BASE_URL =
            "https://generativelanguage.googleapis.com/v1beta/models/";


    private static final String[] MODELS = {
            "gemini-3.8-flash",
            "gemini-3.6-flash",
            "gemini-3.5-flash-lite"
    };

    // Số lần thử lại cho mỗi model khi gặp 503 / 429
    private static final int MAX_ATTEMPTS_PER_MODEL = 3;

    public static String askGemini(String systemPrompt, String userMessage) {

        String apiKey = System.getenv("GEMINI_API_KEY");

        if (apiKey == null || apiKey.trim().isEmpty()) {
            return "Server chưa cấu hình Gemini API Key.";
        }

        String jsonBody = "{"
                + "\"systemInstruction\":{\"parts\":[{\"text\":"
                + JsonUtil.quote(systemPrompt) + "}]},"
                + "\"contents\":[{\"role\":\"user\",\"parts\":[{\"text\":"
                + JsonUtil.quote(userMessage) + "}]}],"
                + "\"generationConfig\":{"
                + "\"temperature\":0.2,"
                + "\"maxOutputTokens\":2048,"
                + "\"thinkingConfig\":{\"thinkingLevel\":\"low\"}"
                + "}"
                + "}";

        for (String model : MODELS) {

            for (int attempt = 1; attempt <= MAX_ATTEMPTS_PER_MODEL; attempt++) {

                HttpURLConnection connection = null;

                try {
                    URL url = new URL(BASE_URL + model + ":generateContent");
                    connection = (HttpURLConnection) url.openConnection();

                    connection.setRequestMethod("POST");
                    connection.setRequestProperty(
                            "Content-Type", "application/json; charset=UTF-8");
                    connection.setRequestProperty("x-goog-api-key", apiKey);
                    connection.setConnectTimeout(10000);
                    connection.setReadTimeout(30000);
                    connection.setDoOutput(true);

                    System.out.println("[GEMINI] model=" + model + " lần=" + attempt);

                    try (OutputStream output = connection.getOutputStream()) {
                        output.write(jsonBody.getBytes(StandardCharsets.UTF_8));
                    }

                    int statusCode = connection.getResponseCode();

                    InputStream inputStream = (statusCode >= 200 && statusCode < 300)
                            ? connection.getInputStream()
                            : connection.getErrorStream();

                    String responseBody = readResponse(inputStream);

                    // Thành công
                    if (statusCode == 200) {
                        String reply = extractReply(responseBody);

                        if (reply != null && !reply.trim().isEmpty()) {
                            return reply;
                        }

                        System.err.println("[GEMINI] " + model
                                + " trả về nhưng không đọc được nội dung: " + responseBody);
                        break; // thử model kế tiếp
                    }

                    // Quá tải hoặc vượt giới hạn tốc độ: chờ rồi thử lại cùng model
                    if (statusCode == 503 || statusCode == 429) {
                        System.err.println("[GEMINI] " + model + " HTTP " + statusCode
                                + " (lần " + attempt + "/" + MAX_ATTEMPTS_PER_MODEL + ")");

                        if (attempt < MAX_ATTEMPTS_PER_MODEL) {
                            Thread.sleep(1500L * attempt); // 1.5s, 3s
                            continue;
                        }
                        break; // hết lượt thử → model kế tiếp
                    }

                    // 404 (model không còn), 400, 403...: bỏ model này, sang model kế tiếp
                    System.err.println("[GEMINI] " + model + " HTTP "
                            + statusCode + ": " + responseBody);
                    break;

                } catch (SocketTimeoutException e) {

                    System.err.println("[GEMINI] " + model
                            + " hết thời gian chờ: " + e.getMessage());
                    break; // thử model kế tiếp

                } catch (InterruptedException e) {

                    Thread.currentThread().interrupt();
                    return "Yêu cầu bị gián đoạn. Vui lòng thử lại.";

                } catch (Exception e) {

                    System.err.println("[GEMINI] " + model
                            + " lỗi kết nối: " + e.getMessage());
                    break; // thử model kế tiếp

                } finally {

                    if (connection != null) {
                        connection.disconnect();
                    }
                }
            }
        }

        return "AI đang bận. Bạn vui lòng thử lại sau nhé.";
    }

    // Đọc nội dung phản hồi từ Google
    private static String readResponse(InputStream input) throws Exception {

        if (input == null) {
            return "";
        }

        StringBuilder result = new StringBuilder();

        try (BufferedReader reader = new BufferedReader(
                new InputStreamReader(input, StandardCharsets.UTF_8))) {

            String line;

            while ((line = reader.readLine()) != null) {
                result.append(line);
            }
        }

        return result.toString();
    }

    // Tách câu trả lời từ JSON Gemini
    private static String extractReply(String json) {

        int candidates = json.indexOf("\"candidates\"");

        if (candidates == -1) {
            return null;
        }

        int textIndex = json.indexOf("\"text\"", candidates);

        if (textIndex == -1) {
            return null;
        }

        int colon = json.indexOf(':', textIndex);

        if (colon == -1) {
            return null;
        }

        int start = colon + 1;

        while (start < json.length()
                && Character.isWhitespace(json.charAt(start))) {
            start++;
        }

        if (start >= json.length() || json.charAt(start) != '"') {
            return null;
        }

        StringBuilder result = new StringBuilder();

        for (int i = start + 1; i < json.length(); i++) {

            char c = json.charAt(i);

            if (c == '"') {
                return result.toString();
            }

            if (c == '\\') {

                if (++i >= json.length()) {
                    return null;
                }

                char escaped = json.charAt(i);

                switch (escaped) {
                    case '"': result.append('"'); break;
                    case '\\': result.append('\\'); break;
                    case '/': result.append('/'); break;
                    case 'n': result.append('\n'); break;
                    case 'r': result.append('\r'); break;
                    case 't': result.append('\t'); break;
                    case 'b': result.append('\b'); break;
                    case 'f': result.append('\f'); break;

                    case 'u':
                        if (i + 4 >= json.length()) {
                            return null;
                        }

                        try {
                            String hex = json.substring(i + 1, i + 5);
                            result.append((char) Integer.parseInt(hex, 16));
                            i += 4;
                        } catch (NumberFormatException e) {
                            return null;
                        }
                        break;

                    default:
                        return null;
                }

            } else {
                result.append(c);
            }
        }

        return null;
    }
}