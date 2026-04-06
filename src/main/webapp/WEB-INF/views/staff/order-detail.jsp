<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c"   uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"  %>
<!DOCTYPE html><html lang="vi"><head>
<meta charset="UTF-8"><meta name="viewport" content="width=device-width,initial-scale=1">
<title>Chi tiết đơn hàng - Staff</title>
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css">
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.css">
</head><body>
<nav class="navbar navbar-dark bg-dark px-4">
  <span class="navbar-brand fw-bold"><i class="bi bi-phone-fill me-2 text-danger"></i>PolyPhone Staff</span>
  <a href="${pageContext.request.contextPath}/auth/logout" class="btn btn-danger btn-sm rounded-pill">Đăng xuất</a>
</nav>
<div class="container py-4" style="max-width:800px">
  <a href="${pageContext.request.contextPath}/staff/orders" class="btn btn-link text-danger ps-0 mb-3"><i class="bi bi-arrow-left me-1"></i>Quay lại</a>
  <div class="card border-0 shadow-sm mb-4">
    <div class="card-header bg-white d-flex justify-content-between">
      <h5 class="fw-bold mb-0">Đơn hàng #${order.donHangId}</h5>
      <span class="badge ${order.trangThaiDH=='hoan_thanh'?'bg-success':order.trangThaiDH=='huy'?'bg-secondary':'bg-warning text-dark'} fs-6">${order.trangThaiDHLabel}</span>
    </div>
    <div class="card-body">
      <div class="row g-3 mb-3">
        <div class="col-md-6"><span class="text-muted small">Khách hàng</span><div class="fw-semibold">${order.hoTenKhach}</div></div>
        <div class="col-md-6"><span class="text-muted small">Địa chỉ</span><div class="fw-semibold">${order.diaChi}</div></div>
        <div class="col-md-6"><span class="text-muted small">Phương thức TT</span><div class="fw-semibold">${order.phuongThucTT}</div></div>
        <div class="col-md-6"><span class="text-muted small">Ghi chú</span><div class="fw-semibold">${empty order.ghiChu?'—':order.ghiChu}</div></div>
      </div>
      <table class="table table-borderless">
        <thead class="table-light"><tr><th>Sản phẩm</th><th class="text-center">SL</th><th class="text-end">Đơn giá</th><th class="text-end">Thành tiền</th></tr></thead>
        <tbody>
          <c:forEach var="ct" items="${order.chiTietList}">
            <tr>
              <td>${ct.tenSanPham}</td><td class="text-center">${ct.soLuong}</td>
              <td class="text-end"><fmt:formatNumber value="${ct.donGia}" pattern="#,###"/>đ</td>
              <td class="text-end fw-semibold"><fmt:formatNumber value="${ct.thanhTien}" pattern="#,###"/>đ</td>
            </tr>
          </c:forEach>
        </tbody>
      </table>
      <div class="text-end fw-bold fs-5 text-danger">Tổng: <fmt:formatNumber value="${order.thanhTien}" pattern="#,###"/>đ</div>
    </div>
  </div>
  <c:if test="${order.trangThaiDH != 'hoan_thanh' && order.trangThaiDH != 'huy'}">
    <div class="card border-0 shadow-sm">
      <div class="card-body">
        <h6 class="fw-bold mb-3">Cập nhật trạng thái</h6>
        <form method="post" action="${pageContext.request.contextPath}/staff/orders/update-status" class="d-flex gap-2">
          <input type="hidden" name="id" value="${order.donHangId}">
          <select class="form-select" name="trangThai" style="max-width:220px">
            <option value="xac_nhan">Xác nhận đơn</option>
            <option value="dong_goi">Đóng gói</option>
            <option value="dang_giao">Đang giao</option>
            <option value="hoan_thanh">Giao thành công</option>
            <option value="huy">Hủy đơn</option>
          </select>
          <button class="btn btn-danger rounded-pill px-4">Cập nhật</button>
        </form>
      </div>
    </div>
  </c:if>
</div>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
</body></html>
