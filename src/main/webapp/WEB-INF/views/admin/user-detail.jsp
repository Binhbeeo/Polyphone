<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c"   uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"  %>
<%@ taglib prefix="fn"  uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html><html lang="vi"><head>
<meta charset="UTF-8"><meta name="viewport" content="width=device-width,initial-scale=1">
<title>Chi tiết khách hàng - PolyPhone</title>
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css">
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.css">
</head><body><div class="d-flex">
<jsp:include page="/WEB-INF/views/admin/sidebar.jsp"/>
<div class="flex-grow-1 p-4" style="background:#f8f9fa;min-height:100vh">
    <a href="${pageContext.request.contextPath}/admin/users" class="btn btn-link text-danger ps-0 mb-3"><i class="bi bi-arrow-left me-1"></i>Quay lại</a>
    <div class="row g-4">
        <div class="col-md-4">
            <div class="card border-0 shadow-sm">
                <div class="card-body text-center py-4">
                    <div class="rounded-circle bg-danger text-white d-flex align-items-center justify-content-center mx-auto mb-3" style="width:80px;height:80px;font-size:2rem">
                        ${fn:substring(viewUser.hoTen, 0, 1)}
                    </div>
                    <h5 class="fw-bold">${viewUser.hoTen}</h5>
                    <p class="text-muted small mb-1">${viewUser.email}</p>
                    <p class="text-muted small">${viewUser.soDienThoai}</p>
                    <span class="badge bg-warning text-dark fs-6">${viewUser.diemTichLuy} điểm</span>
                </div>
                <div class="card-footer bg-white">
                    <form method="post" action="${pageContext.request.contextPath}/admin/users/points" class="d-flex gap-2">
                        <input type="hidden" name="id" value="${viewUser.userId}">
                        <input class="form-control form-control-sm" name="diem" type="number" value="${viewUser.diemTichLuy}" min="0">
                        <button class="btn btn-sm btn-danger rounded-pill">Cập nhật điểm</button>
                    </form>
                </div>
            </div>
        </div>
        <div class="col-md-8">
            <div class="card border-0 shadow-sm">
                <div class="card-header bg-white fw-bold">Lịch sử đơn hàng</div>
                <div class="card-body p-0">
                    <table class="table table-hover mb-0">
                        <thead class="table-light"><tr><th>#</th><th>Thành tiền</th><th>Trạng thái</th><th>Ngày đặt</th><th></th></tr></thead>
                        <tbody>
                        <c:forEach var="o" items="${orders}">
                            <tr>
                                <td>${o.donHangId}</td>
                                <td class="text-danger fw-semibold"><fmt:formatNumber value="${o.thanhTien}" pattern="#,###"/>đ</td>
                                <td><span class="badge ${o.trangThaiDH=='hoan_thanh'?'bg-success':o.trangThaiDH=='huy'?'bg-secondary':'bg-warning text-dark'}">${o.trangThaiDHLabel}</span></td>
                                <td class="text-muted small">${o.ngayTao}</td>
                                <td><a href="${pageContext.request.contextPath}/admin/orders/detail?id=${o.donHangId}" class="btn btn-sm btn-outline-primary rounded-pill">Xem</a></td>
                            </tr>
                        </c:forEach>
                        <c:if test="${empty orders}"><tr><td colspan="5" class="text-center text-muted py-3">Chưa có đơn hàng</td></tr></c:if>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
    </div>
</div></div>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
</body></html>