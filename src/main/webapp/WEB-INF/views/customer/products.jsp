<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c"   uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"  %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8"><meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Sản Phẩm - PolyPhone</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.0/font/bootstrap-icons.css" rel="stylesheet">
    <style>
        .product-card { transition: transform .2s; cursor:pointer; }
        .product-card:hover { transform: translateY(-3px); box-shadow: 0 6px 20px rgba(0,0,0,.1) !important; }
        .product-img { height:180px; object-fit:contain; background:#f8f9fa; padding:8px; }
        .filter-section { position:sticky; top:80px; }
    </style>
</head>
<body>
<!--Start of Tawk.to Script-->
<script type="text/javascript">
    var Tawk_API=Tawk_API||{}, Tawk_LoadStart=new Date();
    (function(){
        var s1=document.createElement("script"),s0=document.getElementsByTagName("script")[0];
        s1.async=true;
        s1.src='https://embed.tawk.to/69d10432e360ca1c3ce3010d/1jlc7gpeb';
        s1.charset='UTF-8';
        s1.setAttribute('crossorigin','*');
        s0.parentNode.insertBefore(s1,s0);
    })();
</script>
<!--End of Tawk.to Script-->

<jsp:include page="/WEB-INF/views/common/header.jsp"/>
<div class="page-content">
    <div class="container py-4">
        <c:if test="${not empty keyword}">
            <div class="mb-3">
                <h5>Kết quả tìm kiếm: "<strong>${keyword}</strong>" — ${products.size()} sản phẩm</h5>
            </div>
        </c:if>
        <div class="row g-4">
            <!-- Sidebar Filter -->
            <div class="col-lg-3">
                <div class="card border-0 shadow-sm rounded-3 filter-section">
                    <div class="card-body">
                        <h6 class="fw-bold mb-3"><i class="bi bi-funnel me-1"></i>Bộ lọc</h6>
                        <form method="get" action="${pageContext.request.contextPath}/products" id="filterForm">
                            <!-- Danh mục -->
                            <div class="mb-3">
                                <label class="form-label fw-semibold small">Danh mục</label>
                                <select class="form-select form-select-sm" name="danhmuc" onchange="document.getElementById('filterForm').submit()">
                                    <option value="">Tất cả</option>
                                    <c:forEach var="dm" items="${danhMucs}">
                                        <option value="${dm.danhMucId}" ${selectedDanhMuc == dm.danhMucId ? 'selected' : ''}>${dm.tenDanhMuc}</option>
                                    </c:forEach>
                                </select>
                            </div>
                            <!-- Thương hiệu -->
                            <div class="mb-3">
                                <label class="form-label fw-semibold small">Thương hiệu</label>
                                <select class="form-select form-select-sm" name="thuonghieu" onchange="document.getElementById('filterForm').submit()">
                                    <option value="">Tất cả</option>
                                    <c:forEach var="th" items="${thuongHieus}">
                                        <option value="${th.thuongHieuId}" ${selectedThuongHieu == th.thuongHieuId ? 'selected' : ''}>${th.tenThuongHieu}</option>
                                    </c:forEach>
                                </select>
                            </div>
                            <!-- Giá -->
                            <div class="mb-3">
                                <label class="form-label fw-semibold small">Khoảng giá (VNĐ)</label>
                                <input type="number" class="form-control form-control-sm mb-1" name="giaMin" placeholder="Từ" value="${giaMin}">
                                <input type="number" class="form-control form-control-sm" name="giaMax" placeholder="Đến" value="${giaMax}">
                            </div>
                            <!-- Tags -->
                            <c:if test="${not empty tags}">
                                <div class="mb-3">
                                    <label class="form-label fw-semibold small">Tính năng</label>
                                    <c:forEach var="tag" items="${tags}">
                                        <div class="form-check">
                                            <input class="form-check-input" type="checkbox" name="tags" value="${tag[0]}" id="tag${tag[0]}">
                                            <label class="form-check-label small" for="tag${tag[0]}">${tag[1]}</label>
                                        </div>
                                    </c:forEach>
                                </div>
                            </c:if>
                            <button type="submit" class="btn btn-danger btn-sm w-100 rounded-pill">
                                <i class="bi bi-funnel me-1"></i>Lọc
                            </button>
                            <a href="${pageContext.request.contextPath}/products" class="btn btn-outline-secondary btn-sm w-100 mt-2 rounded-pill">
                                Xóa bộ lọc
                            </a>
                        </form>
                    </div>
                </div>
            </div>

            <!-- Product Grid -->
            <div class="col-lg-9">
                <div class="d-flex justify-content-between align-items-center mb-3">
                    <span class="text-muted small">${products.size()} sản phẩm</span>
                </div>
                <c:choose>
                    <c:when test="${empty products}">
                        <div class="text-center py-5">
                            <i class="bi bi-search fs-1 text-muted"></i>
                            <h5 class="text-muted mt-3">Không tìm thấy sản phẩm phù hợp</h5>
                            <a href="${pageContext.request.contextPath}/products" class="btn btn-danger rounded-pill mt-2">Xem tất cả</a>
                        </div>
                    </c:when>
                    <c:otherwise>
                        <div class="row g-3">
                            <c:forEach var="sp" items="${products}">
                                <div class="col-6 col-md-4">
                                    <div class="card border-0 shadow-sm rounded-3 h-100 product-card"
                                         onclick="location.href='${pageContext.request.contextPath}/products/detail?id=${sp.sanPhamId}'">
                                        <img src="${not empty sp.anhUrls ? sp.anhUrls[0] : pageContext.request.contextPath.concat('/images/no-image.png')}"
                                             class="card-img-top product-img rounded-top-3" alt="${sp.tenSanPham}">
                                        <div class="card-body p-3">
                                            <span class="badge bg-light text-secondary border small mb-1">${sp.tenThuongHieu}</span>
                                            <h6 class="fw-semibold" style="font-size:.85rem;height:2.5em;overflow:hidden;">${sp.tenSanPham}</h6>
                                            <div class="text-warning small mb-1">
                                                <c:forEach begin="1" end="5" var="i">
                                                    <i class="bi bi-star${i <= sp.avgSoSao ? '-fill' : ''}"></i>
                                                </c:forEach>
                                            </div>
                                            <div class="text-danger fw-bold"><fmt:formatNumber value="${sp.gia}" pattern="#,###"/>đ</div>
                                            <div class="small text-muted mt-1">Còn ${sp.tonKho} sản phẩm</div>
                                        </div>
                                        <div class="card-footer bg-transparent border-0 p-3 pt-0">
                                            <form method="post" action="${pageContext.request.contextPath}/customer/cart/add"
                                                  onclick="event.stopPropagation()">
                                                <input type="hidden" name="sanPhamId" value="${sp.sanPhamId}">
                                                <input type="hidden" name="soLuong" value="1">
                                                <button type="submit" class="btn btn-danger btn-sm w-100 rounded-pill">
                                                    <i class="bi bi-cart-plus me-1"></i>Thêm giỏ hàng
                                                </button>
                                            </form>
                                        </div>
                                    </div>
                                </div>
                            </c:forEach>
                        </div>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>
    </div>
</div>
<jsp:include page="/WEB-INF/views/common/footer.jsp"/>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
