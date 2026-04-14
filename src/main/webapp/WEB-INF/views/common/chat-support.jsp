<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width,initial-scale=1">
    <title>Hỗ trợ trực tuyến - PolyPhone</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.css">
    <style>
        .support-card {
            border-radius: 20px;
            border: none;
            box-shadow: 0 10px 30px rgba(0,0,0,0.05);
            background: white;
            padding: 3rem;
            text-align: center;
        }
        .crisp-logo {
            width: 100px;
            margin-bottom: 1.5rem;
        }
    </style>
</head>
<body class="bg-light">
    <div class="d-flex">
        <c:choose>
            <c:when test="${sessionScope.loggedInUser.role == 'admin'}">
                <jsp:include page="/WEB-INF/views/admin/sidebar.jsp"/>
            </c:when>
            <c:otherwise>
                <div class="flex-grow-1">
                    <nav class="navbar navbar-dark bg-dark px-4">
                        <span class="navbar-brand fw-bold"><i class="bi bi-phone-fill me-2 text-danger"></i>PolyPhone Staff</span>
                        <div class="d-flex gap-2">
                            <a href="${pageContext.request.contextPath}/staff/orders" class="btn btn-outline-light btn-sm">Đơn hàng</a>
                            <a href="${pageContext.request.contextPath}/staff/complaints" class="btn btn-outline-light btn-sm">Khiếu nại</a>
                            <a href="${pageContext.request.contextPath}/staff/chat" class="btn btn-danger btn-sm rounded-pill">Hỗ trợ Chat</a>
                            <a href="${pageContext.request.contextPath}/auth/logout" class="btn btn-danger btn-sm rounded-pill">Đăng xuất</a>
                        </div>
                    </nav>
            </c:otherwise>
        </c:choose>

        <div class="flex-grow-1 p-5 d-flex align-items-center justify-content-center">
            <div class="support-card w-100" style="max-width: 600px;">
                <img src="https://upload.wikimedia.org/wikipedia/commons/d/d1/Crisp_Logo.png" alt="Crisp" class="crisp-logo" onerror="this.src='https://crisp.chat/static/images/logo.png'">
                <h3 class="fw-bold mb-3">Trung tâm Hỗ trợ Chat</h3>
                <p class="text-muted mb-4">
                    Chào <strong>${sessionScope.loggedInUser.hoTen}</strong>, để trả lời tin nhắn của khách hàng, 
                    vui lòng truy cập vào bảng điều khiển Crisp.
                </p>
                
                <div class="alert alert-warning d-flex align-items-center mb-4 text-start">
                    <i class="bi bi-exclamation-triangle-fill me-3 fs-4"></i>
                    <div>
                        Vì lý do bảo mật, Crisp không cho phép nhúng trực tiếp giao diện quản trị vào website. 
                        Vui lòng nhấn nút bên dưới để mở trang quản trị trong tab mới.
                    </div>
                </div>

                <div class="d-grid gap-2">
                    <a href="https://app.crisp.chat/" target="_blank" class="btn btn-danger btn-lg rounded-pill shadow-sm">
                        <i class="bi bi-box-arrow-up-right me-2"></i>Mở Crisp Dashboard
                    </a>
                    <button onclick="window.$crisp.push(['do', 'chat:open'])" class="btn btn-outline-secondary rounded-pill mt-2">
                        <i class="bi bi-chat-dots me-2"></i>Mở khung chat hỗ trợ (Local)
                    </button>
                </div>
                
                <p class="mt-4 small text-muted">
                    <i class="bi bi-info-circle me-1"></i>
                    Đừng quên đăng nhập bằng tài khoản đại lý của bạn trên Crisp.
                </p>
            </div>
        </div>
        
        <c:if test="${sessionScope.loggedInUser.role != 'admin'}">
            </div>
        </c:if>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
