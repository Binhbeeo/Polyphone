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
        body, html {
            height: 100%;
            margin: 0;
            background-color: #f4f7f6;
        }
        .main-container {
            display: flex;
            height: 100vh;
            width: 100vw;
        }
        .content-area {
            flex-grow: 1;
            display: flex;
            align-items: center;
            justify-content: center;
            padding: 2rem;
        }
        .support-card {
            background: white;
            border-radius: 24px;
            box-shadow: 0 20px 50px rgba(0,0,0,0.08);
            padding: 3.5rem;
            text-align: center;
            max-width: 650px;
            width: 100%;
            border: 1px solid rgba(0,0,0,0.05);
        }
        .crisp-icon-wrapper {
            width: 100px;
            height: 100px;
            background: #f8f9fa;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            margin: 0 auto 2rem;
        }
        .crisp-logo {
            width: 60px;
        }
        .btn-crisp {
            background-color: #1a73e8;
            color: white;
            border: none;
            padding: 1rem 2.5rem;
            font-size: 1.1rem;
            font-weight: 600;
            border-radius: 50px;
            transition: all 0.3s ease;
            box-shadow: 0 4px 15px rgba(26, 115, 232, 0.3);
        }
        .btn-crisp:hover {
            background-color: #1557b0;
            transform: translateY(-2px);
            box-shadow: 0 6px 20px rgba(26, 115, 232, 0.4);
            color: white;
        }
        .status-badge {
            display: inline-flex;
            align-items: center;
            padding: 0.5rem 1rem;
            background: #e6f4ea;
            color: #1e8e3e;
            border-radius: 50px;
            font-size: 0.9rem;
            font-weight: 500;
            margin-bottom: 1.5rem;
        }
        .status-dot {
            width: 8px;
            height: 8px;
            background: #1e8e3e;
            border-radius: 50%;
            margin-right: 8px;
            animation: pulse 2s infinite;
        }
        @keyframes pulse {
            0% { transform: scale(0.95); box-shadow: 0 0 0 0 rgba(30, 142, 62, 0.7); }
            70% { transform: scale(1); box-shadow: 0 0 0 10px rgba(30, 142, 62, 0); }
            100% { transform: scale(0.95); box-shadow: 0 0 0 0 rgba(30, 142, 62, 0); }
        }
    </style>
</head>
<body>
    <div class="main-container">
        <c:choose>
            <c:when test="${sessionScope.loggedInUser.role == 'admin'}">
                <jsp:include page="/WEB-INF/views/admin/sidebar.jsp"/>
            </c:when>
            <c:otherwise>
                <div class="d-flex flex-column bg-dark text-white" style="width: 250px;">
                    <div class="p-4">
                        <span class="navbar-brand fw-bold fs-5"><i class="bi bi-phone-fill me-2 text-danger"></i>PolyPhone Staff</span>
                    </div>
                    <hr class="m-0 opacity-25">
                    <ul class="nav nav-pills flex-column mb-auto p-3">
                        <li class="nav-item mb-2">
                            <a href="${pageContext.request.contextPath}/staff/orders" class="nav-link text-white py-2 px-3"><i class="bi bi-bag me-2"></i>Đơn hàng</a>
                        </li>
                        <li class="nav-item mb-2">
                            <a href="${pageContext.request.contextPath}/staff/complaints" class="nav-link text-white py-2 px-3"><i class="bi bi-chat-square-text me-2"></i>Khiếu nại</a>
                        </li>
                        <li class="nav-item mb-2">
                            <a href="${pageContext.request.contextPath}/staff/chat" class="nav-link active bg-danger py-2 px-3"><i class="bi bi-chat-dots me-2"></i>Hỗ trợ Chat</a>
                        </li>
                    </ul>
                    <hr class="opacity-25">
                    <div class="p-3">
                        <a href="${pageContext.request.contextPath}/auth/logout" class="btn btn-outline-light btn-sm w-100 rounded-pill">Đăng xuất</a>
                    </div>
                </div>
            </c:otherwise>
        </c:choose>

        <div class="content-area">
            <div class="support-card">
                <div class="status-badge">
                    <span class="status-dot"></span>
                    Hệ thống Crisp đang sẵn sàng
                </div>
                
                <div class="crisp-icon-wrapper">
                    <img src="https://upload.wikimedia.org/wikipedia/commons/d/d1/Crisp_Logo.png" alt="Crisp" class="crisp-logo" onerror="this.src='https://crisp.chat/static/images/logo.png'">
                </div>
                
                <h2 class="fw-bold mb-3">Trung tâm Hỗ trợ Chat</h2>
                <p class="text-muted mb-5 fs-5">
                    Chào <strong>${sessionScope.loggedInUser.hoTen}</strong>, hãy nhấn nút bên dưới để mở cửa sổ quản trị tin nhắn khách hàng.
                </p>
                
                <div class="d-grid gap-3">
                    <button onclick="openCrispDashboard()" class="btn btn-crisp">
                        <i class="bi bi-box-arrow-up-right me-2"></i>Bắt đầu hỗ trợ khách hàng
                    </button>
                    
                    <button onclick="window.$crisp.push(['do', 'chat:open'])" class="btn btn-link text-secondary text-decoration-none mt-2">
                        <i class="bi bi-headset me-2"></i>Mở khung chat hỗ trợ (Local)
                    </button>
                </div>
                
                <div class="mt-5 pt-4 border-top">
                    <p class="small text-muted mb-0">
                        <i class="bi bi-shield-check me-1 text-primary"></i>
                        Thông tin đăng nhập của bạn được bảo mật bởi Crisp. 
                        <br>Nếu cửa sổ không hiện ra, hãy kiểm tra trình chặn Popup của trình duyệt.
                    </p>
                </div>
            </div>
        </div>
    </div>

    <script>
        function openCrispDashboard() {
            const url = 'https://app.crisp.chat/website/c3ea4475-ddb9-4e99-bf52-e8eb8fb1d220/inbox/';
            const width = 1200;
            const height = 800;
            const left = (window.screen.width / 2) - (width / 2);
            const top = (window.screen.height / 2) - (height / 2);
            
            window.open(
                url, 
                'CrispDashboard', 
                `toolbar=no, location=no, directories=no, status=no, menubar=no, scrollbars=yes, resizable=yes, copyhistory=no, width=${width}, height=${height}, top=${top}, left=${left}`
            );
        }
    </script>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
