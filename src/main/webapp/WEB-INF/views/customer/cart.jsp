<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c"   uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"  %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8"><meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Giỏ Hàng - PolyPhone</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.0/font/bootstrap-icons.css" rel="stylesheet">
</head>
<body>
<jsp:include page="/WEB-INF/views/common/header.jsp"/>
<div class="page-content">
    <div class="container py-4">
        <h3 class="fw-bold mb-4"><i class="bi bi-cart3 me-2"></i>Giỏ hàng của bạn</h3>
        <c:choose>
            <c:when test="${empty cartItems}">
                <div class="text-center py-5">
                    <i class="bi bi-cart-x fs-1 text-muted"></i>
                    <h5 class="text-muted mt-3">Giỏ hàng trống</h5>
                    <a href="${pageContext.request.contextPath}/products" class="btn btn-danger rounded-pill mt-2">Mua sắm ngay</a>
                </div>
            </c:when>
            <c:otherwise>
                <div class="row g-4">
                    <div class="col-lg-8">
                        <div class="card border-0 shadow-sm rounded-3">
                            <div class="card-body p-0">
                                <c:forEach var="item" items="${cartItems}">
                                    <div class="d-flex align-items-center p-3 border-bottom gap-3">
                                        <img src="${not empty item.anhUrl ? item.anhUrl : ''}"
                                             style="width:80px;height:80px;object-fit:contain;background:#f8f9fa;padding:4px;" class="rounded-2">
                                        <div class="flex-grow-1">
                                            <h6 class="fw-semibold mb-1">${item.tenSanPham}</h6>
                                            <div class="text-danger fw-bold"><fmt:formatNumber value="${item.gia}" pattern="#,###"/>đ</div>
                                        </div>
                                        <form method="post" action="${pageContext.request.contextPath}/customer/cart/update"
                                              class="d-flex align-items-center gap-2" id="form-${item.sanPhamId}">
                                            <input type="hidden" name="sanPhamId" value="${item.sanPhamId}">
                                            <div class="input-group" style="width:110px;">
                                                <button class="btn btn-outline-secondary btn-sm" type="button"
                                                        onclick="changeQty('${item.sanPhamId}', -1, ${item.tonKho})">-</button>
                                                <input type="number" class="form-control form-control-sm text-center" name="soLuong"
                                                       id="qty-${item.sanPhamId}" value="${item.soLuong}" min="1" max="${item.tonKho}"
                                                       onchange="document.getElementById('form-${item.sanPhamId}').submit()">
                                                <button class="btn btn-outline-secondary btn-sm" type="button"
                                                        onclick="changeQty('${item.sanPhamId}', 1, ${item.tonKho})">+</button>
                                            </div>
                                        </form>
                                        <div class="fw-bold text-dark" style="min-width:90px;text-align:right;">
                                            <fmt:formatNumber value="${item.thanhTien}" pattern="#,###"/>đ
                                        </div>
                                        <form method="post" action="${pageContext.request.contextPath}/customer/cart/remove">
                                            <input type="hidden" name="sanPhamId" value="${item.sanPhamId}">
                                            <button type="submit" class="btn btn-outline-danger btn-sm rounded-circle">
                                                <i class="bi bi-trash"></i>
                                            </button>
                                        </form>
                                    </div>
                                </c:forEach>
                            </div>
                        </div>
                    </div>
                    <div class="col-lg-4">
                        <div class="card border-0 shadow-sm rounded-3">
                            <div class="card-body p-4">
                                <h5 class="fw-bold mb-3">Tổng đơn hàng</h5>
                                <div class="d-flex justify-content-between mb-2">
                                    <span class="text-muted">Tạm tính:</span>
                                    <span class="fw-semibold"><fmt:formatNumber value="${tongTien}" pattern="#,###"/>đ</span>
                                </div>
                                <div class="d-flex justify-content-between mb-3">
                                    <span class="text-muted">Phí vận chuyển:</span>
                                    <span class="text-success">Miễn phí</span>
                                </div>
                                <hr>
                                <div class="d-flex justify-content-between mb-4">
                                    <span class="fw-bold fs-5">Tổng cộng:</span>
                                    <span class="fw-bold fs-5 text-danger"><fmt:formatNumber value="${tongTien}" pattern="#,###"/>đ</span>
                                </div>
                                <a href="${pageContext.request.contextPath}/customer/checkout" class="btn btn-danger w-100 rounded-pill py-2">
                                    <i class="bi bi-credit-card me-1"></i>Tiến hành thanh toán
                                </a>
                            </div>
                        </div>
                    </div>
                </div>
            </c:otherwise>
        </c:choose>
    </div>
</div>
<jsp:include page="/WEB-INF/views/common/footer.jsp"/>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
<script>
    function changeQty(id, delta, max) {
        const input = document.getElementById('qty-' + id);
        const newVal = Math.min(max, Math.max(1, parseInt(input.value) + delta));
        input.value = newVal;
        document.getElementById('form-' + id).submit();
    }
</script>
</body>
</html>
