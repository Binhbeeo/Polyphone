<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c"   uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"  %>
<!DOCTYPE html><html lang="vi"><head>
<meta charset="UTF-8"><meta name="viewport" content="width=device-width,initial-scale=1">
<title>Đơn hàng - PolyPhone Staff</title>
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css">
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.css">
</head><body>
<nav class="navbar navbar-dark bg-dark px-4">
  <span class="navbar-brand fw-bold"><i class="bi bi-phone-fill me-2 text-danger"></i>PolyPhone Staff</span>
  <div class="d-flex gap-2">
    <a href="${pageContext.request.contextPath}/staff/orders" class="btn btn-outline-light btn-sm">Đơn hàng</a>
    <a href="${pageContext.request.contextPath}/staff/complaints" class="btn btn-outline-light btn-sm">Khiếu nại</a>
    <a href="${pageContext.request.contextPath}/auth/logout" class="btn btn-danger btn-sm rounded-pill">Đăng xuất</a>
  </div>
</nav>
<div class="container-fluid py-4">
  <h4 class="fw-bold mb-3">Quản lý đơn hàng</h4>
  <div class="mb-3 d-flex gap-2 flex-wrap">
    <a href="?" class="btn btn-sm ${empty trangThai?'btn-danger':'btn-outline-secondary'} rounded-pill">Tất cả</a>
    <a href="?trangThai=moi" class="btn btn-sm ${trangThai=='moi'?'btn-danger':'btn-outline-secondary'} rounded-pill">Mới</a>
    <a href="?trangThai=xac_nhan" class="btn btn-sm ${trangThai=='xac_nhan'?'btn-danger':'btn-outline-secondary'} rounded-pill">Đã xác nhận</a>
    <a href="?trangThai=dong_goi" class="btn btn-sm ${trangThai=='dong_goi'?'btn-danger':'btn-outline-secondary'} rounded-pill">Đóng gói</a>
    <a href="?trangThai=dang_giao" class="btn btn-sm ${trangThai=='dang_giao'?'btn-danger':'btn-outline-secondary'} rounded-pill">Đang giao</a>
    <a href="?trangThai=hoan_thanh" class="btn btn-sm ${trangThai=='hoan_thanh'?'btn-danger':'btn-outline-secondary'} rounded-pill">Hoàn thành</a>
  </div>
  <div class="card border-0 shadow-sm">
    <div class="card-body p-0">
      <table class="table table-hover mb-0 align-middle">
        <thead class="table-light"><tr><th>#</th><th>Khách hàng</th><th>Thành tiền</th><th>Trạng thái</th><th>Ngày đặt</th><th></th></tr></thead>
        <tbody>
          <c:forEach var="o" items="${orders}">
            <tr>
              <td class="fw-bold">${o.donHangId}</td>
              <td>${o.hoTenKhach}</td>
              <td class="text-danger fw-semibold"><fmt:formatNumber value="${o.thanhTien}" pattern="#,###"/>đ</td>
              <td><span class="badge ${o.trangThaiDH=='hoan_thanh'?'bg-success':o.trangThaiDH=='moi'?'bg-primary':'bg-warning text-dark'}">${o.trangThaiDHLabel}</span></td>
              <td class="text-muted small">${o.ngayTao}</td>
              <td><a href="${pageContext.request.contextPath}/staff/orders/detail?id=${o.donHangId}" class="btn btn-sm btn-outline-primary rounded-pill">Chi tiết</a></td>
            </tr>
          </c:forEach>
          <c:if test="${empty orders}"><tr><td colspan="6" class="text-center text-muted py-4">Không có đơn hàng</td></tr></c:if>
        </tbody>
      </table>
    </div>
  </div>
</div>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
</body></html>
