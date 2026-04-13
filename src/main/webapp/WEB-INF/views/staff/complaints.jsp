<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c"   uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html><html lang="vi"><head>
<meta charset="UTF-8"><meta name="viewport" content="width=device-width,initial-scale=1">
<title>Khiếu nại - Staff</title>
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css">
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.css">
</head><body>
<jsp:include page="/WEB-INF/views/common/crisp-chat.jsp"/>
<jsp:include page="/WEB-INF/views/common/crisp-chat.jsp"/>
<nav class="navbar navbar-dark bg-dark px-4">
  <span class="navbar-brand fw-bold"><i class="bi bi-phone-fill me-2 text-danger"></i>PolyPhone Staff</span>
  <div class="d-flex gap-2">
    <a href="${pageContext.request.contextPath}/staff/orders" class="btn btn-outline-light btn-sm">Đơn hàng</a>
    <a href="${pageContext.request.contextPath}/staff/complaints" class="btn btn-outline-light btn-sm">Khiếu nại</a>
    <a href="${pageContext.request.contextPath}/auth/logout" class="btn btn-danger btn-sm rounded-pill">Đăng xuất</a>
  </div>
</nav>
<div class="container-fluid py-4">
  <h4 class="fw-bold mb-4">Quản lý khiếu nại</h4>
  <div class="card border-0 shadow-sm">
    <div class="card-body p-0">
      <table class="table table-hover mb-0 align-middle">
        <thead class="table-light"><tr><th>#</th><th>Khách hàng</th><th>Tiêu đề</th><th>Trạng thái</th><th>Ngày gửi</th><th></th></tr></thead>
        <tbody>
          <c:forEach var="kn" items="${complaints}">
            <tr>
              <td>${kn.khieuNaiId}</td>
              <td class="fw-semibold">${kn.hoTenKhach}</td>
              <td>${kn.tieuDe}</td>
              <td><span class="badge ${kn.trangThai=='da_xu_ly'?'bg-success':kn.trangThai=='dang_xu_ly'?'bg-warning text-dark':'bg-secondary'}">${kn.trangThaiLabel}</span></td>
              <td class="text-muted small">${kn.ngayTao}</td>
              <td><a href="${pageContext.request.contextPath}/staff/complaints/detail?id=${kn.khieuNaiId}" class="btn btn-sm btn-outline-primary rounded-pill">Xử lý</a></td>
            </tr>
          </c:forEach>
          <c:if test="${empty complaints}"><tr><td colspan="6" class="text-center text-muted py-4">Không có khiếu nại</td></tr></c:if>
        </tbody>
      </table>
    </div>
  </div>
</div>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
</body></html>
