<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c"   uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"  %>
<!DOCTYPE html><html lang="vi"><head>
<meta charset="UTF-8"><meta name="viewport" content="width=device-width,initial-scale=1">
<title>Xem Trade-in (Lịch sử mua hàng) - PolyPhone</title>
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css">
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.css">
</head><body><div class="d-flex">
<jsp:include page="/WEB-INF/views/admin/sidebar.jsp"/>
<div class="flex-grow-1 p-4" style="background:#f8f9fa;min-height:100vh">
  <h4 class="fw-bold mb-2">Xem Trade-in tổng hợp</h4>
  <p class="text-muted mb-4">Danh sách các đơn hàng đã hoàn thành — khách hàng có thể trade-in thiết bị từ đây.</p>
  <div class="card border-0 shadow-sm">
    <div class="card-body p-0">
      <table class="table table-hover mb-0 align-middle">
        <thead class="table-light">
          <tr><th>#Đơn</th><th>Khách hàng</th><th>Sản phẩm đã mua</th><th>Tổng tiền</th><th>Ngày hoàn thành</th><th></th></tr>
        </thead>
        <tbody>
          <c:forEach var="o" items="${tradeInOrders}">
            <tr>
              <td class="fw-bold">${o.donHangId}</td>
              <td>${o.hoTenKhach}</td>
              <td>
                <c:forEach var="ct" items="${o.chiTietList}" varStatus="st">
                  ${ct.tenSanPham}<c:if test="${!st.last}">, </c:if>
                </c:forEach>
                <c:if test="${empty o.chiTietList}"><span class="text-muted small">—</span></c:if>
              </td>
              <td class="text-danger fw-semibold"><fmt:formatNumber value="${o.thanhTien}" pattern="#,###"/>đ</td>
              <td class="text-muted small">${o.ngayGiaoThucTe}</td>
              <td><a href="${pageContext.request.contextPath}/admin/orders/detail?id=${o.donHangId}" class="btn btn-sm btn-outline-primary rounded-pill">Xem đơn</a></td>
            </tr>
          </c:forEach>
          <c:if test="${empty tradeInOrders}">
            <tr><td colspan="6" class="text-center text-muted py-4"><i class="bi bi-inbox display-6"></i><br>Chưa có đơn hàng hoàn thành</td></tr>
          </c:if>
        </tbody>
      </table>
    </div>
  </div>
</div></div>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
</body></html>
