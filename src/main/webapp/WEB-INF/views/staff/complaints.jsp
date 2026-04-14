<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c"   uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width,initial-scale=1">
    <title>Khiếu nại - PolyPhone Staff</title>
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
                <h4 class="fw-bold mb-0">Quản lý khiếu nại</h4>
                <div class="text-muted small">Chào, ${sessionScope.loggedInUser.hoTen}</div>
            </div>

            <div class="card border-0 shadow-sm rounded-4 overflow-hidden">
                <div class="card-body p-0">
                    <div class="table-responsive">
                        <table class="table table-hover mb-0 align-middle">
                            <thead class="table-light">
                                <tr>
                                    <th class="ps-4">#</th>
                                    <th>Khách hàng</th>
                                    <th>Tiêu đề</th>
                                    <th>Trạng thái</th>
                                    <th>Ngày gửi</th>
                                    <th class="text-end pe-4">Thao tác</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach var="kn" items="${complaints}">
                                    <tr>
                                        <td class="ps-4">${kn.khieuNaiId}</td>
                                        <td class="fw-semibold">${kn.hoTenKhach}</td>
                                        <td>${kn.tieuDe}</td>
                                        <td>
                                            <span class="badge rounded-pill ${kn.trangThai=='da_xu_ly'?'bg-success':kn.trangThai=='dang_xu_ly'?'bg-warning text-dark':'bg-secondary'}">
                                                ${kn.trangThaiLabel}
                                            </span>
                                        </td>
                                        <td class="text-muted small">${kn.ngayTao}</td>
                                        <td class="text-end pe-4">
                                            <a href="${pageContext.request.contextPath}/staff/complaints/detail?id=${kn.khieuNaiId}" class="btn btn-sm btn-outline-primary rounded-pill px-3">Xử lý</a>
                                        </td>
                                    </tr>
                                </c:forEach>
                                <c:if test="${empty complaints}">
                                    <tr>
                                        <td colspan="6" class="text-center text-muted py-5">Không có khiếu nại nào</td>
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
