<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c"   uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
  <meta charset="UTF-8"><meta name="viewport" content="width=device-width, initial-scale=1">
  <title>Quên Mật Khẩu - PolyPhone</title>
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
  <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.0/font/bootstrap-icons.css" rel="stylesheet">
</head>
<body class="bg-light">
<div class="min-vh-100 d-flex align-items-center">
  <div class="container">
    <div class="row justify-content-center">
      <div class="col-md-5">
        <div class="card shadow-lg border-0 rounded-4">
          <div class="card-body p-5">
            <div class="text-center mb-4">
              <div class="bg-danger bg-opacity-10 rounded-circle d-inline-flex p-3 mb-3">
                <i class="bi bi-key-fill fs-2 text-danger"></i>
              </div>
              <h4 class="fw-bold">Quên mật khẩu?</h4>
              <p class="text-muted small">Nhập email/SĐT để nhận mã OTP đặt lại mật khẩu</p>
            </div>
            <c:if test="${not empty error}">
              <div class="alert alert-danger py-2">${error}</div>
            </c:if>
            <form method="post" action="${pageContext.request.contextPath}/auth/forgot-password">
              <div class="mb-4">
                <label class="form-label">Email hoặc Số điện thoại</label>
                <input type="text" class="form-control" name="emailOrPhone" required placeholder="Email hoặc SĐT của bạn">
              </div>
              <button type="submit" class="btn btn-danger w-100 rounded-pill py-2">
                <i class="bi bi-send me-1"></i> Gửi mã OTP
              </button>
            </form>
            <div class="text-center mt-3">
              <a href="${pageContext.request.contextPath}/auth/login" class="text-muted small">
                <i class="bi bi-arrow-left me-1"></i> Quay lại đăng nhập
              </a>
            </div>
          </div>
        </div>
      </div>
    </div>
  </div>
</div>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
