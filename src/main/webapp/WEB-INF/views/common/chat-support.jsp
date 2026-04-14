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
        .chat-container {
            height: calc(100vh - 100px);
            border-radius: 15px;
            overflow: hidden;
            box-shadow: 0 4px 20px rgba(0,0,0,0.1);
        }
        iframe {
            width: 100%;
            height: 100%;
            border: none;
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
                <%-- Staff Navbar --%>
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

        <div class="flex-grow-1 p-4">
            <div class="d-flex justify-content-between align-items-center mb-4">
                <h4 class="fw-bold mb-0"><i class="bi bi-chat-dots me-2 text-danger"></i>Hỗ trợ trực tuyến (Crisp Inbox)</h4>
                <a href="https://app.crisp.chat/" target="_blank" class="btn btn-outline-danger btn-sm rounded-pill">
                    <i class="bi bi-box-arrow-up-right me-1"></i>Mở trong tab mới
                </a>
            </div>
            
            <div class="alert alert-info d-flex align-items-center mb-4">
                <i class="bi bi-info-circle-fill me-2 fs-5"></i>
                <div>
                    <strong>Lưu ý:</strong> Bạn cần đăng nhập vào tài khoản Crisp để trả lời khách hàng. Nếu không thấy tin nhắn, hãy nhấn "Mở trong tab mới".
                </div>
            </div>

            <div class="chat-container">
                <iframe src="https://app.crisp.chat/" allow="camera; microphone; clipboard-read; clipboard-write"></iframe>
            </div>
        </div>
        
        <c:if test="${sessionScope.loggedInUser.role != 'admin'}">
            </div> <%-- Close flex-grow-1 for staff --%>
        </c:if>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
