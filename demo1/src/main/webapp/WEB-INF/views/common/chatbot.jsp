<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%--
  Widget trợ lý ảo AI (Gọi xuống Java Servlet để lấy phản hồi từ Gemini API).
--%>
<c:set var="ctx" value="${pageContext.request.contextPath}"/>

<style>
  .pk-chat-launch{position:fixed;right:22px;bottom:22px;z-index:80;width:58px;height:58px;border-radius:50%;
    border:none;background:var(--grad-primary,#6C5CE7);color:#fff;font-size:24px;cursor:pointer;
    box-shadow:0 12px 30px rgba(108,92,231,.42);transition:transform .2s}
  .pk-chat-launch:hover{transform:translateY(-3px)}
  .pk-chat{position:fixed;right:22px;bottom:92px;z-index:80;width:360px;max-width:calc(100vw - 32px);
    height:520px;max-height:calc(100vh - 130px);background:#fff;border:1px solid rgba(27,27,47,.12);
    border-radius:18px;display:none;flex-direction:column;overflow:hidden;
    box-shadow:0 24px 60px rgba(27,27,47,.24)}
  .pk-chat.open{display:flex}
  .pk-chat-head{background:var(--grad-primary,#6C5CE7);color:#fff;padding:14px 16px;display:flex;align-items:center;gap:10px}
  .pk-chat-head strong{font-size:14.5px;display:block}
  .pk-chat-head span{font-size:11.5px;opacity:.85}
  .pk-chat-head button{margin-left:auto;background:transparent;border:none;color:#fff;font-size:18px;cursor:pointer}
  .pk-chat-body{flex:1;overflow-y:auto;padding:14px;background:#FBF9FF;display:flex;flex-direction:column;gap:10px}
  .pk-msg{max-width:82%;padding:10px 13px;border-radius:14px;font-size:13.5px;line-height:1.5; white-space: pre-wrap;}
  .pk-msg.bot{background:#fff;border:1px solid rgba(27,27,47,.10);align-self:flex-start;border-bottom-left-radius:4px}
  .pk-msg.me{background:#6C5CE7;color:#fff;align-self:flex-end;border-bottom-right-radius:4px}
  .pk-quick{display:flex;flex-wrap:wrap;gap:6px;padding:0 14px 10px;background:#FBF9FF}
  .pk-quick button{border:1px solid rgba(108,92,231,.35);background:#fff;color:#6C5CE7;
    border-radius:999px;padding:6px 11px;font-size:12px;cursor:pointer}
  .pk-chat-foot{display:flex;gap:8px;padding:10px;border-top:1px solid rgba(27,27,47,.10);background:#fff}
  .pk-chat-foot input{flex:1;min-width:0;border:1.5px solid rgba(27,27,47,.16);border-radius:999px;
    padding:9px 14px;font-size:13px;outline:none}
  .pk-chat-foot input:focus{border-color:#6C5CE7}
  .pk-chat-foot button{border:none;background:var(--grad-primary,#6C5CE7);color:#fff;border-radius:999px;
    padding:0 16px;font-weight:600;cursor:pointer}
  .pk-chat-foot button:disabled {background: #ccc; cursor: not-allowed;}
</style>

<button type="button" class="pk-chat-launch" id="pkChatLaunch" aria-label="Mở trợ lý ảo">💬</button>

<div class="pk-chat" id="pkChat" role="dialog" aria-label="Trợ lý AI PrintKraft">
  <div class="pk-chat-head">
    <div>
      <strong>Trợ lý AI PrintKraft</strong>
      <span>Thường trả lời trong vài giây</span>
    </div>
    <button type="button" id="pkChatClose" aria-label="Đóng">✕</button>
  </div>
  <div class="pk-chat-body" id="pkChatBody" aria-live="polite"></div>
  <div class="pk-quick" id="pkChatQuick"></div>
  <form class="pk-chat-foot" id="pkChatForm">
    <input type="text" id="pkChatInput" maxlength="300" autocomplete="off"
           placeholder="Hỏi AI về đơn hàng, vật liệu, giá cả...">
    <button type="submit" id="pkChatSubmitBtn">Gửi</button>
  </form>
</div>

<script>
(function () {
  var ctx = "<c:out value='${ctx}'/>";
  var sessEl = document.getElementById('pk-session');
  var csrf = sessEl ? sessEl.dataset.csrf : '';
  var launch = document.getElementById('pkChatLaunch');
  var panel = document.getElementById('pkChat');
  var body = document.getElementById('pkChatBody');
  var form = document.getElementById('pkChatForm');
  var input = document.getElementById('pkChatInput');
  var submitBtn = document.getElementById('pkChatSubmitBtn');
  var quick = document.getElementById('pkChatQuick');
  var isSending = false;
  if (!launch || !panel || !body) return;

  // Hàm tạo bong bóng chat
  function bubble(text, mine) {
    var div = document.createElement('div');
    div.className = 'pk-msg ' + (mine ? 'me' : 'bot');
    div.textContent = text;
    body.appendChild(div);
    body.scrollTop = body.scrollHeight;
    return div;
  }

  // Hàm gửi tin nhắn qua Servlet API

  // Hàm gửi tin nhắn qua Servlet API
  function send(text) {

    var t = String(text || '').trim();

    // Không gửi nếu đang có yêu cầu chưa hoàn thành
    if (!t || isSending) return;

    isSending = true;

    // Hiện lời người dùng
    bubble(t, true);
    input.value = '';

    // Khóa các nút gửi
    submitBtn.disabled = true;
    input.disabled = true;

    // Khóa các nút hỏi nhanh
    var quickButtons = quick.querySelectorAll('button');

    quickButtons.forEach(function(button) {
      button.disabled = true;
    });

    // Hiện trạng thái chờ
    var typing = bubble('AI đang suy nghĩ...', false);

    // Gửi AJAX POST đến ChatbotServlet
    fetch(ctx + '/api/chatbot', {
      method: 'POST',
      headers: {
        'Content-Type': 'application/x-www-form-urlencoded; charset=UTF-8'
      },
      body: 'message=' + encodeURIComponent(t)
           + '&csrfToken=' + encodeURIComponent(csrf)
    })
    .then(function(response) {

      if (!response.ok) {
        throw new Error('HTTP Error: ' + response.status);
      }

      return response.json();
    })
    .then(function(data) {

      // Xóa trạng thái đang suy nghĩ
      if (typing.parentNode) {
        typing.parentNode.removeChild(typing);
      }

      // Hiển thị câu trả lời từ Gemini
      if (data && data.reply) {
        bubble(data.reply, false);
      } else {
        bubble('Xin lỗi, AI không có câu trả lời lúc này.', false);
      }
    })
    .catch(function(error) {

      if (typing.parentNode) {
        typing.parentNode.removeChild(typing);
      }

      bubble('Lỗi kết nối máy chủ AI. Vui lòng thử lại sau!', false);

      console.error('Chatbot API Error:', error);
    })
    .finally(function() {

      // Cho phép gửi câu hỏi tiếp theo
      isSending = false;

      submitBtn.disabled = false;
      input.disabled = false;

      quickButtons.forEach(function(button) {
        button.disabled = false;
      });

      input.focus();
    });
  }


  // Khởi tạo các nút hỏi nhanh
  ['Phí ship thế nào?', 'Thời gian in bao lâu?', 'Bạn có bán áo thun không?']
    .forEach(function (q) {
      var b = document.createElement('button');
      b.type = 'button';
      b.textContent = q;
      b.addEventListener('click', function () { send(q); });
      quick.appendChild(b);
    });

  function open() {
    panel.classList.add('open');
    launch.style.display = 'none';
    input.focus();
    if (!body.childNodes.length) {
      bubble('Chào bạn! Mình là AI của PrintKraft. Bạn cần tư vấn thông tin gì?', false);
    }
    try { sessionStorage.setItem('pk_chat_opened', '1'); } catch (e) {}
  }

  function close() {
    panel.classList.remove('open');
    launch.style.display = '';
  }

  launch.addEventListener('click', open);
  document.getElementById('pkChatClose').addEventListener('click', close);

  form.addEventListener('submit', function (e) {
      e.preventDefault();
      send(input.value);
  });

  document.addEventListener('keydown', function (e) {
    if (e.key === 'Escape' && panel.classList.contains('open')) close();
  });

  try {
    if (!sessionStorage.getItem('pk_chat_opened')) {
      sessionStorage.setItem('pk_chat_opened', '1');
      setTimeout(open, 6000);
    }
  } catch (e) {}
})();
</script>