<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c"   uri="http://java.sun.com/jsp/jstl/core" %>
<jsp:include page="/WEB-INF/views/common/crisp-chat.jsp"/>
<style>
  .sidebar {
    width: 250px;
    height: 100vh;
    position: sticky;
    top: 0;
    overflow-y: auto;
  }
</style>
<div class="d-flex flex-column flex-shrink-0 p-3 bg-dark text-white sidebar">
  <a href="${pageContext.request.contextPath}/staff/orders"
     class="d-flex align-items-center mb-3 mb-md-0 me-md-auto text-white text-decoration-none">
    <i class="bi bi-phone-fill me-2 text-danger fs-4"></i>
    <span class="fs-5 fw-bold">PolyPhone Staff</span>
  </a>
  <hr>
  <ul class="nav nav-pills flex-column mb-auto">
    <li class="mb-1"><small class="text-muted px-3">QUẢN LÝ</small></li>
    <li class="nav-item mb-1">
      <a href="${pageContext.request.contextPath}/staff/orders"
         class="nav-link text-white ${pageContext.request.servletPath.startsWith('/staff/orders') ? 'active bg-danger' : ''}">
        <i class="bi bi-bag me-2"></i>Đơn hàng
      </a>
    </li>
    <li class="nav-item mb-1">
      <a href="${pageContext.request.contextPath}/staff/complaints"
         class="nav-link text-white ${pageContext.request.servletPath.startsWith('/staff/complaints') ? 'active bg-danger' : ''}">
        <i class="bi bi-chat-square-text me-2"></i>Khiếu nại
      </a>
    </li>
    <li class="nav-item mb-1">
      <a href="${pageContext.request.contextPath}/staff/chat"
         class="nav-link text-white ${pageContext.request.servletPath == '/staff/chat' ? 'active bg-danger' : ''}">
        <i class="bi bi-chat-dots me-2"></i>Hỗ trợ Chat
      </a>
    </li>
    <li class="mb-1 mt-2"><small class="text-muted px-3">CÁ NHÂN</small></li>
    <li class="nav-item mb-1">
      <a href="${pageContext.request.contextPath}/staff/profile"
         class="nav-link text-white ${pageContext.request.servletPath == '/staff/profile' ? 'active bg-danger' : ''}">
        <i class="bi bi-person me-2"></i>Hồ sơ
      </a>
    </li>
  </ul>
    <a href="${pageContext.request.contextPath}/PolyPhone/home"
       class="text-white text-decoration-none small d-block mb-2">
        <i class="bi bi-house-door me-2"></i>Về trang chủ
    </a>
  <hr>
  <a href="${pageContext.request.contextPath}/auth/logout" class="text-white text-decoration-none small">
    <i class="bi bi-box-arrow-right me-2"></i>Đăng xuất
  </a>
</div>
