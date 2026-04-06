<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c"   uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"  %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8"><meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Thanh Toán - PolyPhone</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.0/font/bootstrap-icons.css" rel="stylesheet">
</head>
<body>
<jsp:include page="/WEB-INF/views/common/header.jsp"/>
<div class="page-content">
    <div class="container py-4">
        <h3 class="fw-bold mb-4"><i class="bi bi-credit-card me-2"></i>Thanh toán</h3>
        <c:if test="${not empty error}">
            <div class="alert alert-danger">${error}</div>
        </c:if>
        <form method="post" action="${pageContext.request.contextPath}/customer/checkout" id="checkoutForm">
            <div class="row g-4">
                <div class="col-lg-7">
                    <!-- Địa chỉ -->
                    <div class="card border-0 shadow-sm rounded-3 mb-3">
                        <div class="card-body p-4">
                            <h6 class="fw-bold mb-3"><i class="bi bi-geo-alt me-1"></i>Địa chỉ giao hàng</h6>
                            <div class="mb-3">
                                <label class="form-label">Họ tên người nhận</label>
                                <input type="text" class="form-control" value="${userInfo.hoTen}" readonly>
                            </div>
                            <div class="mb-3">
                                <label class="form-label">Địa chỉ đầy đủ <span class="text-danger">*</span></label>
                                <textarea class="form-control" name="diaChi" rows="2" required
                                          placeholder="Số nhà, đường, phường/xã, quận/huyện, tỉnh/thành..."></textarea>
                            </div>
                        </div>
                    </div>

                    <!-- Voucher -->
                    <div class="card border-0 shadow-sm rounded-3 mb-3">
                        <div class="card-body p-4">
                            <h6 class="fw-bold mb-3"><i class="bi bi-tag me-1"></i>Mã giảm giá</h6>
                            <div class="input-group mb-2">
                                <input type="text" class="form-control" name="maVoucher" id="voucherInput"
                                       placeholder="Nhập mã voucher" oninput="previewVoucher(this.value.trim().toUpperCase())">
                                <button class="btn btn-outline-danger" type="button" onclick="previewVoucher(document.getElementById('voucherInput').value.trim().toUpperCase())">
                                    Áp dụng
                                </button>
                            </div>
                            <!-- Thông báo voucher realtime -->
                            <div id="voucherMsg" class="small mb-2" style="display:none;"></div>

                            <c:if test="${not empty vouchers}">
                                <div class="row g-2 mt-1">
                                    <c:forEach var="v" items="${vouchers}">
                                        <div class="col-12">
                                            <div class="border rounded-2 p-2 d-flex justify-content-between align-items-center"
                                                 style="cursor:pointer"
                                                 onclick="selectVoucher('${v.maVoucher}', ${v.loaiGiam == 'phan_tram' ? v.giaTriGiam : 0}, ${v.loaiGiam == 'so_tien' ? v.giaTriGiam : 0}, ${v.donHangToiThieu})">
                                                <div>
                                                    <span class="badge bg-danger me-2">${v.maVoucher}</span>
                                                    <small class="text-muted">
                                                        Giảm
                                                        <c:choose>
                                                            <c:when test="${v.loaiGiam == 'phan_tram'}"><fmt:formatNumber value="${v.giaTriGiam}" pattern="#,###"/>%</c:when>
                                                            <c:otherwise><fmt:formatNumber value="${v.giaTriGiam}" pattern="#,###"/>đ</c:otherwise>
                                                        </c:choose>
                                                        — Đơn tối thiểu <fmt:formatNumber value="${v.donHangToiThieu}" pattern="#,###"/>đ
                                                    </small>
                                                </div>
                                                <i class="bi bi-chevron-right text-muted"></i>
                                            </div>
                                        </div>
                                    </c:forEach>
                                </div>
                            </c:if>
                        </div>
                    </div>

                    <!-- Điểm tích lũy -->
                    <div class="card border-0 shadow-sm rounded-3 mb-3">
                        <div class="card-body p-4">
                            <h6 class="fw-bold mb-2"><i class="bi bi-star me-1"></i>Điểm tích lũy</h6>
                            <p class="text-muted small mb-2">
                                Bạn có <strong>${userInfo.diemTichLuy}</strong> điểm (100 điểm = 10,000đ)
                            </p>
                            <div class="input-group" style="max-width:220px;">
                                <input type="number" class="form-control" name="diemSuDung" id="diemInput"
                                       min="0" max="${userInfo.diemTichLuy}" placeholder="0" value="0"
                                       oninput="previewDiem(this.value)">
                                <span class="input-group-text">điểm</span>
                            </div>
                            <div id="diemMsg" class="small text-success mt-1" style="display:none;"></div>
                        </div>
                    </div>

                    <!-- Phương thức thanh toán -->
                    <div class="card border-0 shadow-sm rounded-3">
                        <div class="card-body p-4">
                            <h6 class="fw-bold mb-3"><i class="bi bi-wallet2 me-1"></i>Phương thức thanh toán</h6>
                            <div class="form-check mb-2">
                                <input class="form-check-input" type="radio" name="phuongThuc" value="COD" id="cod" checked>
                                <label class="form-check-label" for="cod">
                                    <i class="bi bi-cash me-2"></i>Thanh toán khi nhận hàng (COD)
                                </label>
                            </div>
                            <div class="form-check">
                                <input class="form-check-input" type="radio" name="phuongThuc" value="PayOS" id="payos">
                                <label class="form-check-label" for="payos">
                                    <i class="bi bi-qr-code me-2"></i>Thanh toán online (PayOS)
                                </label>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Order Summary -->
                <div class="col-lg-5">
                    <div class="card border-0 shadow-sm rounded-3 sticky-top" style="top:90px;">
                        <div class="card-body p-4">
                            <h5 class="fw-bold mb-3">Đơn hàng của bạn</h5>
                            <c:forEach var="item" items="${cartItems}">
                                <div class="d-flex gap-2 mb-2 align-items-center">
                                    <img src="${not empty item.anhUrl ? item.anhUrl : ''}"
                                         style="width:48px;height:48px;object-fit:contain;background:#f8f9fa;padding:2px;" class="rounded">
                                    <div class="flex-grow-1">
                                        <div class="small fw-semibold" style="line-height:1.2;">${item.tenSanPham}</div>
                                        <div class="small text-muted">x${item.soLuong}</div>
                                    </div>
                                    <div class="small fw-bold"><fmt:formatNumber value="${item.thanhTien}" pattern="#,###"/>đ</div>
                                </div>
                            </c:forEach>
                            <hr>
                            <div class="d-flex justify-content-between mb-2">
                                <span class="text-muted">Tạm tính:</span>
                                <span id="subtotal"><fmt:formatNumber value="${tongTien}" pattern="#,###"/>đ</span>
                            </div>
                            <div class="d-flex justify-content-between mb-2" id="voucherRow" style="display:none!important;">
                                <span class="text-muted">Giảm voucher:</span>
                                <span class="text-success fw-semibold" id="voucherDiscount">-0đ</span>
                            </div>
                            <div class="d-flex justify-content-between mb-2" id="diemRow" style="display:none!important;">
                                <span class="text-muted">Giảm điểm:</span>
                                <span class="text-success fw-semibold" id="diemDiscount">-0đ</span>
                            </div>
                            <div class="d-flex justify-content-between mb-3">
                                <span class="text-muted">Phí vận chuyển:</span>
                                <span class="text-success fw-semibold">Miễn phí</span>
                            </div>
                            <hr>
                            <div class="d-flex justify-content-between mb-4">
                                <span class="fw-bold fs-5">Tổng cộng:</span>
                                <span class="fw-bold fs-5 text-danger" id="totalDisplay">
                <fmt:formatNumber value="${tongTien}" pattern="#,###"/>đ
              </span>
                            </div>
                            <div class="mb-3">
                                <label class="form-label small text-muted">Ghi chú</label>
                                <textarea class="form-control form-control-sm" name="ghiChu" rows="2"
                                          placeholder="Ghi chú cho người giao hàng..."></textarea>
                            </div>
                            <button type="submit" class="btn btn-danger w-100 btn-lg rounded-pill">
                                <i class="bi bi-check2-circle me-1"></i>Đặt hàng
                            </button>
                        </div>
                    </div>
                </div>
            </div>
        </form>
    </div>
</div>
<jsp:include page="/WEB-INF/views/common/footer.jsp"/>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
<script>
    const BASE_TOTAL = ${tongTien};
    const MAX_DIEM   = ${userInfo.diemTichLuy};

    // Voucher data từ server
    const VOUCHERS = {
        <c:forEach var="v" items="${vouchers}" varStatus="st">
        '${v.maVoucher}': {
            loai: '${v.loaiGiam}',
            gia:  ${v.giaTriGiam},
            min:  ${v.donHangToiThieu}
        }<c:if test="${!st.last}">,</c:if>
        </c:forEach>
    };

    let voucherDiscount = 0;
    let diemDiscount    = 0;

    function formatVND(n) {
        return n.toLocaleString('vi-VN') + 'đ';
    }

    function updateTotal() {
        const total = Math.max(0, BASE_TOTAL - voucherDiscount - diemDiscount);
        document.getElementById('totalDisplay').textContent = formatVND(total);
    }

    function previewVoucher(code) {
        const msg = document.getElementById('voucherMsg');
        const row = document.getElementById('voucherRow');
        const dis = document.getElementById('voucherDiscount');

        if (!code) {
            msg.style.display = 'none';
            row.style.setProperty('display','none','important');
            voucherDiscount = 0;
            updateTotal();
            return;
        }

        const v = VOUCHERS[code];
        if (!v) {
            msg.style.display = 'block';
            msg.className = 'small text-danger mb-2';
            msg.textContent = 'Mã voucher không hợp lệ.';
            row.style.setProperty('display','none','important');
            voucherDiscount = 0;
            updateTotal();
            return;
        }
        if (BASE_TOTAL < v.min) {
            msg.style.display = 'block';
            msg.className = 'small text-warning mb-2';
            msg.textContent = 'Đơn hàng chưa đạt tối thiểu ' + formatVND(v.min) + ' để dùng mã này.';
            row.style.setProperty('display','none','important');
            voucherDiscount = 0;
            updateTotal();
            return;
        }

        if (v.loai === 'phan_tram') {
            voucherDiscount = Math.round(BASE_TOTAL * v.gia / 100);
        } else {
            voucherDiscount = v.gia;
        }

        msg.style.display = 'block';
        msg.className = 'small text-success mb-2';
        msg.textContent = '✓ Áp dụng thành công! Giảm ' + formatVND(voucherDiscount);
        dis.textContent = '-' + formatVND(voucherDiscount);
        row.style.removeProperty('display');
        updateTotal();
    }

    function selectVoucher(code, pct, fixed, min) {
        document.getElementById('voucherInput').value = code;
        previewVoucher(code);
    }

    function previewDiem(val) {
        const msg  = document.getElementById('diemMsg');
        const row  = document.getElementById('diemRow');
        const dis  = document.getElementById('diemDiscount');
        const diem = Math.min(MAX_DIEM, Math.max(0, parseInt(val) || 0));

        diemDiscount = Math.floor(diem / 100) * 10000;

        if (diemDiscount > 0) {
            msg.style.display = 'block';
            msg.textContent   = '✓ Dùng ' + diem + ' điểm → giảm ' + formatVND(diemDiscount);
            dis.textContent   = '-' + formatVND(diemDiscount);
            row.style.removeProperty('display');
        } else {
            msg.style.display = 'none';
            row.style.setProperty('display','none','important');
        }
        updateTotal();
    }
</script>
</body>
</html>
