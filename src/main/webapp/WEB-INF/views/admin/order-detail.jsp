<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c"   uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"  %>
<!DOCTYPE html><html lang="vi"><head>
<meta charset="UTF-8"><meta name="viewport" content="width=device-width,initial-scale=1">
<title>Chi tiết đơn hàng - Admin PolyPhone</title>
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css">
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.css">
</head><body><div class="d-flex">
<jsp:include page="/WEB-INF/views/admin/sidebar.jsp"/>
<div class="flex-grow-1 p-4" style="background:#f8f9fa;min-height:100vh">
  <a href="${pageContext.request.contextPath}/admin/orders" class="btn btn-link text-danger ps-0 mb-3"><i class="bi bi-arrow-left me-1"></i>Quay lại</a>
  <div class="card border-0 shadow-sm mb-3">
    <div class="card-header bg-white d-flex justify-content-between align-items-center">
      <h5 class="fw-bold mb-0">Đơn hàng #${order.donHangId}</h5>
      <c:choose>
        <c:when test="${order.trangThaiDH=='hoan_thanh'}"><span class="badge bg-success fs-6">${order.trangThaiDHLabel}</span></c:when>
        <c:when test="${order.trangThaiDH=='huy'}"><span class="badge bg-secondary fs-6">${order.trangThaiDHLabel}</span></c:when>
        <c:otherwise><span class="badge bg-warning text-dark fs-6">${order.trangThaiDHLabel}</span></c:otherwise>
      </c:choose>
    </div>
    <div class="card-body">
      <div class="row g-3 mb-4">
        <div class="col-md-4"><div class="text-muted small">Khách hàng</div><div class="fw-semibold">${order.hoTenKhach}</div></div>
        <div class="col-md-4"><div class="text-muted small">Địa chỉ</div><div class="fw-semibold">${order.diaChi}</div></div>
        <div class="col-md-4"><div class="text-muted small">Phương thức thanh toán</div><div class="fw-semibold">${order.phuongThucTT}</div></div>
        <div class="col-md-4"><div class="text-muted small">Ngày đặt</div><div class="fw-semibold">${order.ngayTao}</div></div>
        <div class="col-md-4"><div class="text-muted small">Ghi chú</div><div class="fw-semibold">${empty order.ghiChu ? '—' : order.ghiChu}</div></div>
      </div>
      <table class="table table-borderless">
        <thead class="table-light"><tr><th>Sản phẩm</th><th class="text-center">SL</th><th class="text-end">Đơn giá</th><th class="text-end">Thành tiền</th></tr></thead>
        <tbody>
          <c:forEach var="ct" items="${order.chiTietList}">
            <tr>
              <td>${ct.tenSanPham}</td>
              <td class="text-center">${ct.soLuong}</td>
              <td class="text-end"><fmt:formatNumber value="${ct.donGia}" pattern="#,###"/>đ</td>
              <td class="text-end fw-semibold"><fmt:formatNumber value="${ct.thanhTien}" pattern="#,###"/>đ</td>
            </tr>
          </c:forEach>
        </tbody>
      </table>
      <div class="text-end">
        <c:if test="${order.tienGiamVoucher > 0}"><div class="text-success small">-<fmt:formatNumber value="${order.tienGiamVoucher}" pattern="#,###"/>đ (voucher)</div></c:if>
        <div class="fw-bold fs-5 text-danger">Tổng: <fmt:formatNumber value="${order.thanhTien}" pattern="#,###"/>đ</div>
      </div>
    </div>
  </div>
  <c:if test="${order.trangThaiDH != 'hoan_thanh' && order.trangThaiDH != 'huy'}">
    <div class="card border-0 shadow-sm">
      <div class="card-body">
        <h6 class="fw-bold mb-3">Cập nhật trạng thái</h6>
        <form method="post" action="${pageContext.request.contextPath}/admin/orders/update-status" class="d-flex gap-2">
          <input type="hidden" name="id" value="${order.donHangId}">
          <select class="form-select" name="trangThai" style="max-width:220px">
            <option value="xac_nhan">Xác nhận</option>
            <option value="dong_goi">Đóng gói</option>
            <option value="dang_giao">Đang giao</option>
            <option value="hoan_thanh">Hoàn thành</option>
            <option value="huy">Hủy đơn</option>
          </select>
          <button class="btn btn-danger rounded-pill px-4">Cập nhật</button>
        </form>
      </div>
    </div>
  </c:if>
</div></div>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
</body></html>
