<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c"   uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html><html lang="vi"><head>
<meta charset="UTF-8"><meta name="viewport" content="width=device-width,initial-scale=1">
<title>Thêm nhân viên - PolyPhone</title>
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css">
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.css">
</head><body><div class="d-flex">
<jsp:include page="/WEB-INF/views/admin/sidebar.jsp"/>
<div class="flex-grow-1 p-4" style="background:#f8f9fa;min-height:100vh">
  <h4 class="fw-bold mb-4">Thêm nhân viên mới</h4>
  <div class="card border-0 shadow-sm" style="max-width:550px">
    <div class="card-body">
      <c:if test="${not empty error}"><div class="alert alert-danger">${error}</div></c:if>
      <form method="post" action="${pageContext.request.contextPath}/admin/staff/add">
        <div class="mb-3"><label class="form-label fw-semibold">Họ tên <span class="text-danger">*</span></label>
          <input class="form-control" name="hoTen" required placeholder="Nguyễn Văn A"></div>
        <div class="mb-3"><label class="form-label fw-semibold">Email <span class="text-danger">*</span></label>
          <input class="form-control" name="email" type="email" required placeholder="nhanvien@polyphone.vn"></div>
        <div class="mb-3"><label class="form-label fw-semibold">Số điện thoại</label>
          <input class="form-control" name="soDienThoai" placeholder="0901234567"></div>
        <div class="mb-3"><label class="form-label fw-semibold">Mật khẩu <span class="text-danger">*</span></label>
          <input class="form-control" name="password" type="password" required minlength="6" placeholder="Tối thiểu 6 ký tự"></div>
        <div class="d-flex gap-2">
          <button class="btn btn-danger rounded-pill px-4">Tạo tài khoản</button>
          <a href="${pageContext.request.contextPath}/admin/staff" class="btn btn-outline-secondary rounded-pill px-4">Hủy</a>
        </div>
      </form>
    </div>
  </div>
</div></div>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
</body></html>
