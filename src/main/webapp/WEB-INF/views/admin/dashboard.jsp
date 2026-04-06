<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c"   uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"  %>
<!DOCTYPE html><html lang="vi">
<head>
  <meta charset="UTF-8"><meta name="viewport" content="width=device-width,initial-scale=1">
  <title>Admin Dashboard - PolyPhone</title>
  <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css">
  <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.css">
</head>
<body>
<div class="d-flex">
  <jsp:include page="/WEB-INF/views/admin/sidebar.jsp"/>
  <div class="flex-grow-1 p-4" style="background:#f8f9fa;min-height:100vh">
    <h4 class="fw-bold mb-4">Dashboard</h4>
    <div class="row g-3 mb-4">
      <div class="col-md-3"><div class="card border-0 shadow-sm text-center p-3">
        <div class="display-6 text-danger fw-bold">${totalOrders}</div>
        <div class="text-muted small mt-1"><i class="bi bi-box-seam me-1"></i>Tổng đơn hàng</div>
      </div></div>
      <div class="col-md-3"><div class="card border-0 shadow-sm text-center p-3">
        <div class="display-6 text-primary fw-bold">${totalUsers}</div>
        <div class="text-muted small mt-1"><i class="bi bi-people me-1"></i>Khách hàng</div>
      </div></div>
      <div class="col-md-3"><div class="card border-0 shadow-sm text-center p-3">
        <div class="display-6 text-success fw-bold">${totalProducts}</div>
        <div class="text-muted small mt-1"><i class="bi bi-phone me-1"></i>Sản phẩm</div>
      </div></div>
      <div class="col-md-3"><div class="card border-0 shadow-sm text-center p-3">
        <div class="display-6 text-warning fw-bold">${pendingComplaints}</div>
        <div class="text-muted small mt-1"><i class="bi bi-chat-dots me-1"></i>Khiếu nại chờ</div>
      </div></div>
    </div>

    <div class="card border-0 shadow-sm">
      <div class="card-header bg-white fw-bold d-flex justify-content-between">
        <span>Đơn hàng mới</span>
        <a href="${pageContext.request.contextPath}/admin/orders" class="btn btn-sm btn-outline-danger rounded-pill">Xem tất cả</a>
      </div>
      <div class="card-body p-0">
        <table class="table table-hover mb-0">
          <thead class="table-light"><tr>
            <th>#</th><th>Khách hàng</th><th>Địa chỉ</th><th>Thành tiền</th><th>Ngày đặt</th><th></th>
          </tr></thead>
          <tbody>
            <c:forEach var="o" items="${recentOrders}">
              <tr>
                <td>${o.donHangId}</td>
                <td>${o.hoTenKhach}</td>
                <td class="text-truncate" style="max-width:180px">${o.diaChi}</td>
                <td class="text-danger fw-semibold"><fmt:formatNumber value="${o.thanhTien}" pattern="#,###"/>đ</td>
                <td class="text-muted small">${o.ngayTao}</td>
                <td><a href="${pageContext.request.contextPath}/admin/orders/detail?id=${o.donHangId}" class="btn btn-sm btn-outline-primary rounded-pill">Xem</a></td>
              </tr>
            </c:forEach>
          </tbody>
        </table>
      </div>
    </div>
  </div>
</div>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
</body></html>
