<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c"   uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"  %>
<!DOCTYPE html><html lang="vi"><head>
<meta charset="UTF-8"><meta name="viewport" content="width=device-width,initial-scale=1">
<title>Quản lý voucher - PolyPhone</title>
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css">
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.css">
</head><body><div class="d-flex">
<jsp:include page="/WEB-INF/views/admin/sidebar.jsp"/>
<div class="flex-grow-1 p-4" style="background:#f8f9fa;min-height:100vh">
  <div class="d-flex justify-content-between align-items-center mb-4">
    <h4 class="fw-bold mb-0">Quản lý Voucher</h4>
    <a href="${pageContext.request.contextPath}/admin/vouchers/add" class="btn btn-danger rounded-pill px-4"><i class="bi bi-plus-lg me-1"></i>Tạo voucher</a>
  </div>
  <div class="card border-0 shadow-sm">
    <div class="card-body p-0">
      <table class="table table-hover mb-0 align-middle">
        <thead class="table-light"><tr><th>Mã</th><th>Loại</th><th>Giá trị</th><th>Đơn tối thiểu</th><th>Đã dùng/Tối đa</th><th>Hết hạn</th><th>Trạng thái</th><th></th></tr></thead>
        <tbody>
          <c:forEach var="v" items="${vouchers}">
            <tr>
              <td><span class="badge bg-danger fs-6 font-monospace">${v.maVoucher}</span></td>
              <td>${v.loaiGiam == 'phan_tram' ? 'Phần trăm' : 'Cố định'}</td>
                <td class="fw-semibold">
                    <c:choose>
                        <c:when test="${v.loaiGiam == 'phan_tram'}">${v.giaTriGiam}%</c:when>
                        <c:otherwise><fmt:formatNumber value="${v.giaTriGiam}" pattern="#,###"/>đ</c:otherwise>
                    </c:choose>
                </td>
              <td><fmt:formatNumber value="${v.donHangToiThieu}" pattern="#,###"/>đ</td>
              <td>${v.daDung}/${v.soLuotDungToiDa}</td>
              <td class="text-muted small">${v.hetHan}</td>
              <td><span class="badge ${v.dangHoatDong?'bg-success':'bg-secondary'}">${v.dangHoatDong?'Hoạt động':'Tắt'}</span></td>
              <td><a href="${pageContext.request.contextPath}/admin/vouchers/edit?id=${v.voucherId}" class="btn btn-sm btn-outline-primary rounded-pill">Sửa</a></td>
            </tr>
          </c:forEach>
        </tbody>
      </table>
    </div>
  </div>
</div></div>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
</body></html>
