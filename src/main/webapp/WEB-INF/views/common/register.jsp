<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c"   uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
  <meta charset="UTF-8"><meta name="viewport" content="width=device-width, initial-scale=1">
  <title>Đăng Ký - PolyPhone</title>
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
  <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.0/font/bootstrap-icons.css" rel="stylesheet">
</head>
<body class="bg-light">


<!--Start of Tawk.to Script-->
<script type="text/javascript">
    var Tawk_API=Tawk_API||{}, Tawk_LoadStart=new Date();
    (function(){
        var s1=document.createElement("script"),s0=document.getElementsByTagName("script")[0];
        s1.async=true;
        s1.src='https://embed.tawk.to/69d10432e360ca1c3ce3010d/1jlc7gpeb';
        s1.charset='UTF-8';
        s1.setAttribute('crossorigin','*');
        s0.parentNode.insertBefore(s1,s0);
    })();
</script>
<!--End of Tawk.to Script-->

<div class="min-vh-100 d-flex align-items-center py-4">
  <div class="container">
    <div class="row justify-content-center">
      <div class="col-md-6">
        <div class="card shadow-lg border-0 rounded-4">
          <div class="card-body p-5">
            <div class="text-center mb-4">
              <h2 class="fw-bold text-danger"><i class="bi bi-phone-fill"></i> PolyPhone</h2>
              <p class="text-muted">Tạo tài khoản mới</p>
            </div>
            <c:if test="${not empty error}">
              <div class="alert alert-danger py-2">${error}</div>
            </c:if>
            <%-- Nút đăng nhập / đăng ký Google --%>
            <a href="${pageContext.request.contextPath}/auth/google"
               style="background:#fff;border:1.5px solid #ddd;color:#333;font-weight:600;display:flex;align-items:center;justify-content:center;gap:10px;padding:10px 0;border-radius:50px;width:100%;text-decoration:none;font-size:15px;margin-bottom:6px;">
              <img src="https://www.gstatic.com/firebasejs/ui/2.0.0/images/auth/google.svg" style="width:22px;height:22px;" alt="G">
              Đăng ký / đăng nhập với Google
            </a>
            <div style="text-align:center;margin:14px 0;position:relative;">
              <hr style="margin:0;"><span style="position:absolute;top:-10px;left:50%;transform:translateX(-50%);background:#fff;padding:0 10px;color:#aaa;font-size:13px;">hoặc đăng ký bằng email</span>
            </div>
            <form method="post" action="${pageContext.request.contextPath}/auth/register" novalidate>
              <div class="mb-3">
                <label class="form-label">Họ và tên <span class="text-danger">*</span></label>
                <input type="text" class="form-control" name="hoTen" required placeholder="Nguyễn Văn A">
              </div>
              <div class="mb-3">
                <label class="form-label">Email <span class="text-danger">*</span></label>
                <input type="email" class="form-control" name="email" required placeholder="example@gmail.com">
              </div>
              <div class="mb-3">
                <label class="form-label">Số điện thoại</label>
                <input type="tel" class="form-control" name="soDienThoai" placeholder="0912345678">
              </div>
              <div class="mb-3">
                <label class="form-label">Mật khẩu <span class="text-danger">*</span></label>
                <input type="password" class="form-control" name="password" required placeholder="Ít nhất 6 ký tự" minlength="6">
              </div>
              <div class="mb-4">
                <label class="form-label">Xác nhận mật khẩu <span class="text-danger">*</span></label>
                <input type="password" class="form-control" name="confirmPassword" required placeholder="Nhập lại mật khẩu">
              </div>
              <button type="submit" class="btn btn-danger w-100 rounded-pill py-2">
                <i class="bi bi-person-plus me-1"></i> Đăng ký
              </button>
            </form>
            <hr>
            <p class="text-center small mb-0">
              Đã có tài khoản?
              <a href="${pageContext.request.contextPath}/auth/login" class="text-danger fw-bold">Đăng nhập</a>
            </p>
          </div>
        </div>
      </div>
    </div>
  </div>
</div>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
