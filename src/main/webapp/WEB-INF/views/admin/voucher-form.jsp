<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c"   uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html><html lang="vi"><head>
<meta charset="UTF-8"><meta name="viewport" content="width=device-width,initial-scale=1">
<title>${empty voucher?'Tạo':'Sửa'} Voucher - PolyPhone</title>
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css">
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.css">
</head><body><div class="d-flex">
<jsp:include page="/WEB-INF/views/admin/sidebar.jsp"/>
<div class="flex-grow-1 p-4" style="background:#f8f9fa;min-height:100vh">
  <h4 class="fw-bold mb-4">${empty voucher?'Tạo Voucher mới':'Sửa Voucher'}</h4>
  <div class="card border-0 shadow-sm" style="max-width:600px">
    <div class="card-body">
      <form method="post" action="${pageContext.request.contextPath}/admin/vouchers/${empty voucher?'add':'edit'}">
        <c:if test="${not empty voucher}">
          <input type="hidden" name="voucherId" value="${voucher.voucherId}">
        </c:if>
        <div class="row g-3">
          <div class="col-md-6"><label class="form-label fw-semibold">Mã voucher <span class="text-danger">*</span></label>
            <input class="form-control text-uppercase" name="maVoucher" required value="${voucher.maVoucher}" placeholder="POLY10" ${not empty voucher?'readonly':''}></div>
          <div class="col-md-6"><label class="form-label fw-semibold">Loại giảm <span class="text-danger">*</span></label>
            <select class="form-select" name="loaiGiam" required>
              <option value="phan_tram" ${voucher.loaiGiam=='phan_tram'?'selected':''}>Phần trăm (%)</option>
              <option value="co_dinh" ${voucher.loaiGiam=='co_dinh'?'selected':''}>Cố định (đ)</option>
            </select></div>
          <div class="col-md-6"><label class="form-label fw-semibold">Giá trị giảm <span class="text-danger">*</span></label>
            <input class="form-control" name="giaTriGiam" type="number" required min="0" value="${voucher.giaTriGiam}" placeholder="VD: 10 hoặc 200000"></div>
          <div class="col-md-6"><label class="form-label fw-semibold">Đơn hàng tối thiểu (đ)</label>
            <input class="form-control" name="donHangToiThieu" type="number" min="0" value="${voucher.donHangToiThieu}"></div>
          <div class="col-md-6"><label class="form-label fw-semibold">Số lượt dùng tối đa</label>
            <input class="form-control" name="soLuotDungToiDa" type="number" min="1" value="${empty voucher?100:voucher.soLuotDungToiDa}"></div>
          <div class="col-md-6"><label class="form-label fw-semibold">Ngày bắt đầu</label>
            <input class="form-control" name="ngayBatDau" type="datetime-local" value="${voucher.ngayBatDau}"></div>
          <div class="col-12"><label class="form-label fw-semibold">Ngày hết hạn</label>
            <input class="form-control" name="hetHan" type="datetime-local" value="${voucher.hetHan}"></div>
          <c:if test="${not empty voucher}">
            <div class="col-md-6"><label class="form-label fw-semibold">Trạng thái</label>
              <select class="form-select" name="dangHoatDong">
                <option value="1" ${voucher.dangHoatDong?'selected':''}>Hoạt động</option>
                <option value="0" ${!voucher.dangHoatDong?'selected':''}>Tắt</option>
              </select></div>
          </c:if>
          <div class="col-12 d-flex gap-2">
            <button class="btn btn-danger rounded-pill px-4">Lưu</button>
            <a href="${pageContext.request.contextPath}/admin/vouchers" class="btn btn-outline-secondary rounded-pill px-4">Hủy</a>
          </div>
        </div>
      </form>
    </div>
  </div>
</div></div>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
</body></html>
