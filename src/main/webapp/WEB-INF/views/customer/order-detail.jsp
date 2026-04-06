<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c"   uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"  %>
<!DOCTYPE html>
<html lang="vi">
<head>
  <meta charset="UTF-8"><meta name="viewport" content="width=device-width, initial-scale=1">
  <title>Chi Tiết Đơn Hàng - PolyPhone</title>
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
  <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.0/font/bootstrap-icons.css" rel="stylesheet">
</head>
<body>
<jsp:include page="/WEB-INF/views/common/header.jsp"/>
<div class="page-content">
<div class="container py-4" style="max-width:800px;">
  <div class="d-flex align-items-center gap-3 mb-4">
    <a href="${pageContext.request.contextPath}/customer/orders" class="btn btn-outline-secondary btn-sm rounded-pill">
      <i class="bi bi-arrow-left me-1"></i>Quay lại
    </a>
    <h4 class="fw-bold mb-0">Đơn hàng #${order.donHangId}</h4>
    <span class="badge rounded-pill fs-6 ${order.trangThaiDH == 'hoan_thanh' ? 'bg-success' :
      order.trangThaiDH == 'huy' ? 'bg-danger' : 'bg-warning text-dark'}">
      ${order.trangThaiDHLabel}
    </span>
  </div>

  <!-- Tracking Steps -->
  <div class="card border-0 shadow-sm rounded-3 mb-4">
    <div class="card-body p-4">
      <div class="d-flex justify-content-between position-relative">
        <div style="position:absolute;top:20px;left:10%;right:10%;height:2px;background:#dee2e6;z-index:0;"></div>
        <c:forEach items="${['moi','xac_nhan','dong_goi','dang_giao','hoan_thanh']}" var="step" varStatus="st">
          <c:set var="done" value="${order.trangThaiDH == step ||
            (step=='moi' && order.trangThaiDH != 'huy') ||
            (step=='xac_nhan' && (order.trangThaiDH=='dong_goi'||order.trangThaiDH=='dang_giao'||order.trangThaiDH=='hoan_thanh')) ||
            (step=='dong_goi' && (order.trangThaiDH=='dang_giao'||order.trangThaiDH=='hoan_thanh')) ||
            (step=='dang_giao' && order.trangThaiDH=='hoan_thanh')}"/>
          <div class="text-center position-relative" style="z-index:1;">
            <div class="rounded-circle d-inline-flex align-items-center justify-content-center mb-1
              ${done ? 'bg-danger text-white' : 'bg-light border text-muted'}"
                 style="width:40px;height:40px;font-size:.85rem;">
              <c:choose>
                <c:when test="${step=='moi'}"><i class="bi bi-receipt"></i></c:when>
                <c:when test="${step=='xac_nhan'}"><i class="bi bi-check2"></i></c:when>
                <c:when test="${step=='dong_goi'}"><i class="bi bi-box"></i></c:when>
                <c:when test="${step=='dang_giao'}"><i class="bi bi-truck"></i></c:when>
                <c:when test="${step=='hoan_thanh'}"><i class="bi bi-house"></i></c:when>
              </c:choose>
            </div>
            <div class="small ${done ? 'text-danger fw-semibold' : 'text-muted'}" style="font-size:.75rem;">
              <c:choose>
                <c:when test="${step=='moi'}">Đặt hàng</c:when>
                <c:when test="${step=='xac_nhan'}">Xác nhận</c:when>
                <c:when test="${step=='dong_goi'}">Đóng gói</c:when>
                <c:when test="${step=='dang_giao'}">Vận chuyển</c:when>
                <c:when test="${step=='hoan_thanh'}">Nhận hàng</c:when>
              </c:choose>
            </div>
          </div>
        </c:forEach>
      </div>
    </div>
  </div>

  <!-- Products -->
  <div class="card border-0 shadow-sm rounded-3 mb-4">
    <div class="card-body p-4">
      <h6 class="fw-bold mb-3">Sản phẩm đã đặt</h6>
      <c:forEach var="ct" items="${order.chiTietList}">
        <div class="d-flex align-items-center gap-3 mb-3">
          <img src="${not empty ct.anhUrl ? ct.anhUrl : ''}" style="width:60px;height:60px;object-fit:cover;" class="rounded-2">
          <div class="flex-grow-1">
            <div class="fw-semibold">${ct.tenSanPham}</div>
            <div class="small text-muted">
              <fmt:formatNumber value="${ct.donGia}" pattern="#,###"/>đ x ${ct.soLuong}
            </div>
          </div>
          <div class="text-end">
            <div class="fw-bold text-danger mb-1"><fmt:formatNumber value="${ct.thanhTien}" pattern="#,###"/>đ</div>
            <c:if test="${order.trangThaiDH == 'hoan_thanh'}">
              <a href="${pageContext.request.contextPath}/customer/orders/review?donHangId=${order.donHangId}&sanPhamId=${ct.sanPhamId}"
                 class="btn btn-sm btn-outline-warning rounded-pill">
                <i class="bi bi-star me-1"></i>Đánh giá
              </a>
            </c:if>
          </div>
        </div>
      </c:forEach>
    </div>
  </div>

  <!-- Summary -->
  <div class="card border-0 shadow-sm rounded-3 mb-4">
    <div class="card-body p-4">
      <h6 class="fw-bold mb-3">Tóm tắt đơn hàng</h6>
      <div class="d-flex justify-content-between mb-2">
        <span class="text-muted">Tổng tiền hàng:</span>
        <span><fmt:formatNumber value="${order.tongTien}" pattern="#,###"/>đ</span>
      </div>
      <c:if test="${order.tienGiamVoucher > 0}">
        <div class="d-flex justify-content-between mb-2 text-success">
          <span>Giảm voucher:</span>
          <span>-<fmt:formatNumber value="${order.tienGiamVoucher}" pattern="#,###"/>đ</span>
        </div>
      </c:if>
      <c:if test="${order.tienGiamDiem > 0}">
        <div class="d-flex justify-content-between mb-2 text-success">
          <span>Giảm từ điểm:</span>
          <span>-<fmt:formatNumber value="${order.tienGiamDiem}" pattern="#,###"/>đ</span>
        </div>
      </c:if>
      <hr>
      <div class="d-flex justify-content-between fw-bold fs-5">
        <span>Thanh toán:</span>
        <span class="text-danger"><fmt:formatNumber value="${order.thanhTien}" pattern="#,###"/>đ</span>
      </div>
      <div class="mt-2 text-muted small">
        Phương thức: <strong>${order.phuongThucTT}</strong> |
        Điểm được cộng: <strong class="text-warning">${order.diemDuocCong} điểm</strong>
      </div>
    </div>
  </div>

  <!-- Address -->
  <div class="card border-0 shadow-sm rounded-3 mb-4">
    <div class="card-body p-4">
      <h6 class="fw-bold mb-2"><i class="bi bi-geo-alt me-1"></i>Địa chỉ giao hàng</h6>
      <p class="mb-0">${order.diaChi}</p>
    </div>
  </div>

  <!-- Actions -->
  <div class="d-flex gap-2">
    <c:if test="${order.trangThaiDH == 'moi'}">
      <form method="post" action="${pageContext.request.contextPath}/customer/orders/cancel">
        <input type="hidden" name="id" value="${order.donHangId}">
        <button type="submit" class="btn btn-outline-danger rounded-pill"
                onclick="return confirm('Bạn chắc chắn muốn hủy đơn này?')">
          <i class="bi bi-x-circle me-1"></i>Hủy đơn hàng
        </button>
      </form>
    </c:if>

    <a href="${pageContext.request.contextPath}/customer/complaints/submit?donHangId=${order.donHangId}"
       class="btn btn-outline-secondary rounded-pill">
      <i class="bi bi-chat me-1"></i>Khiếu nại
    </a>
  </div>
</div>
</div>
<jsp:include page="/WEB-INF/views/common/footer.jsp"/>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
