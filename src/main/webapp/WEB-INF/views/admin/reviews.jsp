<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c"   uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html><html lang="vi"><head>
<meta charset="UTF-8"><meta name="viewport" content="width=device-width,initial-scale=1">
<title>Quản lý đánh giá - PolyPhone</title>
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css">
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.css">
</head><body><div class="d-flex">
<jsp:include page="/WEB-INF/views/admin/sidebar.jsp"/>
<div class="flex-grow-1 p-4" style="background:#f8f9fa;min-height:100vh">
  <h4 class="fw-bold mb-4">Quản lý đánh giá</h4>
  <div class="card border-0 shadow-sm">
    <div class="card-body p-0">
      <table class="table table-hover mb-0 align-middle">
        <thead class="table-light"><tr><th>#</th><th>Người dùng</th><th>Sản phẩm ID</th><th>Sao</th><th>Nội dung</th><th>Trạng thái</th><th>Thao tác</th></tr></thead>
        <tbody>
          <c:forEach var="dg" items="${reviews}">
            <tr>
              <td>${dg.danhGiaId}</td>
              <td class="fw-semibold">${dg.hoTenNguoiDung}</td>
              <td>SP #${dg.sanPhamId}</td>
              <td>
                <c:forEach begin="1" end="${dg.soSao}" var="i"><i class="bi bi-star-fill text-warning"></i></c:forEach>
                <c:forEach begin="${dg.soSao+1}" end="5" var="i"><i class="bi bi-star text-muted"></i></c:forEach>
              </td>
              <td class="text-truncate" style="max-width:200px">${dg.nhanXet}</td>
              <td><span class="badge ${dg.dangHien?'bg-success':'bg-secondary'}">${dg.dangHien?'Hiển thị':'Đã ẩn'}</span></td>
              <td>
                <c:choose>
                  <c:when test="${dg.dangHien}">
                    <button class="btn btn-sm btn-outline-warning rounded-pill" data-bs-toggle="modal" data-bs-target="#hideModal${dg.danhGiaId}">Ẩn</button>
                    <div class="modal fade" id="hideModal${dg.danhGiaId}" tabindex="-1">
                      <div class="modal-dialog"><div class="modal-content">
                        <div class="modal-header"><h5 class="modal-title">Ẩn đánh giá</h5><button type="button" class="btn-close" data-bs-dismiss="modal"></button></div>
                        <form method="post" action="${pageContext.request.contextPath}/admin/reviews/toggle">
                          <div class="modal-body">
                            <input type="hidden" name="id" value="${dg.danhGiaId}">
                            <input type="hidden" name="action" value="hide">
                            <div><label class="form-label">Lý do ẩn</label>
                              <textarea class="form-control" name="lyDoAn" rows="3" placeholder="Nhập lý do ẩn đánh giá này..."></textarea></div>
                          </div>
                          <div class="modal-footer"><button class="btn btn-warning">Xác nhận ẩn</button></div>
                        </form>
                      </div></div>
                    </div>
                  </c:when>
                  <c:otherwise>
                    <form method="post" action="${pageContext.request.contextPath}/admin/reviews/toggle" class="d-inline">
                      <input type="hidden" name="id" value="${dg.danhGiaId}">
                      <input type="hidden" name="action" value="show">
                      <button class="btn btn-sm btn-outline-success rounded-pill">Hiện lại</button>
                    </form>
                  </c:otherwise>
                </c:choose>
              </td>
            </tr>
          </c:forEach>
        </tbody>
      </table>
    </div>
  </div>
</div></div>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
</body></html>
