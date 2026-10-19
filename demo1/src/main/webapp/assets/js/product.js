/* =====================================================================
   PrintKraft - JS RIÊNG của phần sản phẩm. Nạp SAU printkraft.js.
   Mỗi khối tự kiểm tra phần tử có trên trang hay không.
   ===================================================================== */
document.addEventListener('DOMContentLoaded',function(){

    /* Trang danh sách: đổi ô lọc / sắp xếp thì gửi form luôn.
       Gắn class "js-auto-submit" vào <select> cần tự gửi. */
    document.querySelectorAll('.js-auto-submit').forEach(function(sel){
        sel.addEventListener('change',function(){
            if(sel.form)sel.form.submit();
        });
    });

});