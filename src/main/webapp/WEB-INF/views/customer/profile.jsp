<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c"   uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
  <meta charset="UTF-8"><meta name="viewport" content="width=device-width, initial-scale=1">
  <title>Tài Khoản Của Tôi - PolyPhone</title>
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
  <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.0/font/bootstrap-icons.css" rel="stylesheet">
</head>
<body>

<!--Start of Tawk.to Script-->
<jsp:include page="/WEB-INF/views/common/crisp-chat.jsp"/>


<jsp:include page="/WEB-INF/views/common/header.jsp"/>
<div class="page-content">
<div class="container py-4" style="max-width:700px;">
  <h3 class="fw-bold mb-4"><i class="bi bi-person-circle me-2"></i>Tài khoản của tôi</h3>
  <c:if test="${not empty success}"><div class="alert alert-success">${success}</div></c:if>
  <c:if test="${not empty error}"><div class="alert alert-danger">${error}</div></c:if>

  <!-- Points -->
  <div class="card bg-danger text-white rounded-3 mb-4 border-0">
    <div class="card-body p-4 d-flex align-items-center gap-3">
      <i class="bi bi-star-fill fs-2"></i>
      <div>
        <div class="fw-bold fs-4">${user.diemTichLuy} điểm</div>
        <div class="small opacity-75">Điểm tích lũy của bạn</div>
      </div>
    </div>
  </div>

  <ul class="nav nav-tabs mb-4" id="profileTab">
    <li class="nav-item"><a class="nav-link active" data-bs-toggle="tab" href="#info">Thông tin</a></li>
    <li class="nav-item"><a class="nav-link" data-bs-toggle="tab" href="#password">Đổi mật khẩu</a></li>
  </ul>

  <div class="tab-content">
    <div class="tab-pane fade show active" id="info">
      <div class="card border-0 shadow-sm rounded-3">
        <div class="card-body p-4">
          <form method="post" action="${pageContext.request.contextPath}/customer/profile/update">
            <div class="mb-3">
              <label class="form-label">Họ và tên</label>
              <input type="text" class="form-control" name="hoTen" value="${user.hoTen}" required>
            </div>
            <div class="mb-3">
              <label class="form-label">Email</label>
              <input type="email" class="form-control bg-light" value="${user.email}" readonly>
            </div>
            <div class="mb-3">
              <label class="form-label">Số điện thoại</label>
              <input type="tel" class="form-control" name="soDienThoai" value="${user.soDienThoai}">
            </div>
            <button type="submit" class="btn btn-danger rounded-pill px-4">
              <i class="bi bi-save me-1"></i>Lưu thay đổi
            </button>
          </form>
        </div>
      </div>
    </div>
    <div class="tab-pane fade" id="password">
      <div class="card border-0 shadow-sm rounded-3">
        <div class="card-body p-4">
          <form method="post" action="${pageContext.request.contextPath}/customer/profile/change-password">
            <div class="mb-3">
              <label class="form-label">Mật khẩu hiện tại</label>
              <input type="password" class="form-control" name="currentPassword" required>
            </div>
            <div class="mb-3">
              <label class="form-label">Mật khẩu mới</label>
              <input type="password" class="form-control" name="newPassword" required minlength="6">
            </div>
            <div class="mb-4">
              <label class="form-label">Xác nhận mật khẩu mới</label>
              <input type="password" class="form-control" name="confirmPassword" required>
            </div>
            <button type="submit" class="btn btn-danger rounded-pill px-4">
              <i class="bi bi-shield-lock me-1"></i>Đổi mật khẩu
            </button>
          </form>
        </div>
      </div>
    </div>
  </div>
</div>
</div>
<jsp:include page="/WEB-INF/views/common/footer.jsp"/>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
