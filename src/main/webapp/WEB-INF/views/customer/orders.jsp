<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c"   uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"  %>
<!DOCTYPE html>
<html lang="vi">
<head>
  <meta charset="UTF-8"><meta name="viewport" content="width=device-width, initial-scale=1">
  <title>Đơn Hàng Của Tôi - PolyPhone</title>
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
  <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.0/font/bootstrap-icons.css" rel="stylesheet">
</head>
<body>
<!--Start of Tawk.to Script-->
<jsp:include page="/WEB-INF/views/common/crisp-chat.jsp"/>


<jsp:include page="/WEB-INF/views/common/header.jsp"/>
<div class="page-content">
<div class="container py-4">
  <h3 class="fw-bold mb-4"><i class="bi bi-bag me-2"></i>Đơn hàng của tôi</h3>

  <!-- Filter tabs -->
  <div class="d-flex gap-2 mb-4 flex-wrap">
    <c:forEach items="${['', 'moi', 'xac_nhan', 'dong_goi', 'dang_giao', 'hoan_thanh', 'huy']}" var="tt">
      <a href="${pageContext.request.contextPath}/customer/orders${not empty tt ? '?trangThai='.concat(tt) : ''}"
         class="btn btn-sm rounded-pill ${trangThai == tt || (empty trangThai && empty tt) ? 'btn-danger' : 'btn-outline-secondary'}">
        <c:choose>
          <c:when test="${empty tt}">Tất cả</c:when>
          <c:when test="${tt == 'moi'}">Mới</c:when>
          <c:when test="${tt == 'xac_nhan'}">Đã xác nhận</c:when>
          <c:when test="${tt == 'dong_goi'}">Đang đóng gói</c:when>
          <c:when test="${tt == 'dang_giao'}">Đang giao</c:when>
          <c:when test="${tt == 'hoan_thanh'}">Hoàn thành</c:when>
          <c:when test="${tt == 'huy'}">Đã hủy</c:when>
        </c:choose>
      </a>
    </c:forEach>
  </div>

  <c:choose>
    <c:when test="${empty orders}">
      <div class="text-center py-5">
        <i class="bi bi-bag-x fs-1 text-muted"></i>
        <h5 class="text-muted mt-3">Không có đơn hàng nào</h5>
      </div>
    </c:when>
    <c:otherwise>
      <c:forEach var="order" items="${orders}">
        <div class="card border-0 shadow-sm rounded-3 mb-3 order-card"
             onclick="location.href='${pageContext.request.contextPath}/customer/orders/detail?id=${order.donHangId}'">
          <div class="card-body p-4">
            <div class="d-flex justify-content-between align-items-center mb-2">
              <span class="fw-bold text-danger">#${order.donHangId}</span>
              <span class="badge rounded-pill ${order.trangThaiDH == 'hoan_thanh' ? 'bg-success' :
                order.trangThaiDH == 'huy' ? 'bg-danger' : 'bg-warning text-dark'}">
                ${order.trangThaiDHLabel}
              </span>
            </div>
            <div class="d-flex justify-content-between">
              <span class="text-muted small">
                <i class="bi bi-clock me-1"></i>
                ${order.ngayTaoStr}
              </span>
              <span class="fw-bold text-danger">
                <fmt:formatNumber value="${order.thanhTien}" pattern="#,###"/>đ
              </span>
            </div>
          </div>
        </div>
      </c:forEach>
    </c:otherwise>
  </c:choose>
</div>
</div>
<jsp:include page="/WEB-INF/views/common/footer.jsp"/>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
<style>.order-card{cursor:pointer;transition:transform .15s;}
.order-card:hover{transform:translateY(-2px);}</style>
</body>
</html>
