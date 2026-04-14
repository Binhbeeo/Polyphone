<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c"   uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"  %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width,initial-scale=1">
    <title>Đơn hàng - PolyPhone Staff</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.css">
    <style>
        body { background-color: #f8f9fa; }
        .main-container { display: flex; min-height: 100vh; }
        .content-area { flex-grow: 1; padding: 2rem; }
    </style>
</head>
<body>
    <div class="main-container">
        <jsp:include page="/WEB-INF/views/staff/sidebar-staff.jsp"/>
        
        <div class="content-area">
            <div class="d-flex justify-content-between align-items-center mb-4">
                <h4 class="fw-bold mb-0">Quản lý đơn hàng</h4>
                <div class="text-muted small">Chào, ${sessionScope.loggedInUser.hoTen}</div>
            </div>

            <div class="mb-4 d-flex gap-2 flex-wrap">
                <a href="?" class="btn btn-sm ${empty trangThai?'btn-danger':'btn-outline-secondary'} rounded-pill px-3">Tất cả</a>
                <a href="?trangThai=moi" class="btn btn-sm ${trangThai=='moi'?'btn-danger':'btn-outline-secondary'} rounded-pill px-3">Mới</a>
                <a href="?trangThai=xac_nhan" class="btn btn-sm ${trangThai=='xac_nhan'?'btn-danger':'btn-outline-secondary'} rounded-pill px-3">Đã xác nhận</a>
                <a href="?trangThai=dong_goi" class="btn btn-sm ${trangThai=='dong_goi'?'btn-danger':'btn-outline-secondary'} rounded-pill px-3">Đóng gói</a>
                <a href="?trangThai=dang_giao" class="btn btn-sm ${trangThai=='dang_giao'?'btn-danger':'btn-outline-secondary'} rounded-pill px-3">Đang giao</a>
                <a href="?trangThai=hoan_thanh" class="btn btn-sm ${trangThai=='hoan_thanh'?'btn-danger':'btn-outline-secondary'} rounded-pill px-3">Hoàn thành</a>
            </div>

            <div class="card border-0 shadow-sm rounded-4 overflow-hidden">
                <div class="card-body p-0">
                    <div class="table-responsive">
                        <table class="table table-hover mb-0 align-middle">
                            <thead class="table-light">
                                <tr>
                                    <th class="ps-4">#</th>
                                    <th>Khách hàng</th>
                                    <th>Thành tiền</th>
                                    <th>Trạng thái</th>
                                    <th>Ngày đặt</th>
                                    <th class="text-end pe-4">Thao tác</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach var="o" items="${orders}">
                                    <tr>
                                        <td class="ps-4 fw-bold">${o.donHangId}</td>
                                        <td>${o.hoTenKhach}</td>
                                        <td class="text-danger fw-semibold"><fmt:formatNumber value="${o.thanhTien}" pattern="#,###"/>đ</td>
                                        <td>
                                            <span class="badge rounded-pill ${o.trangThaiDH=='hoan_thanh'?'bg-success':o.trangThaiDH=='moi'?'bg-primary':'bg-warning text-dark'}">
                                                ${o.trangThaiDHLabel}
                                            </span>
                                        </td>
                                        <td class="text-muted small">${o.ngayTao}</td>
                                        <td class="text-end pe-4">
                                            <a href="${pageContext.request.contextPath}/staff/orders/detail?id=${o.donHangId}" class="btn btn-sm btn-outline-primary rounded-pill px-3">Chi tiết</a>
                                        </td>
                                    </tr>
                                </c:forEach>
                                <c:if test="${empty orders}">
                                    <tr>
                                        <td colspan="6" class="text-center text-muted py-5">Không có đơn hàng nào</td>
                                    </tr>
                                </c:if>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>
        </div>
    </div>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
