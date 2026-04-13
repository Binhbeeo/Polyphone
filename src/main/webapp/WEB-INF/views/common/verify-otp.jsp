<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c"   uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"  %>
<!DOCTYPE html>
<html lang="vi">
<head>
  <meta charset="UTF-8"><meta name="viewport" content="width=device-width, initial-scale=1">
  <title>Xác Nhận OTP - PolyPhone</title>
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
  <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.0/font/bootstrap-icons.css" rel="stylesheet">
</head>
<body class="bg-light">

<!--Start of Tawk.to Script-->
<jsp:include page="/WEB-INF/views/common/crisp-chat.jsp"/>


<div class="min-vh-100 d-flex align-items-center">
  <div class="container">
    <div class="row justify-content-center">
      <div class="col-md-5">
        <div class="card shadow-lg border-0 rounded-4">
          <div class="card-body p-5 text-center">
            <div class="bg-success bg-opacity-10 rounded-circle d-inline-flex p-3 mb-3">
              <i class="bi bi-envelope-check-fill fs-2 text-success"></i>
            </div>
            <h4 class="fw-bold">Nhập mã OTP</h4>
            <p class="text-muted small">Mã OTP 6 số đã được gửi đến email của bạn. Có hiệu lực trong 5 phút.</p>
            <c:if test="${not empty error}">
              <div class="alert alert-danger py-2">${error}</div>
            </c:if>
            <form method="post" action="${pageContext.request.contextPath}/auth/verify-otp">
              <div class="mb-4">
                <input type="text" class="form-control form-control-lg text-center fw-bold fs-3 letter-spacing"
                       name="otp" maxlength="6" required placeholder="______" autocomplete="one-time-code">
              </div>
              <button type="submit" class="btn btn-danger w-100 rounded-pill py-2">
                <i class="bi bi-check2-circle me-1"></i> Xác nhận
              </button>
            </form>
            <div class="mt-3">
              <a href="${pageContext.request.contextPath}/auth/forgot-password" class="text-muted small">
                Gửi lại mã OTP
              </a>
            </div>
          </div>
        </div>
      </div>
    </div>
  </div>
</div>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
