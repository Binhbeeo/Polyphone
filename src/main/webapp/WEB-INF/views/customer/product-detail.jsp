<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c"   uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"  %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8"><meta name="viewport" content="width=device-width, initial-scale=1">
    <title>${product.tenSanPham} - PolyPhone</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.0/font/bootstrap-icons.css" rel="stylesheet">
    <style>
        .thumb{width:70px;height:70px;object-fit:contain;cursor:pointer;border:2px solid transparent;background:#f8f9fa;}
        .thumb:hover,.thumb.active{border-color:#dc3545;}
        .main-img-wrapper{width:100%;aspect-ratio:3/4;background:#f8f9fa;border-radius:.75rem;overflow:hidden;display:flex;align-items:center;justify-content:center;}
        .main-img-wrapper img{width:100%;height:100%;object-fit:contain;}
    </style>
</head>
<body>
<jsp:include page="/WEB-INF/views/common/header.jsp"/>
<div class="page-content">
    <div class="container py-4">
        <!-- Breadcrumb -->
        <nav aria-label="breadcrumb" class="mb-3">
            <ol class="breadcrumb">
                <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/" class="text-danger">Trang chủ</a></li>
                <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/products" class="text-danger">Sản phẩm</a></li>
                <li class="breadcrumb-item active">${product.tenSanPham}</li>
            </ol>
        </nav>

        <div class="row g-4">
            <!-- Images -->
            <div class="col-md-5">
                <div class="main-img-wrapper mb-2">
                    <img id="mainImg"
                         src="${not empty product.anhUrls ? product.anhUrls[0] : pageContext.request.contextPath.concat('/images/no-image.png')}">
                </div>
                <div class="d-flex gap-2 flex-wrap">
                    <c:forEach var="url" items="${product.anhUrls}">
                        <img src="${url}" class="thumb rounded-2" onclick="document.getElementById('mainImg').src=this.src">
                    </c:forEach>
                </div>
            </div>

            <!-- Info -->
            <div class="col-md-7">
                <span class="badge bg-danger-subtle text-danger mb-2">${product.tenDanhMuc}</span>
                <h2 class="fw-bold mb-2">${product.tenSanPham}</h2>
                <div class="d-flex align-items-center gap-2 mb-3">
                    <div class="text-warning">
                        <c:forEach begin="1" end="5" var="i">
                            <i class="bi bi-star${i <= product.avgSoSao ? '-fill' : ''}"></i>
                        </c:forEach>
                    </div>
                    <span class="text-muted small">(${product.soLuongDanhGia} đánh giá)</span>
                    <span class="badge bg-success-subtle text-success">
                        ${product.tonKho > 0 ? 'Còn hàng' : 'Hết hàng'}
                    </span>
                </div>
                <div class="text-danger fs-2 fw-bold mb-3">
                    <fmt:formatNumber value="${product.gia}" pattern="#,###"/>đ
                </div>

                <c:if test="${product.tonKho > 0}">
                    <form method="post" action="${pageContext.request.contextPath}/customer/cart/add" class="mb-3">
                        <input type="hidden" name="sanPhamId" value="${product.sanPhamId}">
                        <div class="d-flex align-items-center gap-3 mb-3">
                            <label class="fw-semibold">Số lượng:</label>
                            <div class="input-group" style="width:130px;">
                                <button class="btn btn-outline-secondary" type="button" onclick="changeQty(-1)">-</button>
                                <input type="number" class="form-control text-center" name="soLuong" id="qty" value="1" min="1" max="${product.tonKho}">
                                <button class="btn btn-outline-secondary" type="button" onclick="changeQty(1)">+</button>
                            </div>
                        </div>
                        <div class="d-flex gap-2 flex-wrap">
                            <button type="submit" class="btn btn-danger btn-lg rounded-pill px-4">
                                <i class="bi bi-cart-plus me-1"></i>Thêm vào giỏ hàng
                            </button>
                        </div>
                    </form>
                    <c:if test="${not empty sessionScope.loggedInUser}">
                        <form method="post" action="${pageContext.request.contextPath}/customer/wishlist/toggle" class="mt-2">
                            <input type="hidden" name="sanPhamId" value="${product.sanPhamId}">
                            <input type="hidden" name="action" value="${daYeuThich ? 'remove' : 'add'}">
                            <button type="submit" class="btn btn-lg rounded-pill px-3 ${daYeuThich ? 'btn-danger' : 'btn-outline-danger'}">
                                <i class="bi bi-heart${daYeuThich ? '-fill' : ''} me-1"></i>
                                    ${daYeuThich ? 'Bỏ yêu thích' : 'Thêm yêu thích'}
                            </button>
                        </form>
                    </c:if>
                </c:if>

                <div class="card bg-light border-0 rounded-3 p-3 mt-3">
                    <h6 class="fw-bold mb-2">Thông tin sản phẩm</h6>
                    <p class="mb-0 text-muted small">${product.moTa}</p>
                </div>
            </div>
        </div>

        <!-- Reviews -->
        <div class="mt-5">
            <h4 class="fw-bold mb-4">Đánh giá sản phẩm</h4>
            <c:if test="${not empty sessionScope.loggedInUser and daMua}">
                <div class="card border-0 shadow-sm rounded-3 mb-4">
                    <div class="card-body p-4">
                        <h6 class="fw-bold mb-3"><i class="bi bi-pencil-square me-2 text-danger"></i>Viết đánh giá của bạn</h6>
                        <form method="post" action="${pageContext.request.contextPath}/customer/orders/review">
                            <input type="hidden" name="sanPhamId" value="${product.sanPhamId}">
                            <input type="hidden" name="donHangId" value="-1">
                            <div class="mb-3 text-center">
                                <p class="text-muted small mb-2">Bạn đánh giá sản phẩm này như thế nào?</p>
                                <div class="d-flex justify-content-center gap-2 fs-2">
                                    <c:forEach begin="1" end="5" var="s">
                                        <label for="starPD${s}" class="star-pd" data-val="${s}" style="cursor:pointer;color:#ccc;">
                                            <i class="bi bi-star-fill"></i>
                                        </label>
                                        <input type="radio" name="soSao" id="starPD${s}" value="${s}" style="display:none" ${s==5?'checked':''}>
                                    </c:forEach>
                                </div>
                            </div>
                            <div class="mb-3">
                                <textarea class="form-control" name="nhanXet" rows="3" placeholder="Chia sẻ trải nghiệm của bạn..."></textarea>
                            </div>
                            <button type="submit" class="btn btn-danger rounded-pill px-4">
                                <i class="bi bi-send me-1"></i>Gửi đánh giá
                            </button>
                        </form>
                    </div>
                </div>
                <script>
                    (function() {
                        var labels = document.querySelectorAll('.star-pd');
                        var inputs = document.querySelectorAll('input[name="soSao"]');
                        function highlight(val) {
                            labels.forEach(function(l) {
                                l.style.color = parseInt(l.dataset.val) <= val ? '#ffc107' : '#ccc';
                            });
                        }
                        // Init
                        highlight(5);
                        labels.forEach(function(label) {
                            label.addEventListener('mouseover', function() { highlight(parseInt(this.dataset.val)); });
                            label.addEventListener('mouseout', function() {
                                var checked = document.querySelector('input[name="soSao"]:checked');
                                highlight(checked ? parseInt(checked.value) : 5);
                            });
                            label.addEventListener('click', function() {
                                var val = parseInt(this.dataset.val);
                                inputs.forEach(function(inp) { inp.checked = (parseInt(inp.value) === val); });
                                highlight(val);
                            });
                        });
                    })();
                </script>
            </c:if>

            <c:choose>
                <c:when test="${empty danhGias}">
                    <p class="text-muted">Chưa có đánh giá nào. Hãy là người đầu tiên!</p>
                </c:when>
                <c:otherwise>
                    <c:forEach var="dg" items="${danhGias}">
                        <div class="card border-0 shadow-sm rounded-3 mb-3">
                            <div class="card-body p-4">
                                <div class="d-flex align-items-center gap-3 mb-2">
                                    <div class="bg-danger text-white rounded-circle d-flex align-items-center justify-content-center"
                                         style="width:40px;height:40px;font-weight:bold;">
                                        ?
                                    </div>
                                    <div>
                                        <div class="fw-semibold">${dg.hoTenNguoiDung}</div>
                                        <div class="text-warning small">
                                            <c:forEach begin="1" end="${dg.soSao}" var="s"><i class="bi bi-star-fill"></i></c:forEach>
                                        </div>
                                    </div>
                                    <span class="ms-auto text-muted small">
                                            ${dg.ngayTaoStr}
                                    </span>
                                </div>
                                <p class="mb-0">${dg.nhanXet}</p>
                            </div>
                        </div>
                    </c:forEach>
                </c:otherwise>
            </c:choose>
        </div>

        <!-- Similar products -->
        <c:if test="${not empty tuongTu}">
            <div class="mt-5">
                <h4 class="fw-bold mb-4">Sản phẩm tương tự</h4>
                <div class="row g-3">
                    <c:forEach var="sp" items="${tuongTu}">
                        <div class="col-6 col-md-3">
                            <div class="card border-0 shadow-sm rounded-3 h-100"
                                 style="cursor:pointer" onclick="location.href='${pageContext.request.contextPath}/products/detail?id=${sp.sanPhamId}'">
                                <img src="${not empty sp.anhUrls ? sp.anhUrls[0] : ''}" class="card-img-top rounded-top-3"
                                     style="height:150px;object-fit:cover;">
                                <div class="card-body p-3">
                                    <h6 class="small fw-semibold mb-1">${sp.tenSanPham}</h6>
                                    <div class="text-danger fw-bold small"><fmt:formatNumber value="${sp.gia}" pattern="#,###"/>đ</div>
                                </div>
                            </div>
                        </div>
                    </c:forEach>
                </div>
            </div>
        </c:if>
    </div>
</div>
<jsp:include page="/WEB-INF/views/common/footer.jsp"/>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
<script>
    function changeQty(delta){
        const inp=document.getElementById('qty');
        let v=parseInt(inp.value)+delta;
        inp.value=Math.max(1,Math.min(v,parseInt(inp.max)));
    }
</script>
</body>
</html>
