<%@ page contentType="text/html;charset=UTF-8" isErrorPage="true" %>
<!DOCTYPE html><html lang="vi"><head><meta charset="UTF-8"><title>500 - PolyPhone</title>
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css">
</head><body class="bg-light">
<!--Start of Tawk.to Script-->
<jsp:include page="/WEB-INF/views/common/crisp-chat.jsp"/>

<div class="container text-center py-5 mt-5">
  <div class="display-1 text-secondary fw-bold">500</div>
  <h2>Lỗi máy chủ</h2>
  <p class="text-muted">Đã xảy ra lỗi. Vui lòng thử lại sau.</p>
  <a href="${pageContext.request.contextPath}/" class="btn btn-danger rounded-pill px-4 mt-2">Về trang chủ</a>
</div></body></html>
