<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c"   uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"  %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8"><meta name="viewport" content="width=device-width, initial-scale=1">
    <title>PolyPhone - Cửa Hàng Điện Thoại</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.0/font/bootstrap-icons.css" rel="stylesheet">
    <style>
        .hero { background: linear-gradient(135deg, #c0392b 0%, #e74c3c 100%); }
        .product-card { transition: transform .2s, box-shadow .2s; cursor:pointer; }
        .product-card:hover { transform: translateY(-4px); box-shadow: 0 8px 24px rgba(0,0,0,.12) !important; }
        .product-img { height:200px; object-fit:contain; background:#f8f9fa; padding:8px; }
        .star-rating { color: #f59e0b; font-size:.85rem; }
    </style>
</head>
<body>
<!--Start of Tawk.to Script-->
<jsp:include page="/WEB-INF/views/common/crisp-chat.jsp"/>


<jsp:include page="/WEB-INF/views/common/header.jsp"/>
<div class="page-content">

    <!-- Hero Banner -->
    <section class="hero text-white py-5">
        <div class="container py-3">
            <div class="row align-items-center">
                <div class="col-lg-6">
                    <h1 class="display-5 fw-bold mb-3">Điện thoại chính hãng<br><span class="text-warning">Giá tốt nhất</span></h1>
                    <p class="lead mb-4 opacity-75">Hàng ngàn sản phẩm chính hãng, bảo hành đầy đủ, giao hàng toàn quốc.</p>
                    <a href="${pageContext.request.contextPath}/products" class="btn btn-light btn-lg rounded-pill px-4 me-2">
                        <i class="bi bi-grid me-1"></i>Xem tất cả
                    </a>
                    <a href="${pageContext.request.contextPath}/products?danhmuc=3" class="btn btn-outline-light btn-lg rounded-pill px-4">
                        <i class="bi bi-controller me-1"></i>Gaming
                    </a>
                </div>
                <div class="col-lg-6 text-center d-none d-lg-block">
                    <i class="bi bi-phone-fill" style="font-size:10rem;opacity:.2;"></i>
                </div>
            </div>
        </div>
    </section>

    <!-- Categories -->
    <section class="py-4 bg-white shadow-sm">
        <div class="container">
            <div class="d-flex gap-3 flex-wrap justify-content-center">
                <a href="${pageContext.request.contextPath}/products" class="btn btn-outline-danger rounded-pill">
                    <i class="bi bi-grid me-1"></i>Tất cả
                </a>
                <c:forEach var="dm" items="${danhMucs}">
                    <a href="${pageContext.request.contextPath}/products?danhmuc=${dm.danhMucId}"
                       class="btn btn-outline-secondary rounded-pill">
                            ${dm.tenDanhMuc}
                    </a>
                </c:forEach>
            </div>
        </div>
    </section>

    <!-- Featured Products -->
    <section class="py-5">
        <div class="container">
            <div class="d-flex justify-content-between align-items-center mb-4">
                <h3 class="fw-bold mb-0">🔥 Sản phẩm nổi bật</h3>
                <a href="${pageContext.request.contextPath}/products" class="text-danger text-decoration-none">
                    Xem tất cả <i class="bi bi-arrow-right"></i>
                </a>
            </div>
            <div class="row g-3">
                <c:forEach var="sp" items="${featuredProducts}">
                    <div class="col-6 col-md-4 col-lg-3">
                        <div class="card border-0 shadow-sm rounded-3 h-100 product-card"
                             onclick="location.href='${pageContext.request.contextPath}/products/detail?id=${sp.sanPhamId}'">
                            <img src="${not empty sp.anhUrls ? sp.anhUrls[0] : pageContext.request.contextPath.concat('/images/no-image.png')}"
                                 class="card-img-top product-img rounded-top-3" alt="${sp.tenSanPham}">
                            <div class="card-body p-3">
                                <p class="small text-muted mb-1">${sp.tenThuongHieu}</p>
                                <h6 class="card-title fw-semibold mb-1" style="font-size:.9rem;line-height:1.3;height:2.6em;overflow:hidden;">${sp.tenSanPham}</h6>
                                <div class="star-rating mb-1">
                                    <c:forEach begin="1" end="5" var="i">
                                        <i class="bi bi-star${i <= sp.avgSoSao ? '-fill' : (i - sp.avgSoSao < 1 ? '-half' : '')}"></i>
                                    </c:forEach>
                                    <span class="text-muted small">(${sp.soLuongDanhGia})</span>
                                </div>
                                <div class="text-danger fw-bold">
                                    <fmt:formatNumber value="${sp.gia}" pattern="#,###"/>đ
                                </div>
                            </div>
                            <div class="card-footer bg-transparent border-0 p-3 pt-0">
                                <form method="post" action="${pageContext.request.contextPath}/customer/cart/add">
                                    <input type="hidden" name="sanPhamId" value="${sp.sanPhamId}">
                                    <input type="hidden" name="soLuong" value="1">
                                    <button type="submit" class="btn btn-danger btn-sm w-100 rounded-pill">
                                        <i class="bi bi-cart-plus me-1"></i>Thêm vào giỏ
                                    </button>
                                </form>
                            </div>
                        </div>
                    </div>
                </c:forEach>
            </div>
        </div>
    </section>

    <!-- Features -->
    <section class="bg-light py-5">
        <div class="container">
            <div class="row g-4 text-center">
                <div class="col-6 col-md-3">
                    <i class="bi bi-truck fs-2 text-danger mb-2 d-block"></i>
                    <h6 class="fw-bold">Miễn phí vận chuyển</h6>
                    <p class="small text-muted mb-0">Đơn hàng trên 2 triệu</p>
                </div>
                <div class="col-6 col-md-3">
                    <i class="bi bi-shield-check fs-2 text-danger mb-2 d-block"></i>
                    <h6 class="fw-bold">Bảo hành chính hãng</h6>
                    <p class="small text-muted mb-0">12 tháng đổi mới</p>
                </div>
                <div class="col-6 col-md-3">
                    <i class="bi bi-arrow-counterclockwise fs-2 text-danger mb-2 d-block"></i>
                    <h6 class="fw-bold">Đổi trả 30 ngày</h6>
                    <p class="small text-muted mb-0">Không cần lý do</p>
                </div>
                <div class="col-6 col-md-3">
                    <i class="bi bi-headset fs-2 text-danger mb-2 d-block"></i>
                    <h6 class="fw-bold">Hỗ trợ 24/7</h6>
                    <p class="small text-muted mb-0">Hotline: 1900 xxxx</p>
                </div>
            </div>
        </div>
    </section>

</div>
<jsp:include page="/WEB-INF/views/common/footer.jsp"/>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
