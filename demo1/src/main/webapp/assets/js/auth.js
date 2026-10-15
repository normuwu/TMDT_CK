/* Auth package — shared logic for sign in / sign up / NCC / forgot / profile / admin accounts */

const $ = (s) => document.querySelector(s);
const $$ = (s) => [...document.querySelectorAll(s)];

let toastTimer;

function toast(message) {
  const t = $('#toast');
  if (!t) return;
  t.textContent = message;
  t.classList.add('show');
  clearTimeout(toastTimer);
  toastTimer = setTimeout(() => t.classList.remove('show'), 2800);
}

/* ---------- Top nav clicks ---------- */
document.addEventListener('click', (e) => {
  const link = e.target.closest('.sw a');
  if (!link) return;

  const href = link.getAttribute('href');
  if (!href || href.startsWith('#')) return;

  /* Mark active */
  $$('.sw a').forEach((a) => a.classList.toggle('on', a === link));

  /* Show the matching screen by id (if it exists on this page) */
  const target = document.getElementById(
    href
      .replace(/^Auth\/|\/.*$/, '')
      .replace(/Đăng-nhập|Đăng.nhập|ĐăngNhập|dang.nhap|dangnhap/, 'login')
      .replace(/Tạo-tài-khoản|Tạo.tài.khoản|TạoTàiKhoản|dang.ky/, 'register')
      .replace(/Đăng-ký-NCC|Đăng.ký.NCC|ĐăngKýNCC|dang.ky.ncc|dangkncc/, 'ncc')
      .replace(/Quên-mật-khẩu|Quên.mật.khẩu|QuênMậtKhẩu|quen.mat.khau|quenmk/, 'forgot')
      .replace(/Chỉnh-sửa-thông-tin|Chỉnh.sửa.thông.tin|ChỉnhSửaThôngTin|tai.khoan|taikhoan|profile/, 'profile')
      .replace(/Quản-lý-tài-khoản|Quản.lý.tài.khoản|QuảnLýTàiKhoản|quan.ly.tai.khoan|quanlytaikhoan|accounts/, 'accounts')
  );
  if (!target) return;

  $$('.screen').forEach((s) => s.classList.remove('on'));
  target.classList.add('on');

  /* Swipe back to top (optional) */
  window.scrollTo({ top: 0, behavior: 'smooth' });
});

/* ---------- Chip toggling (NCC form) ---------- */
document.addEventListener('click', (e) => {
  const chip = e.target.closest('.chip');
  if (!chip) return;
  chip.classList.toggle('on');
});

/* ---------- Form submissions ---------- */
document.addEventListener('submit', (e) => {
  e.preventDefault();

  /* Forgot password flow */
  const f = e.target;
  if (f.dataset.act === 'forgot') {
    const input = f.querySelector('input[type="email"]');
    const email = input ? input.value.trim() : '';
    if (!email) {
      toast('Vui lòng nhập email để tiếp tục');
      return;
    }
    const fm = document.getElementById('fm');
    if (fm) fm.textContent = email;
    const f1 = document.getElementById('f1');
    const f2 = document.getElementById('f2');
    if (f1) f1.classList.add('hide');
    if (f2) f2.classList.remove('hide');
    toast('Đã gửi liên kết đặt lại');
    return;
  }

  /* Generic success toast for other forms */
  if (f.dataset.msg) {
    toast(f.dataset.msg);
  } else {
    toast('Đã xử lý yêu cầu');
  }
});

/* ---------- Resend link (forgot password) ---------- */
document.addEventListener('click', (e) => {
  if (e.target.dataset && e.target.dataset.act === 'resend') {
    toast('Đã gửi lại liên kết');
  }
});
