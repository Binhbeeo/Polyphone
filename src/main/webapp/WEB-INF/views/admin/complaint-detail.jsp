<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c"   uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html><html lang="vi"><head>
<meta charset="UTF-8"><meta name="viewport" content="width=device-width,initial-scale=1">
<title>Xử lý khiếu nại - PolyPhone</title>
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css">
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.css">
</head><body><div class="d-flex">
<jsp:include page="/WEB-INF/views/admin/sidebar.jsp"/>
<div class="flex-grow-1 p-4" style="background:#f8f9fa;min-height:100vh">
  <a href="${pageContext.request.contextPath}/admin/complaints" class="btn btn-link text-danger ps-0 mb-3"><i class="bi bi-arrow-left me-1"></i>Quay lại</a>
  <div class="card border-0 shadow-sm mb-4" style="max-width:720px">
    <div class="card-header bg-white d-flex justify-content-between align-items-center">
      <h5 class="fw-bold mb-0">Khiếu nại #${complaint.khieuNaiId}</h5>
      <span class="badge ${complaint.trangThai=='da_xu_ly'?'bg-success':complaint.trangThai=='dang_xu_ly'?'bg-warning text-dark':'bg-secondary'}">${complaint.trangThaiLabel}</span>
    </div>
    <div class="card-body">
      <p class="text-muted small mb-1">Khách hàng: <strong>${complaint.hoTenKhach}</strong> &bull; Ngày gửi: ${complaint.ngayTao}</p>
      <c:if test="${not empty complaint.donHangId}"><p class="text-muted small">Liên quan đơn hàng: <strong>#${complaint.donHangId}</strong></p></c:if>
      <h6 class="fw-bold mt-3">${complaint.tieuDe}</h6>
      <div class="bg-light rounded p-3 mb-4">${complaint.noiDung}</div>
      <c:if test="${not empty complaint.phanHoi}">
        <div class="alert alert-success"><strong>Phản hồi đã gửi:</strong> ${complaint.phanHoi}</div>
      </c:if>
      <c:if test="${complaint.trangThai != 'da_xu_ly'}">
        <h6 class="fw-bold">Phản hồi khiếu nại</h6>
        <form method="post" action="${pageContext.request.contextPath}/admin/complaints/respond">
          <input type="hidden" name="id" value="${complaint.khieuNaiId}">
          <div class="mb-3">
            <select class="form-select mb-2" name="trangThai">
              <option value="dang_xu_ly">Đang xử lý</option>
              <option value="da_xu_ly">Đã xử lý</option>
            </select>
            <textarea class="form-control" name="phanHoi" rows="4" required placeholder="Nhập nội dung phản hồi cho khách hàng..."></textarea>
          </div>
          <button class="btn btn-danger rounded-pill px-4">Gửi phản hồi</button>
        </form>
      </c:if>
    </div>
  </div>
</div></div>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
</body></html>
