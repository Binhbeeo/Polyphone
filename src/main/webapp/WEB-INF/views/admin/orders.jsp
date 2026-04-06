<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c"   uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"  %>
<!DOCTYPE html><html lang="vi"><head>
<meta charset="UTF-8"><meta name="viewport" content="width=device-width,initial-scale=1">
<title>Quản lý đơn hàng - PolyPhone</title>
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css">
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.css">
</head><body><div class="d-flex">
<jsp:include page="/WEB-INF/views/admin/sidebar.jsp"/>
<div class="flex-grow-1 p-4" style="background:#f8f9fa;min-height:100vh">
  <h4 class="fw-bold mb-4">Quản lý đơn hàng</h4>
  <div class="mb-3 d-flex gap-2 flex-wrap">
    <a href="?" class="btn btn-sm ${empty trangThai?'btn-danger':'btn-outline-secondary'} rounded-pill">Tất cả</a>
    <a href="?trangThai=moi" class="btn btn-sm ${trangThai=='moi'?'btn-danger':'btn-outline-secondary'} rounded-pill">Mới</a>
    <a href="?trangThai=xac_nhan" class="btn btn-sm ${trangThai=='xac_nhan'?'btn-danger':'btn-outline-secondary'} rounded-pill">Đã xác nhận</a>
    <a href="?trangThai=dong_goi" class="btn btn-sm ${trangThai=='dong_goi'?'btn-danger':'btn-outline-secondary'} rounded-pill">Đóng gói</a>
    <a href="?trangThai=dang_giao" class="btn btn-sm ${trangThai=='dang_giao'?'btn-danger':'btn-outline-secondary'} rounded-pill">Đang giao</a>
    <a href="?trangThai=hoan_thanh" class="btn btn-sm ${trangThai=='hoan_thanh'?'btn-danger':'btn-outline-secondary'} rounded-pill">Hoàn thành</a>
    <a href="?trangThai=huy" class="btn btn-sm ${trangThai=='huy'?'btn-danger':'btn-outline-secondary'} rounded-pill">Đã hủy</a>
  </div>
  <div class="card border-0 shadow-sm">
    <div class="card-body p-0">
      <table class="table table-hover mb-0 align-middle">
        <thead class="table-light"><tr><th>#</th><th>Khách hàng</th><th>Thành tiền</th><th>PT thanh toán</th><th>Trạng thái</th><th>Ngày đặt</th><th></th></tr></thead>
        <tbody>
          <c:forEach var="o" items="${orders}">
            <tr>
              <td class="fw-bold">${o.donHangId}</td>
              <td>${o.hoTenKhach}</td>
              <td class="text-danger fw-semibold"><fmt:formatNumber value="${o.thanhTien}" pattern="#,###"/>đ</td>
              <td><span class="badge bg-light text-dark border">${o.phuongThucTT}</span></td>
              <td>
                <c:choose>
                  <c:when test="${o.trangThaiDH=='hoan_thanh'}"><span class="badge bg-success">${o.trangThaiDHLabel}</span></c:when>
                  <c:when test="${o.trangThaiDH=='huy'}"><span class="badge bg-secondary">${o.trangThaiDHLabel}</span></c:when>
                  <c:when test="${o.trangThaiDH=='moi'}"><span class="badge bg-primary">${o.trangThaiDHLabel}</span></c:when>
                  <c:otherwise><span class="badge bg-warning text-dark">${o.trangThaiDHLabel}</span></c:otherwise>
                </c:choose>
              </td>
              <td class="text-muted small">${o.ngayTao}</td>
              <td><a href="${pageContext.request.contextPath}/admin/orders/detail?id=${o.donHangId}" class="btn btn-sm btn-outline-primary rounded-pill">Chi tiết</a></td>
            </tr>
          </c:forEach>
        </tbody>
      </table>
    </div>
  </div>
</div></div>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
</body></html>
