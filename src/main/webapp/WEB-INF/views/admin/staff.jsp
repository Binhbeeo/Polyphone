<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c"   uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html><html lang="vi"><head>
<meta charset="UTF-8"><meta name="viewport" content="width=device-width,initial-scale=1">
<title>Quản lý nhân viên - PolyPhone</title>
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css">
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.css">
</head><body><div class="d-flex">
<jsp:include page="/WEB-INF/views/admin/sidebar.jsp"/>
<div class="flex-grow-1 p-4" style="background:#f8f9fa;min-height:100vh">
  <div class="d-flex justify-content-between align-items-center mb-4">
    <h4 class="fw-bold mb-0">Quản lý nhân viên</h4>
    <a href="${pageContext.request.contextPath}/admin/staff/add" class="btn btn-danger rounded-pill px-4"><i class="bi bi-plus-lg me-1"></i>Thêm nhân viên</a>
  </div>
  <c:if test="${param.success=='1'}"><div class="alert alert-success">Tạo tài khoản nhân viên thành công!</div></c:if>
  <div class="card border-0 shadow-sm">
    <div class="card-body p-0">
      <table class="table table-hover mb-0 align-middle">
        <thead class="table-light"><tr><th>#</th><th>Họ tên</th><th>Email</th><th>SĐT</th><th>Trạng thái</th><th>Thao tác</th></tr></thead>
        <tbody>
          <c:forEach var="s" items="${staffList}">
            <tr>
              <td>${s.userId}</td>
              <td class="fw-semibold">${s.hoTen}</td>
              <td class="text-muted small">${s.email}</td>
              <td class="text-muted small">${s.soDienThoai}</td>
              <td><span class="badge ${s.dangHoatDong?'bg-success':'bg-secondary'}">${s.dangHoatDong?'Hoạt động':'Bị khóa'}</span></td>
              <td class="d-flex gap-1">
                <form method="post" action="${pageContext.request.contextPath}/admin/users/toggle">
                  <input type="hidden" name="id" value="${s.userId}">
                  <input type="hidden" name="active" value="${s.dangHoatDong?'0':'1'}">
                  <button class="btn btn-sm ${s.dangHoatDong?'btn-outline-warning':'btn-outline-success'} rounded-pill">${s.dangHoatDong?'Khóa':'Mở khóa'}</button>
                </form>
                <form method="post" action="${pageContext.request.contextPath}/admin/staff/delete" onsubmit="return confirm('Xóa tài khoản nhân viên?')">
                  <input type="hidden" name="id" value="${s.userId}">
                  <button class="btn btn-sm btn-outline-danger rounded-pill"><i class="bi bi-trash"></i></button>
                </form>
              </td>
            </tr>
          </c:forEach>
          <c:if test="${empty staffList}"><tr><td colspan="6" class="text-center text-muted py-4">Chưa có nhân viên nào</td></tr></c:if>
        </tbody>
      </table>
    </div>
  </div>
</div></div>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
</body></html>
