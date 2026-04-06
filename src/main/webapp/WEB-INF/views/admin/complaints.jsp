<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c"   uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html><html lang="vi"><head>
<meta charset="UTF-8"><meta name="viewport" content="width=device-width,initial-scale=1">
<title>Quản lý khiếu nại - PolyPhone</title>
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css">
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.css">
</head><body><div class="d-flex">
<jsp:include page="/WEB-INF/views/admin/sidebar.jsp"/>
<div class="flex-grow-1 p-4" style="background:#f8f9fa;min-height:100vh">
  <h4 class="fw-bold mb-4">Quản lý khiếu nại</h4>
  <div class="card border-0 shadow-sm">
    <div class="card-body p-0">
      <table class="table table-hover mb-0 align-middle">
        <thead class="table-light"><tr><th>#</th><th>Khách hàng</th><th>Tiêu đề</th><th>Đơn hàng</th><th>Trạng thái</th><th>Ngày gửi</th><th></th></tr></thead>
        <tbody>
          <c:forEach var="kn" items="${complaints}">
            <tr>
              <td>${kn.khieuNaiId}</td>
              <td class="fw-semibold">${kn.hoTenKhach}</td>
              <td>${kn.tieuDe}</td>
              <td>${empty kn.donHangId ? '—' : '#'.concat(kn.donHangId)}</td>
              <td>
                <c:choose>
                  <c:when test="${kn.trangThai=='da_xu_ly'}"><span class="badge bg-success">${kn.trangThaiLabel}</span></c:when>
                  <c:when test="${kn.trangThai=='dang_xu_ly'}"><span class="badge bg-warning text-dark">${kn.trangThaiLabel}</span></c:when>
                  <c:otherwise><span class="badge bg-secondary">${kn.trangThaiLabel}</span></c:otherwise>
                </c:choose>
              </td>
              <td class="text-muted small">${kn.ngayTao}</td>
              <td><a href="${pageContext.request.contextPath}/admin/complaints/detail?id=${kn.khieuNaiId}" class="btn btn-sm btn-outline-primary rounded-pill">Xử lý</a></td>
            </tr>
          </c:forEach>
          <c:if test="${empty complaints}"><tr><td colspan="7" class="text-center text-muted py-4">Không có khiếu nại nào</td></tr></c:if>
        </tbody>
      </table>
    </div>
  </div>
</div></div>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
</body></html>
