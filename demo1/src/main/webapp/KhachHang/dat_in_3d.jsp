<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%--
  Trang đặt in 3D theo yêu cầu.
  CSS : assets/css/printkraft.css (dùng chung) + assets/css/dat-in-3d.css (riêng trang)
  JS  : three.min.js (CDN) -> assets/js/printkraft.js (dùng chung) -> assets/js/dat-in-3d.js (riêng trang)
  LƯU Ý: web.xml tắt EL cho mọi *.jsp ngoài WEB-INF/views/auth, common và product, nên trang
  này KHÔNG dùng cú pháp EL; đường dẫn context lấy bằng request.getContextPath().
--%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>PrintKraft — Đặt in 3D theo yêu cầu</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link href="https://fonts.googleapis.com/css2?family=Space+Grotesk:wght@400;500;600;700&family=IBM+Plex+Sans:wght@400;500;600&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="<%= request.getContextPath() %>/assets/css/printkraft.css">
    <link rel="stylesheet" href="<%= request.getContextPath() %>/assets/css/dat-in-3d.css">
</head>
<body data-page="studio">
<jsp:include page="/WEB-INF/views/common/session-info.jsp" />

<!-- Header + menu do printkraft.js vẽ (mục "Tự thiết kế" được tô sáng nhờ data-page="studio") -->
<div id="site-header"></div>
<jsp:include page="/WEB-INF/views/common/cart-drawer.jsp" />

<main>
    <div class="page-head">
        <span class="eyebrow-line">In 3D theo yêu cầu</span>
        <h1>Đặt in mô hình 3D của bạn</h1>
        <p>Tải file lên, chọn công nghệ và vật liệu, xem trước mô hình — xưởng sẽ kiểm tra file và xác nhận báo giá cho bạn. Bạn không cần biết kỹ thuật in để bắt đầu.</p>
        <div class="flow-hint">
            <span><b>1</b> Tải mô hình</span>
            <span><b>2</b> Cấu hình sản phẩm</span>
            <span><b>3</b> Xem trước</span>
            <span><b>4</b> Gửi yêu cầu in</span>
        </div>
    </div>

    <div class="section">
        <div class="order3d">

            <!-- ============================================================
                 CỘT TRÁI — PREVIEW 3D
                 ============================================================ -->
            <section class="viewer-col" aria-label="Xem trước mô hình 3D">
                <div class="studio-preview">
                    <div class="preview-stage" id="stage">
                        <div class="stage-badge" id="stageBadge">Chưa có mô hình</div>
                        <div class="stage-empty" id="stageEmpty">
                            <div class="ic">⬆</div>
                            <h4>Chưa có mô hình để hiển thị</h4>
                            <p>Tải file 3D ở cột bên phải để xem trước, đo kích thước và thể tích.</p>
                        </div>
                        <div class="stage-hint" id="stageHint" style="display:none;">Kéo để xoay · Lăn chuột để zoom · Giữ Shift để di chuyển</div>
                    </div>

                    <div class="preview-tools">
                        <button type="button" id="btnSpin" disabled>Tự xoay</button>
                        <button type="button" id="btnZoomIn" disabled>Phóng to</button>
                        <button type="button" id="btnZoomOut" disabled>Thu nhỏ</button>
                        <button type="button" id="btnTop" disabled>Nhìn từ trên</button>
                        <button type="button" id="btnReset" disabled>Đặt lại góc nhìn</button>
                    </div>

                    <div class="dims">
                        <div class="dim"><span>X</span><strong id="dimX">—</strong></div>
                        <div class="dim"><span>Y</span><strong id="dimY">—</strong></div>
                        <div class="dim"><span>Z</span><strong id="dimZ">—</strong></div>
                        <div class="dim vol"><span>Thể tích</span><strong id="dimV">—</strong></div>
                    </div>

                    <div class="file-card" id="fileCard" style="display:none;">
                        <div class="ft" id="fileExt">STL</div>
                        <div class="fi">
                            <strong id="fileName">—</strong>
                            <span id="fileMeta">—</span>
                        </div>
                        <div class="fa">
                            <button type="button" id="btnReplace">Đổi file</button>
                            <button type="button" class="danger" id="btnRemove">Xoá</button>
                        </div>
                    </div>

                    <div class="check-panel" id="checkPanel">
                        <h5>Kiểm tra mô hình</h5>
                        <div id="checkList">
                            <div class="check-row"><span class="ic">·</span><span>Chưa có file để kiểm tra.</span></div>
                        </div>
                    </div>
                </div>
            </section>

            <!-- ============================================================
                 CỘT PHẢI — FORM CẤU HÌNH
                 ============================================================ -->
            <form class="config-col" id="orderForm" novalidate>

                <!-- 1. Upload -->
                <section class="panel" aria-label="Tải mô hình 3D">
                    <h3>Mô hình 3D</h3>
                    <p class="sub">Định dạng hỗ trợ: STL, OBJ, 3MF, STEP/STP. Dung lượng tối đa 60 MB.</p>

                    <div class="dropzone" id="dropzone" tabindex="0" role="button" aria-label="Chọn file mô hình 3D">
                        <div class="ic">⬆</div>
                        <h4>Tải lên mô hình 3D</h4>
                        <p>Kéo thả file vào đây, hoặc chọn file từ máy để bắt đầu đặt in.</p>
                        <span class="btn-primary btn-sm">Chọn file</span>
                        <div class="formats">
                            <span class="pill">.STL</span><span class="pill">.OBJ</span>
                            <span class="pill">.3MF</span><span class="pill">.STEP</span><span class="pill">.STP</span>
                        </div>
                    </div>
                    <input type="file" id="fileInput" accept=".stl,.obj,.3mf,.step,.stp" hidden>

                    <div class="opt-group" style="margin:24px 0 0;">
                        <label for="qtyInput">Số lượng</label>
                        <div class="qty-box">
                            <div class="qty-ctrl">
                                <button type="button" id="qtyMinus" aria-label="Giảm số lượng">−</button>
                                <input type="number" id="qtyInput" value="1" min="1" step="1" inputmode="numeric" aria-label="Số lượng">
                                <button type="button" id="qtyPlus" aria-label="Tăng số lượng">+</button>
                            </div>
                            <div class="hint">Tối thiểu 1 sản phẩm. Đơn từ 20 sản phẩm được báo giá sỉ.</div>
                        </div>
                    </div>
                </section>

                <!-- 2. Kích thước -->
                <section class="panel" aria-label="Kích thước sản phẩm">
                    <h3>Kích thước sản phẩm</h3>
                    <p class="sub">Giữ nguyên kích thước file, phóng theo tỷ lệ phần trăm, hoặc nhập kích thước mong muốn.</p>

                    <div class="chips" id="sizeModes" style="margin-bottom:18px;">
                        <button type="button" class="chip active" data-mode="default">Kích thước gốc</button>
                        <button type="button" class="chip" data-mode="scale">Phóng theo %</button>
                        <button type="button" class="chip" data-mode="custom">Nhập kích thước</button>
                    </div>

                    <div id="sizeDefault">
                        <div class="field-row">
                            <div class="field"><label>X</label><input type="text" id="defX" value="—" readonly></div>
                            <div class="field"><label>Y</label><input type="text" id="defY" value="—" readonly></div>
                            <div class="field"><label>Z</label><input type="text" id="defZ" value="—" readonly></div>
                        </div>
                        <p class="opt-note">Sản phẩm được in đúng kích thước trong file bạn tải lên.</p>
                    </div>

                    <div id="sizeScale" style="display:none;">
                        <div class="field" style="max-width:200px;">
                            <label for="scaleInput">Tỷ lệ (%)</label>
                            <input type="number" id="scaleInput" value="100" min="1" max="1000" step="1">
                        </div>
                        <div class="chips" id="scalePresets" style="margin:-4px 0 14px;">
                            <button type="button" class="chip" data-scale="50">50%</button>
                            <button type="button" class="chip" data-scale="100">100%</button>
                            <button type="button" class="chip" data-scale="150">150%</button>
                            <button type="button" class="chip" data-scale="200">200%</button>
                        </div>
                        <p class="opt-note">Kích thước sau khi phóng: <b id="scaleResult">—</b></p>
                    </div>

                    <div id="sizeCustom" style="display:none;">
                        <div class="field-row">
                            <div class="field"><label for="cusX">X (mm)</label><input type="number" id="cusX" min="0.1" step="0.1"></div>
                            <div class="field"><label for="cusY">Y (mm)</label><input type="number" id="cusY" min="0.1" step="0.1"></div>
                            <div class="field"><label for="cusZ">Z (mm)</label><input type="number" id="cusZ" min="0.1" step="0.1"></div>
                        </div>
                        <label style="display:flex; gap:9px; align-items:center; font-size:13.5px; cursor:pointer;">
                            <input type="checkbox" id="lockRatio" checked style="width:17px;height:17px; accent-color:var(--violet);">
                            Giữ tỷ lệ — thay đổi một chiều, hai chiều còn lại tự đổi theo
                        </label>
                    </div>
                </section>

                <!-- 3. Công nghệ + vật liệu -->
                <section class="panel" aria-label="Công nghệ và vật liệu">
                    <h3>Công nghệ in</h3>
                    <p class="sub">Không chắc chọn gì? FDM phù hợp với phần lớn nhu cầu thông thường.</p>
                    <div class="opt-cards" id="techList"></div>

                    <div class="opt-group" style="margin:26px 0 0;">
                        <span class="opt-label">Vật liệu</span>
                        <div class="opt-cards" id="materialList"></div>
                        <p class="opt-note" id="materialNote"></p>
                    </div>
                </section>

                <!-- 4. Màu sắc -->
                <section class="panel" aria-label="Màu sắc">
                    <h3>Màu sắc</h3>
                    <p class="sub">Chọn màu có sẵn hoặc gửi mã màu, hình mẫu để xưởng pha đúng.</p>
                    <div class="swatches" id="swatches"></div>

                    <div class="color-custom">
                        <input type="color" id="colorPicker" value="#1A1A1A" aria-label="Chọn màu tuỳ chỉnh">
                        <input type="text" id="colorHex" value="#1A1A1A" maxlength="7" aria-label="Mã màu HEX">
                        <span style="font-size:12.5px; color:var(--ink-soft);">Nhập mã HEX nếu bạn có màu thương hiệu riêng</span>
                    </div>

                    <div class="ref-img" id="refImgBox">
                        <div class="thumb" id="refThumb">🖼️</div>
                        <div class="t">
                            <strong id="refTitle">Tải hình mẫu màu</strong>
                            <span id="refDesc">JPG hoặc PNG — dùng khi bạn muốn xưởng tham khảo màu thực tế.</span>
                        </div>
                        <button type="button" class="chip" id="refBtn">Chọn ảnh</button>
                    </div>
                    <input type="file" id="refInput" accept="image/*" hidden>

                    <div class="notice">⚠ Màu thực tế có thể lệch so với màu trên màn hình, tuỳ vật liệu và công nghệ in.</div>
                </section>

                <!-- 5. Chất lượng + hậu xử lý -->
                <section class="panel" aria-label="Chất lượng và hoàn thiện">
                    <h3>Chất lượng bề mặt</h3>
                    <p class="sub" id="qualitySub">Lớp in càng mỏng, chi tiết càng mịn — thời gian in và chi phí cũng tăng theo.</p>
                    <div class="opt-cards" id="qualityList"></div>

                    <div class="opt-group" style="margin:26px 0 0;">
                        <span class="opt-label">Xử lý bề mặt <span class="tip" data-tip="Chọn được nhiều tuỳ chọn. Hậu xử lý làm sản phẩm đẹp hơn nhưng kéo dài thời gian giao hàng.">?</span></span>
                        <div class="opt-cards" id="postList"></div>
                    </div>

                    <div class="opt-group" style="margin:26px 0 0;">
                        <span class="opt-label">Độ chính xác kích thước <span class="tip" data-tip="Dung sai là mức sai lệch cho phép giữa sản phẩm thực tế và kích thước thiết kế. Xưởng sẽ xác nhận mức đáp ứng được với công nghệ và vật liệu bạn chọn.">?</span></span>
                        <div class="opt-cards" id="tolList"></div>
                        <div class="tol-custom">
                            <label for="tolCustom" style="font-size:13.5px; color:var(--ink-soft);">Dung sai riêng: ±</label>
                            <input type="number" id="tolCustom" step="0.01" min="0.01" placeholder="0.15" disabled>
                            <span style="font-size:13.5px; color:var(--ink-soft);">mm</span>
                        </div>
                    </div>
                </section>

                <!-- 6. Nâng cao + ghi chú -->
                <details class="adv">
                    <summary>Cấu hình nâng cao (không bắt buộc)</summary>
                    <div class="adv-body">
                        <p style="font-size:13px; color:var(--ink-soft); margin-bottom:16px;">Để trống thì xưởng sẽ chọn thông số tối ưu cho mô hình của bạn.</p>
                        <div class="field-row" style="grid-template-columns:repeat(2,1fr);">
                            <div class="field">
                                <label for="advInfill">Mật độ đổ đầy (%)</label>
                                <input type="number" id="advInfill" min="0" max="100" step="5" placeholder="Xưởng đề xuất">
                            </div>
                            <div class="field">
                                <label for="advWall">Độ dày thành (mm)</label>
                                <input type="number" id="advWall" min="0.4" step="0.1" placeholder="Xưởng đề xuất">
                            </div>
                            <div class="field">
                                <label for="advSupport">Support</label>
                                <select id="advSupport">
                                    <option value="auto">Để xưởng quyết định</option>
                                    <option value="yes">Có support</option>
                                    <option value="no">Không dùng support</option>
                                </select>
                            </div>
                            <div class="field">
                                <label for="advNozzle">Đường kính nozzle (mm)</label>
                                <select id="advNozzle">
                                    <option value="auto">Để xưởng quyết định</option>
                                    <option value="0.2">0.2</option>
                                    <option value="0.4">0.4</option>
                                    <option value="0.6">0.6</option>
                                    <option value="0.8">0.8</option>
                                </select>
                            </div>
                        </div>
                    </div>
                </details>

                <section class="panel" aria-label="Yêu cầu đặc biệt">
                    <h3>Yêu cầu đặc biệt</h3>
                    <p class="sub">Ghi chú những điểm xưởng cần lưu ý khi in hoặc hoàn thiện sản phẩm.</p>
                    <div class="field" style="margin:0;">
                        <textarea id="notes" rows="4" placeholder="Ví dụ: lỗ ở đế cần giữ đúng đường kính 10 mm, vui lòng kiểm tra trước khi in."></textarea>
                    </div>
                </section>

                <!-- 7. Tổng quan -->
                <section class="summary-card" aria-label="Tổng quan đơn hàng">
                    <h3>Tổng quan đơn hàng</h3>
                    <div class="sum-row"><span>Mô hình</span><b id="sModel" class="muted">Chưa tải file</b></div>
                    <div class="sum-row"><span>Số lượng</span><b id="sQty">1</b></div>
                    <div class="sum-row"><span>Kích thước</span><b id="sSize" class="muted">—</b></div>
                    <div class="sum-row"><span>Công nghệ</span><b id="sTech">FDM</b></div>
                    <div class="sum-row"><span>Vật liệu</span><b id="sMat">PLA</b></div>
                    <div class="sum-row"><span>Màu</span><b id="sColor"><i class="sum-dot" id="sColorDot" style="background:#1A1A1A"></i>Đen</b></div>
                    <div class="sum-row"><span>Chất lượng</span><b id="sQuality">—</b></div>
                    <div class="sum-row"><span>Xử lý bề mặt</span><b id="sPost" class="muted">Không xử lý</b></div>
                    <div class="sum-row"><span>Dung sai</span><b id="sTol">±0.3 mm</b></div>
                </section>

                <!-- 8. Giá dự kiến -->
                <section class="price-box" aria-label="Giá dự kiến">
                    <h4>Giá dự kiến</h4>
                    <div class="row"><span>Vật liệu</span><b id="pMat">—</b></div>
                    <div class="row"><span>Thời gian máy</span><b id="pTime">Theo thể tích &amp; lớp in</b></div>
                    <div class="row"><span>Gia công &amp; hậu xử lý</span><b id="pPost">Không xử lý</b></div>
                    <div class="row"><span>Số lượng</span><b id="pQty">× 1</b></div>
                    <div class="row total"><span>Tạm tính</span><span class="big" id="pTotal">Chờ xác nhận</span></div>
                    <p class="note">Giá sẽ được xưởng xác nhận sau khi kiểm tra file. Bạn nhận báo giá chi tiết trong vòng 2 giờ làm việc và chỉ thanh toán khi đồng ý.</p>
                </section>

                <!-- 9. Hành động -->
                <div>
                    <div class="form-error" id="formError" role="alert"></div>
                    <div class="actions">
                        <button type="submit" class="btn-primary">Tiếp tục đặt hàng</button>
                        <button type="button" class="btn-secondary" id="btnSave">Lưu cấu hình</button>
                    </div>
                </div>
            </form>
        </div>
    </div>
</main>

<!-- ============ FOOTER (giữ nội dung riêng của trang này) ============ -->
<footer>
    <div class="foot-inner">
        <div>
            <div class="logo" style="margin-bottom:16px;"><span class="mark"></span> PrintKraft</div>
            <p style="font-size:13.5px; color:var(--ink-soft); max-width:34ch;">Nền tảng in theo yêu cầu kết nối khách hàng với hơn 120 xưởng in đối tác trên toàn quốc.</p>
        </div>
        <div>
            <h5>Dịch vụ in 3D</h5>
            <ul><li>In FDM</li><li>In Resin (SLA/MSLA/DLP)</li><li>In SLS &amp; MJF</li><li>Hậu xử lý &amp; sơn</li></ul>
        </div>
        <div>
            <h5>Hỗ trợ</h5>
            <ul><li>Hướng dẫn chuẩn bị file</li><li>Theo dõi đơn hàng</li><li>Chính sách đổi trả</li><li>Điều khoản sử dụng</li></ul>
        </div>
        <div>
            <h5>Liên hệ</h5>
            <ul><li>Hotline: 1900 6868</li><li>Email: hi@printkraft.vn</li><li>128 Nguyễn Đình Chiểu, Q.3, TP.HCM</li><li>8:00 – 21:00</li></ul>
        </div>
    </div>
    <div class="foot-bottom">
        <span>© 2026 PrintKraft. Nền tảng in theo yêu cầu.</span>
        <span>Điều khoản · Bảo mật · Hỗ trợ khách hàng</span>
    </div>
</footer>

<!-- ============ MODAL XÁC NHẬN ============ -->
<div class="modal" id="confirmModal">
    <div class="modal-box">
        <button class="modal-close" type="button" data-close>×</button>
        <div class="success-screen" style="text-align:center;">
            <div class="success-icon">✓</div>
            <h3>Đã gửi yêu cầu in</h3>
            <p class="sub" style="margin-bottom:0;">Xưởng sẽ kiểm tra file và gửi báo giá trong vòng 2 giờ làm việc.</p>
            <div class="order-code" id="orderCode">#3D-000000</div>
        </div>
        <div class="summary-card" style="box-shadow:none; margin-top:10px;">
            <div id="confirmSummary"></div>
        </div>
        <div class="actions" style="margin-top:18px;">
            <button type="button" class="btn-primary" data-close style="flex:1;">Đã hiểu</button>
        </div>
    </div>
</div>

<!-- Thẻ toast do printkraft.js tự sinh, không khai báo thêm ở đây -->

<script src="https://cdnjs.cloudflare.com/ajax/libs/three.js/r128/three.min.js"></script>
<script src="<%= request.getContextPath() %>/assets/js/printkraft.js"></script>
<script src="<%= request.getContextPath() %>/assets/js/dat-in-3d.js"></script>
</body>
</html>
