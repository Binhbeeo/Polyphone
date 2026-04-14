<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c"   uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width,initial-scale=1">
    <title>Hồ sơ - PolyPhone Staff</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.css">
    <style>
        body { background-color: #f8f9fa; }
        .main-container { display: flex; min-height: 100vh; }
        .content-area { flex-grow: 1; padding: 2rem; }
        .profile-card { max-width: 600px; margin: 0 auto; }
    </style>
</head>
<body>
    <div class="main-container">
        <jsp:include page="/WEB-INF/views/staff/sidebar-staff.jsp"/>
        
        <div class="content-area">
            <div class="d-flex justify-content-between align-items-center mb-4">
                <h4 class="fw-bold mb-0">Thông tin tài khoản</h4>
                <div class="text-muted small">Nhân viên hệ thống</div>
            </div>

            <div class="card border-0 shadow-sm rounded-4 profile-card">
                <div class="card-body p-4">
                    <div class="text-center mb-4">
                        <div class="bg-danger text-white rounded-circle d-inline-flex align-items-center justify-content-center mb-3" style="width: 80px; height: 80px;">
                            <i class="bi bi-person-fill fs-1"></i>
                        </div>
                        <h5 class="fw-bold mb-0">${user.hoTen}</h5>
                        <p class="text-muted small">Nhân viên</p>
                    </div>
                    
                    <div class="list-group list-group-flush">
                        <div class="list-group-item border-0 px-0 py-3">
                            <div class="row">
                                <div class="col-4 text-muted">Họ tên</div>
                                <div class="col-8 fw-semibold">${user.hoTen}</div>
                            </div>
                        </div>
                        <div class="list-group-item border-0 px-0 py-3">
                            <div class="row">
                                <div class="col-4 text-muted">Email</div>
                                <div class="col-8 fw-semibold">${user.email}</div>
                            </div>
                        </div>
                        <div class="list-group-item border-0 px-0 py-3">
                            <div class="row">
                                <div class="col-4 text-muted">Số điện thoại</div>
                                <div class="col-8 fw-semibold">${user.soDienThoai}</div>
                            </div>
                        </div>
                        <div class="list-group-item border-0 px-0 py-3">
                            <div class="row">
                                <div class="col-4 text-muted">Vai trò</div>
                                <div class="col-8"><span class="badge bg-danger-subtle text-danger rounded-pill px-3">Nhân viên</span></div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
