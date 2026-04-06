<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c"   uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html><html lang="vi"><head>
<meta charset="UTF-8"><meta name="viewport" content="width=device-width,initial-scale=1">
<title>Tài khoản - Staff</title>
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css">
</head><body>
<nav class="navbar navbar-dark bg-dark px-4">
  <span class="navbar-brand fw-bold">PolyPhone Staff</span>
  <a href="${pageContext.request.contextPath}/auth/logout" class="btn btn-danger btn-sm rounded-pill">Đăng xuất</a>
</nav>
<div class="container py-4" style="max-width:500px">
  <h5 class="fw-bold mb-4">Thông tin tài khoản</h5>
  <div class="card border-0 shadow-sm">
    <div class="card-body">
      <p><strong>Họ tên:</strong> ${user.hoTen}</p>
      <p><strong>Email:</strong> ${user.email}</p>
      <p><strong>SĐT:</strong> ${user.soDienThoai}</p>
      <p><strong>Vai trò:</strong> Nhân viên</p>
    </div>
  </div>
</div>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
</body></html>
