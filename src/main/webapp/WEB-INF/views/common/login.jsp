<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c"   uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <title>Đăng Nhập - PolyPhone</title>
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
  <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.0/font/bootstrap-icons.css" rel="stylesheet">
  <style>
    body { background: linear-gradient(135deg, #fff5f5 0%, #fff 60%); }
    .card { border-radius: 20px; }
    .btn-google {
      background: #fff;
      border: 1.5px solid #ddd;
      color: #333;
      font-weight: 600;
      transition: box-shadow .2s, border-color .2s;
      display: flex;
      align-items: center;
      justify-content: center;
      gap: 10px;
      padding: 10px 0;
      border-radius: 50px;
      width: 100%;
      cursor: pointer;
      font-size: 15px;
    }
    .btn-google:hover {
      box-shadow: 0 2px 12px rgba(66,133,244,.18);
      border-color: #4285F4;
    }
    .btn-google img { width: 22px; height: 22px; }
    .divider-text {
      position: relative;
      text-align: center;
      margin: 18px 0;
    }
    .divider-text::before, .divider-text::after {
      content: '';
      position: absolute;
      top: 50%;
      width: 42%;
      height: 1px;
      background: #e0e0e0;
    }
    .divider-text::before { left: 0; }
    .divider-text::after  { right: 0; }
    .divider-text span { background: #fff; padding: 0 10px; color: #aaa; font-size: 13px; }
  </style>
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
              <h2 class="fw-bold text-danger"><i class="bi bi-phone-fill"></i> PolyPhone</h2>
              <p class="text-muted">Đăng nhập vào tài khoản</p>
            </div>

            <%-- Alert messages --%>
            <c:if test="${not empty error}">
              <div class="alert alert-danger py-2"><i class="bi bi-exclamation-circle me-1"></i>${error}</div>
            </c:if>
            <c:if test="${not empty success}">
              <div class="alert alert-success py-2"><i class="bi bi-check-circle me-1"></i>${success}</div>
            </c:if>
            <c:if test="${param.error == 'account_locked'}">
              <div class="alert alert-warning py-2"><i class="bi bi-lock me-1"></i>Tài khoản của bạn đã bị khóa.</div>
            </c:if>
            <c:if test="${param.error == 'google_denied'}">
              <div class="alert alert-secondary py-2"><i class="bi bi-x-circle me-1"></i>Bạn đã hủy đăng nhập Google.</div>
            </c:if>

            <%-- Nút đăng nhập Google --%>
            <a href="${pageContext.request.contextPath}/auth/google<c:if test='${not empty param.redirect}'>?redirect=${param.redirect}</c:if>"
               class="btn-google mb-2 text-decoration-none">
              <img src="https://www.gstatic.com/firebasejs/ui/2.0.0/images/auth/google.svg" alt="Google">
              Đăng nhập với Google
            </a>

            <div class="divider-text"><span>hoặc</span></div>

            <%-- Form đăng nhập thường --%>
            <form method="post" action="${pageContext.request.contextPath}/auth/login">
              <input type="hidden" name="redirect" value="${param.redirect}">
              <div class="mb-3">
                <label class="form-label">Email hoặc Số điện thoại</label>
                <div class="input-group">
                  <span class="input-group-text"><i class="bi bi-person"></i></span>
                  <input type="text" class="form-control" name="loginInput" required
                         placeholder="Email hoặc SĐT" value="${param.loginInput}">
                </div>
              </div>
              <div class="mb-3">
                <label class="form-label">Mật khẩu</label>
                <div class="input-group">
                  <span class="input-group-text"><i class="bi bi-lock"></i></span>
                  <input type="password" class="form-control" name="password" required placeholder="Mật khẩu"
                         id="passwordInput">
                  <button class="btn btn-outline-secondary" type="button"
                          onclick="togglePw()"><i class="bi bi-eye" id="eyeIcon"></i></button>
                </div>
              </div>
              <div class="d-flex justify-content-between align-items-center mb-4">
                <div class="form-check">
                  <input class="form-check-input" type="checkbox" id="remember">
                  <label class="form-check-label small" for="remember">Ghi nhớ đăng nhập</label>
                </div>
                <a href="${pageContext.request.contextPath}/auth/forgot-password" class="small text-danger">Quên mật khẩu?</a>
              </div>
              <button type="submit" class="btn btn-danger w-100 rounded-pill py-2">
                <i class="bi bi-box-arrow-in-right me-1"></i> Đăng nhập
              </button>
            </form>

            <hr class="my-3">
            <p class="text-center small mb-0">
              Chưa có tài khoản?
              <a href="${pageContext.request.contextPath}/auth/register" class="text-danger fw-bold">Đăng ký ngay</a>
            </p>

          </div>
        </div>
      </div>
    </div>
  </div>
</div>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
<script>
  function togglePw() {
    const input = document.getElementById('passwordInput');
    const icon  = document.getElementById('eyeIcon');
    if (input.type === 'password') {
      input.type = 'text';
      icon.classList.replace('bi-eye', 'bi-eye-slash');
    } else {
      input.type = 'password';
      icon.classList.replace('bi-eye-slash', 'bi-eye');
    }
  }
</script>
</body>
</html>
