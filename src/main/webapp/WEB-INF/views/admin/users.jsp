<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c"   uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html><html lang="vi"><head>
<meta charset="UTF-8"><meta name="viewport" content="width=device-width,initial-scale=1">
<title>Quản lý khách hàng - PolyPhone</title>
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css">
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.css">
</head><body><div class="d-flex">
<jsp:include page="/WEB-INF/views/admin/sidebar.jsp"/>
<div class="flex-grow-1 p-4" style="background:#f8f9fa;min-height:100vh">
    <h4 class="fw-bold mb-4">Quản lý khách hàng</h4>
    <form class="d-flex mb-3" style="max-width:380px" action="" method="get">
        <input class="form-control me-2 rounded-pill" name="q" value="${param.q}" placeholder="Tìm theo tên, email, SĐT...">
        <button class="btn btn-danger rounded-pill px-3"><i class="bi bi-search"></i></button>
    </form>
    <div class="card border-0 shadow-sm">
        <div class="card-body p-0">
            <table class="table table-hover mb-0 align-middle">
                <thead class="table-light">
                <tr>
                    <th>#</th>
                    <th>Họ tên</th>
                    <th>Email</th>
                    <th>SĐT</th>
                    <th>Điểm</th>
                    <th>Trạng thái</th>
                    <th>Thao tác</th>
                </tr>
                </thead>
                <tbody>
                <c:forEach var="u" items="${users}">
                    <tr>
                        <td>${u.userId}</td>
                        <td class="fw-semibold">${u.hoTen}</td>
                        <td class="text-muted small">${u.email}</td>
                        <td class="text-muted small">${u.soDienThoai}</td>
                        <td><span class="badge bg-warning text-dark">${u.diemTichLuy} đ</span></td>
                        <td>
                            <c:choose>
                                <c:when test="${u.trongBlacklist}">
                                    <span class="badge bg-dark">Blacklist</span>
                                </c:when>
                                <c:when test="${!u.dangHoatDong}">
                                    <span class="badge bg-danger">Bị khóa</span>
                                </c:when>
                                <c:otherwise>
                                    <span class="badge bg-success">Hoạt động</span>
                                </c:otherwise>
                            </c:choose>
                        </td>
                        <td>
                            <div class="d-flex gap-1 flex-wrap">
                                <a href="${pageContext.request.contextPath}/admin/users/detail?id=${u.userId}"
                                   class="btn btn-sm btn-outline-primary rounded-pill">Chi tiết</a>

                                <form method="post" action="${pageContext.request.contextPath}/admin/users/toggle">
                                    <input type="hidden" name="id" value="${u.userId}">
                                    <input type="hidden" name="active" value="${u.dangHoatDong ? '0' : '1'}">
                                    <button class="btn btn-sm ${u.dangHoatDong ? 'btn-outline-warning' : 'btn-outline-success'} rounded-pill">
                                            ${u.dangHoatDong ? 'Khóa' : 'Mở khóa'}
                                    </button>
                                </form>

                                <form method="post" action="${pageContext.request.contextPath}/admin/users/blacklist">
                                    <input type="hidden" name="id" value="${u.userId}">
                                    <input type="hidden" name="blacklist" value="${u.trongBlacklist ? '0' : '1'}">
                                    <button class="btn btn-sm ${u.trongBlacklist ? 'btn-outline-success' : 'btn-outline-dark'} rounded-pill">
                                            ${u.trongBlacklist ? 'Gỡ BL' : 'Blacklist'}
                                    </button>
                                </form>
                            </div>
                        </td>
                    </tr>
                </c:forEach>
                <c:if test="${empty users}">
                    <tr>
                        <td colspan="7" class="text-center text-muted py-4">Không tìm thấy khách hàng nào</td>
                    </tr>
                </c:if>
                </tbody>
            </table>
        </div>
    </div>
</div></div>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
</body></html>
