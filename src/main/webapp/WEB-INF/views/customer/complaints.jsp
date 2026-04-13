<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c"   uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"  %>
<!DOCTYPE html>
<html lang="vi">
<head>
  <meta charset="UTF-8"><meta name="viewport" content="width=device-width, initial-scale=1">
  <title>Khiếu Nại - PolyPhone</title>
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
  <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.0/font/bootstrap-icons.css" rel="stylesheet">
</head>
<body>
<!--Start of Tawk.to Script-->
<jsp:include page="/WEB-INF/views/common/crisp-chat.jsp"/>


<jsp:include page="/WEB-INF/views/common/header.jsp"/>
<div class="page-content">
<div class="container py-4" style="max-width:800px;">
  <h3 class="fw-bold mb-4"><i class="bi bi-chat-square-text me-2"></i>Khiếu nại</h3>
  <c:if test="${param.success == '1'}">
    <div class="alert alert-success">Gửi khiếu nại thành công!</div>
  </c:if>

  <!-- Submit Form -->
  <div class="card border-0 shadow-sm rounded-3 mb-4">
    <div class="card-body p-4">
      <h6 class="fw-bold mb-3">Gửi khiếu nại mới</h6>
      <form method="post" action="${pageContext.request.contextPath}/customer/complaints/submit">
        <div class="mb-3">
          <label class="form-label">Mã đơn hàng (nếu có)</label>
          <input type="number" class="form-control" name="donHangId" placeholder="Để trống nếu không liên quan đến đơn hàng">
        </div>
        <div class="mb-3">
          <label class="form-label">Tiêu đề <span class="text-danger">*</span></label>
          <input type="text" class="form-control" name="tieuDe" required placeholder="Tóm tắt vấn đề của bạn">
        </div>
        <div class="mb-3">
          <label class="form-label">Nội dung <span class="text-danger">*</span></label>
          <textarea class="form-control" name="noiDung" rows="4" required placeholder="Mô tả chi tiết vấn đề..."></textarea>
        </div>
        <button type="submit" class="btn btn-danger rounded-pill px-4">
          <i class="bi bi-send me-1"></i>Gửi khiếu nại
        </button>
      </form>
    </div>
  </div>

  <!-- History -->
  <h5 class="fw-bold mb-3">Lịch sử khiếu nại</h5>
  <c:choose>
    <c:when test="${empty complaints}">
      <p class="text-muted">Chưa có khiếu nại nào.</p>
    </c:when>
    <c:otherwise>
      <c:forEach var="kn" items="${complaints}">
        <div class="card border-0 shadow-sm rounded-3 mb-3">
          <div class="card-body p-4">
            <div class="d-flex justify-content-between align-items-start mb-2">
              <h6 class="fw-semibold mb-0">${kn.tieuDe}</h6>
              <span class="badge rounded-pill ${kn.trangThai == 'da_xu_ly' ? 'bg-success' :
                kn.trangThai == 'dang_xu_ly' ? 'bg-warning text-dark' : 'bg-secondary'}">
                ${kn.trangThaiLabel}
              </span>
            </div>
            <p class="text-muted small mb-2">${kn.noiDung}</p>
            <c:if test="${not empty kn.phanHoi}">
              <div class="bg-light rounded-2 p-3 mt-2">
                <strong class="small text-danger">Phản hồi từ PolyPhone:</strong>
                <p class="mb-0 small mt-1">${kn.phanHoi}</p>
              </div>
            </c:if>
            <div class="text-muted small mt-2">
              ${kn.ngayTaoStr}
            </div>
          </div>
        </div>
      </c:forEach>
    </c:otherwise>
  </c:choose>
</div>
</div>
<jsp:include page="/WEB-INF/views/common/footer.jsp"/>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
