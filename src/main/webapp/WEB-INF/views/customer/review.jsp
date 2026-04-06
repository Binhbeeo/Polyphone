<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c"   uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
  <meta charset="UTF-8"><meta name="viewport" content="width=device-width,initial-scale=1">
  <title>Đánh giá sản phẩm - PolyPhone</title>
  <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css">
  <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.css">
  <style>
    .star-rating input { display:none; }
    .star-rating label { font-size:2rem; color:#ccc; cursor:pointer; }
    .star-rating input:checked ~ label,
    .star-rating label:hover,
    .star-rating label:hover ~ label { color:#ffc107; }
    .star-rating { display:flex; flex-direction:row-reverse; justify-content:flex-end; }
  </style>
</head>
<body class="bg-light">
<jsp:include page="/WEB-INF/views/common/header.jsp"/>
<div class="page-content">
<div class="container py-4" style="max-width:600px">
  <a href="${pageContext.request.contextPath}/customer/orders/detail?id=${param.donHangId}" class="btn btn-link text-danger ps-0 mb-3">
    <i class="bi bi-arrow-left me-1"></i>Quay lại đơn hàng
  </a>
  <div class="card border-0 shadow-sm">
    <div class="card-header bg-white"><h5 class="fw-bold mb-0"><i class="bi bi-star me-2 text-warning"></i>Đánh giá sản phẩm</h5></div>
    <div class="card-body">
      <form method="post" action="${pageContext.request.contextPath}/customer/orders/review">
        <input type="hidden" name="donHangId" value="${param.donHangId}">
        <input type="hidden" name="sanPhamId" value="${param.sanPhamId}">
        <div class="mb-4 text-center">
          <p class="text-muted mb-2">Bạn đánh giá sản phẩm này như thế nào?</p>
          <div class="star-rating justify-content-center">
            <input type="radio" id="s5" name="soSao" value="5"><label for="s5"><i class="bi bi-star-fill"></i></label>
            <input type="radio" id="s4" name="soSao" value="4"><label for="s4"><i class="bi bi-star-fill"></i></label>
            <input type="radio" id="s3" name="soSao" value="3" checked><label for="s3"><i class="bi bi-star-fill"></i></label>
            <input type="radio" id="s2" name="soSao" value="2"><label for="s2"><i class="bi bi-star-fill"></i></label>
            <input type="radio" id="s1" name="soSao" value="1"><label for="s1"><i class="bi bi-star-fill"></i></label>
          </div>
        </div>
        <div class="mb-3">
          <label class="form-label fw-semibold">Nhận xét</label>
          <textarea class="form-control" name="nhanXet" rows="4" placeholder="Chia sẻ trải nghiệm của bạn về sản phẩm..."></textarea>
        </div>
        <button type="submit" class="btn btn-danger w-100 rounded-pill">
          <i class="bi bi-send me-2"></i>Gửi đánh giá
        </button>
      </form>
    </div>
  </div>
</div>
</div>
<jsp:include page="/WEB-INF/views/common/footer.jsp"/>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
</body></html>
