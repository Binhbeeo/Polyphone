<style>
html, body { height: 100%; }
body {
  display: flex;
  flex-direction: column;
  min-height: 100vh;
}
.page-content {
  flex: 1;
}
</style>
<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c"   uri="http://java.sun.com/jsp/jstl/core" %>
<nav class="navbar navbar-expand-lg navbar-dark bg-danger sticky-top shadow">
  <div class="container">
    <a class="navbar-brand fw-bold fs-4" href="${pageContext.request.contextPath}/">
      <i class="bi bi-phone-fill me-1"></i>PolyPhone
    </a>
    <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navMain">
      <span class="navbar-toggler-icon"></span>
    </button>
    <div class="collapse navbar-collapse" id="navMain">
      <form class="d-flex mx-auto w-50" action="${pageContext.request.contextPath}/products/search" method="get">
        <input class="form-control me-2 rounded-pill" type="search" name="q"
               placeholder="Tìm kiếm điện thoại..." value="${param.q}">
        <button class="btn btn-light rounded-pill px-3" type="submit">
          <i class="bi bi-search"></i>
        </button>
      </form>
      <ul class="navbar-nav ms-auto align-items-center gap-1">
        <li class="nav-item">
          <a class="nav-link" href="${pageContext.request.contextPath}/products">
            <i class="bi bi-grid me-1"></i>Sản phẩm
          </a>
        </li>
        <c:choose>
          <c:when test="${not empty sessionScope.loggedInUser}">
            <li class="nav-item">
              <a class="nav-link position-relative" href="${pageContext.request.contextPath}/customer/cart">
                <i class="bi bi-cart3 fs-5"></i>
              </a>
            </li>
            <li class="nav-item dropdown">
              <a class="nav-link dropdown-toggle d-flex align-items-center gap-1" href="#" data-bs-toggle="dropdown">
                <i class="bi bi-person-circle fs-5"></i>
                <span class="d-none d-lg-inline">${sessionScope.loggedInUser.hoTen}</span>
              </a>
              <ul class="dropdown-menu dropdown-menu-end shadow">
                <c:choose>
                  <c:when test="${sessionScope.loggedInUser.role == 'admin'}">
                    <li><a class="dropdown-item" href="${pageContext.request.contextPath}/admin/dashboard">
                      <i class="bi bi-speedometer2 me-2"></i>Quản trị</a></li>
                    <li><hr class="dropdown-divider"></li>
                  </c:when>
                  <c:when test="${sessionScope.loggedInUser.role == 'staff'}">
                    <li><a class="dropdown-item" href="${pageContext.request.contextPath}/staff/orders">
                      <i class="bi bi-clipboard-check me-2"></i>Quản lý đơn hàng</a></li>
                    <li><hr class="dropdown-divider"></li>
                  </c:when>
                </c:choose>
                <li><a class="dropdown-item" href="${pageContext.request.contextPath}/customer/profile">
                  <i class="bi bi-person me-2"></i>Tài khoản của tôi</a></li>
                <li><a class="dropdown-item" href="${pageContext.request.contextPath}/customer/orders">
                  <i class="bi bi-bag me-2"></i>Đơn hàng</a></li>
                <li><a class="dropdown-item" href="${pageContext.request.contextPath}/customer/wishlist">
                  <i class="bi bi-heart me-2"></i>Yêu thích</a></li>
                <li><a class="dropdown-item" href="${pageContext.request.contextPath}/customer/complaints">
                  <i class="bi bi-chat-square-text me-2"></i>Khiếu nại</a></li>
                <li><hr class="dropdown-divider"></li>
                <li><a class="dropdown-item text-danger" href="${pageContext.request.contextPath}/auth/logout">
                  <i class="bi bi-box-arrow-right me-2"></i>Đăng xuất</a></li>
              </ul>
            </li>
          </c:when>
          <c:otherwise>
            <li class="nav-item">
              <a class="nav-link" href="${pageContext.request.contextPath}/auth/login">
                <i class="bi bi-box-arrow-in-right me-1"></i>Đăng nhập
              </a>
            </li>
            <li class="nav-item">
              <a class="btn btn-light btn-sm rounded-pill px-3" href="${pageContext.request.contextPath}/auth/register">
                Đăng ký
              </a>
            </li>
          </c:otherwise>
        </c:choose>
      </ul>
    </div>
  </div>
</nav>
