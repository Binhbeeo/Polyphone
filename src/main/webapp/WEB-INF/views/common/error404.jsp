<%@ page contentType="text/html;charset=UTF-8" isErrorPage="true" %>
<!DOCTYPE html><html lang="vi"><head><meta charset="UTF-8"><title>404 - PolyPhone</title>
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css">
</head><body class="bg-light">
<!--Start of Tawk.to Script-->
<jsp:include page="/WEB-INF/views/common/crisp-chat.jsp"/>

<div class="container text-center py-5 mt-5">
  <div class="display-1 text-danger fw-bold">404</div>
  <h2>Trang không tìm thấy</h2>
  <p class="text-muted">Trang bạn tìm kiếm không tồn tại hoặc đã bị di chuyển.</p>
  <a href="${pageContext.request.contextPath}/" class="btn btn-danger rounded-pill px-4 mt-2">Về trang chủ</a>
</div></body></html>
