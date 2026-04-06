<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c"   uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html><html lang="vi"><head>
<meta charset="UTF-8"><meta name="viewport" content="width=device-width,initial-scale=1">
<title>Xử lý khiếu nại - Staff</title>
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css">
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.css">
</head><body>
<nav class="navbar navbar-dark bg-dark px-4">
  <span class="navbar-brand fw-bold"><i class="bi bi-phone-fill me-2 text-danger"></i>PolyPhone Staff</span>
  <a href="${pageContext.request.contextPath}/auth/logout" class="btn btn-danger btn-sm rounded-pill">Đăng xuất</a>
</nav>
<div class="container py-4" style="max-width:700px">
  <a href="${pageContext.request.contextPath}/staff/complaints" class="btn btn-link text-danger ps-0 mb-3"><i class="bi bi-arrow-left me-1"></i>Quay lại</a>
  <div class="card border-0 shadow-sm">
    <div class="card-header bg-white d-flex justify-content-between">
      <h5 class="fw-bold mb-0">Khiếu nại #${complaint.khieuNaiId}</h5>
      <span class="badge ${complaint.trangThai=='da_xu_ly'?'bg-success':'bg-secondary'}">${complaint.trangThaiLabel}</span>
    </div>
    <div class="card-body">
      <p class="text-muted small">Khách: <strong>${complaint.hoTenKhach}</strong> &bull; ${complaint.ngayTao}</p>
      <h6 class="fw-bold">${complaint.tieuDe}</h6>
      <div class="bg-light rounded p-3 mb-4">${complaint.noiDung}</div>
      <c:if test="${not empty complaint.phanHoi}">
        <div class="alert alert-success mb-3"><strong>Phản hồi:</strong> ${complaint.phanHoi}</div>
      </c:if>
      <c:if test="${complaint.trangThai != 'da_xu_ly'}">
        <form method="post" action="${pageContext.request.contextPath}/staff/complaints/respond">
          <input type="hidden" name="id" value="${complaint.khieuNaiId}">
          <div class="mb-3"><label class="form-label fw-semibold">Phản hồi cho khách hàng</label>
            <textarea class="form-control" name="phanHoi" rows="4" required placeholder="Nhập nội dung phản hồi..."></textarea></div>
          <button class="btn btn-danger rounded-pill px-4">Gửi phản hồi & Đóng khiếu nại</button>
        </form>
      </c:if>
    </div>
  </div>
</div>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
</body></html>
