<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c"   uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"  %>
<!DOCTYPE html>
<html lang="vi">
<head>
  <meta charset="UTF-8"><meta name="viewport" content="width=device-width, initial-scale=1">
  <title>Sản Phẩm Yêu Thích - PolyPhone</title>
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
  <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.0/font/bootstrap-icons.css" rel="stylesheet">
</head>
<body>
<jsp:include page="/WEB-INF/views/common/header.jsp"/>
<div class="page-content">
<div class="container py-4">
  <h3 class="fw-bold mb-4"><i class="bi bi-heart-fill text-danger me-2"></i>Sản phẩm yêu thích</h3>
  <c:choose>
    <c:when test="${empty wishlist}">
      <div class="text-center py-5">
        <i class="bi bi-heart fs-1 text-muted"></i>
        <h5 class="text-muted mt-3">Chưa có sản phẩm yêu thích</h5>
        <a href="${pageContext.request.contextPath}/products" class="btn btn-danger rounded-pill mt-2">Khám phá ngay</a>
      </div>
    </c:when>
    <c:otherwise>
      <div class="row g-3">
        <c:forEach var="sp" items="${wishlist}">
          <div class="col-6 col-md-4 col-lg-3">
            <div class="card border-0 shadow-sm rounded-3 h-100">
              <img src="${not empty sp.anhUrls ? sp.anhUrls[0] : ''}" class="card-img-top rounded-top-3"
                   style="height:180px;object-fit:cover;cursor:pointer"
                   onclick="location.href='${pageContext.request.contextPath}/products/detail?id=${sp.sanPhamId}'">
              <div class="card-body p-3">
                <h6 class="fw-semibold mb-1 small">${sp.tenSanPham}</h6>
                <div class="text-danger fw-bold small mb-2"><fmt:formatNumber value="${sp.gia}" pattern="#,###"/>đ</div>
                <div class="d-flex gap-2">
                  <form method="post" action="${pageContext.request.contextPath}/customer/cart/add" class="flex-grow-1">
                    <input type="hidden" name="sanPhamId" value="${sp.sanPhamId}">
                    <input type="hidden" name="soLuong" value="1">
                    <button type="submit" class="btn btn-danger btn-sm w-100 rounded-pill">
                      <i class="bi bi-cart-plus"></i>
                    </button>
                  </form>
                  <form method="post" action="${pageContext.request.contextPath}/customer/wishlist/toggle">
                    <input type="hidden" name="sanPhamId" value="${sp.sanPhamId}">
                    <input type="hidden" name="action" value="remove">
                    <button type="submit" class="btn btn-outline-danger btn-sm rounded-pill">
                      <i class="bi bi-trash"></i>
                    </button>
                  </form>
                </div>
              </div>
            </div>
          </div>
        </c:forEach>
      </div>
    </c:otherwise>
  </c:choose>
</div>
</div>
<jsp:include page="/WEB-INF/views/common/footer.jsp"/>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
