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
  <a href="${pageContext.request.contextPath}/admin/dashboard"
     class="d-flex align-items-center mb-3 mb-md-0 me-md-auto text-white text-decoration-none">
    <i class="bi bi-phone-fill me-2 text-danger fs-4"></i>
    <span class="fs-5 fw-bold">PolyPhone Admin</span>
  </a>
  <hr>
  <ul class="nav nav-pills flex-column mb-auto">
    <li class="nav-item mb-1">
      <a href="${pageContext.request.contextPath}/admin/dashboard"
         class="nav-link text-white ${pageContext.request.servletPath == '/admin/dashboard' ? 'active bg-danger' : ''}">
        <i class="bi bi-speedometer2 me-2"></i>Dashboard
      </a>
    </li>
    <li class="mb-1"><small class="text-muted px-3">SẢN PHẨM</small></li>
    <li class="nav-item mb-1">
      <a href="${pageContext.request.contextPath}/admin/products"
         class="nav-link text-white ${pageContext.request.servletPath.startsWith('/admin/products') ? 'active bg-danger' : ''}">
        <i class="bi bi-phone me-2"></i>Sản phẩm
      </a>
    </li>
    <li class="nav-item mb-1">
      <a href="${pageContext.request.contextPath}/admin/categories"
         class="nav-link text-white ${pageContext.request.servletPath.startsWith('/admin/categories') ? 'active bg-danger' : ''}">
        <i class="bi bi-tags me-2"></i>Danh mục
      </a>
    </li>
    <li class="mb-1 mt-2"><small class="text-muted px-3">NGƯỜI DÙNG</small></li>
    <li class="nav-item mb-1">
      <a href="${pageContext.request.contextPath}/admin/users"
         class="nav-link text-white ${pageContext.request.servletPath.startsWith('/admin/users') ? 'active bg-danger' : ''}">
        <i class="bi bi-people me-2"></i>Khách hàng
      </a>
    </li>
    <li class="nav-item mb-1">
      <a href="${pageContext.request.contextPath}/admin/staff"
         class="nav-link text-white ${pageContext.request.servletPath.startsWith('/admin/staff') ? 'active bg-danger' : ''}">
        <i class="bi bi-person-badge me-2"></i>Nhân viên
      </a>
    </li>
    <li class="mb-1 mt-2"><small class="text-muted px-3">ĐƠN HÀNG & KM</small></li>
    <li class="nav-item mb-1">
      <a href="${pageContext.request.contextPath}/admin/orders"
         class="nav-link text-white ${pageContext.request.servletPath.startsWith('/admin/orders') ? 'active bg-danger' : ''}">
        <i class="bi bi-bag me-2"></i>Đơn hàng
      </a>
    </li>
    <li class="nav-item mb-1">
      <a href="${pageContext.request.contextPath}/admin/vouchers"
         class="nav-link text-white ${pageContext.request.servletPath.startsWith('/admin/vouchers') ? 'active bg-danger' : ''}">
        <i class="bi bi-ticket-perforated me-2"></i>Voucher
      </a>
    </li>
    <li class="nav-item mb-1">
      <a href="${pageContext.request.contextPath}/admin/trade-in"
         class="nav-link text-white ${pageContext.request.servletPath == '/admin/trade-in' ? 'active bg-danger' : ''}">
        <i class="bi bi-arrow-left-right me-2"></i>Trade-In (Lịch sử MH)
      </a>
    </li>
    <li class="mb-1 mt-2"><small class="text-muted px-3">HỖ TRỢ</small></li>
    <li class="nav-item mb-1">
      <a href="${pageContext.request.contextPath}/admin/complaints"
         class="nav-link text-white ${pageContext.request.servletPath.startsWith('/admin/complaints') ? 'active bg-danger' : ''}">
        <i class="bi bi-chat-square-text me-2"></i>Khiếu nại
      </a>
    </li>
    <li class="nav-item mb-1">
      <a href="${pageContext.request.contextPath}/admin/reviews"
         class="nav-link text-white ${pageContext.request.servletPath.startsWith('/admin/reviews') ? 'active bg-danger' : ''}">
        <i class="bi bi-star me-2"></i>Đánh giá
      </a>
    </li>
    <li class="nav-item mb-1">
      <a href="${pageContext.request.contextPath}/admin/chat"
         class="nav-link text-white ${pageContext.request.servletPath == '/admin/chat' ? 'active bg-danger' : ''}">
        <i class="bi bi-chat-dots me-2"></i>Hỗ trợ Chat
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
