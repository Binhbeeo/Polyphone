<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c"   uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"  %>
<!DOCTYPE html>
<html lang="vi">
<head>
  <meta charset="UTF-8"><meta name="viewport" content="width=device-width, initial-scale=1">
  <title>Đặt Lại Mật Khẩu - PolyPhone</title>
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

<div class="min-vh-100 d-flex align-items-center">
  <div class="container">
    <div class="row justify-content-center">
      <div class="col-md-5">
        <div class="card shadow-lg border-0 rounded-4">
          <div class="card-body p-5">
            <div class="text-center mb-4">
              <h4 class="fw-bold">Đặt lại mật khẩu</h4>
              <p class="text-muted small">Nhập mật khẩu mới cho tài khoản của bạn</p>
            </div>
            <c:if test="${not empty error}">
              <div class="alert alert-danger py-2">${error}</div>
            </c:if>
            <form method="post" action="${pageContext.request.contextPath}/auth/reset-password">
              <div class="mb-3">
                <label class="form-label">Mật khẩu mới</label>
                <input type="password" class="form-control" name="newPassword" required minlength="6" placeholder="Ít nhất 6 ký tự">
              </div>
              <div class="mb-4">
                <label class="form-label">Xác nhận mật khẩu</label>
                <input type="password" class="form-control" name="confirmPassword" required placeholder="Nhập lại mật khẩu mới">
              </div>
              <button type="submit" class="btn btn-danger w-100 rounded-pill py-2">
                <i class="bi bi-shield-check me-1"></i> Đặt lại mật khẩu
              </button>
            </form>
          </div>
        </div>
      </div>
    </div>
  </div>
</div>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
