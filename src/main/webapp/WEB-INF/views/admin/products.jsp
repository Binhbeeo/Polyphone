<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c"   uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"  %>
<!DOCTYPE html><html lang="vi"><head>
<meta charset="UTF-8"><meta name="viewport" content="width=device-width,initial-scale=1">
<title>Quản lý sản phẩm - PolyPhone</title>
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css">
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.css">
</head><body><div class="d-flex">
<jsp:include page="/WEB-INF/views/admin/sidebar.jsp"/>
<div class="flex-grow-1 p-4" style="background:#f8f9fa;min-height:100vh">
  <div class="d-flex justify-content-between align-items-center mb-4">
    <h4 class="fw-bold mb-0"><i class="bi bi-phone me-2 text-danger"></i>Quản lý sản phẩm</h4>
    <a href="${pageContext.request.contextPath}/admin/products/add" class="btn btn-danger rounded-pill px-4">
      <i class="bi bi-plus-lg me-1"></i>Thêm sản phẩm
    </a>
  </div>
  <c:if test="${not empty param.success}">
    <div class="alert alert-success">Thao tác thành công!</div>
  </c:if>
  <div class="card border-0 shadow-sm">
    <div class="card-body p-0">
      <table class="table table-hover align-middle mb-0">
        <thead class="table-light"><tr>
          <th style="width:60px">Ảnh</th><th>Tên sản phẩm</th><th>Danh mục</th>
          <th>Giá</th><th>Tồn kho</th><th>Trạng thái</th><th>Thao tác</th>
        </tr></thead>
        <tbody>
          <c:forEach var="sp" items="${products}">
            <tr>
                <td>
                    <c:choose>
                        <c:when test="${not empty sp.anhDaiDien}">
                            <img src="${sp.anhDaiDien}" style="width:50px;height:50px;object-fit:cover;border-radius:8px">
                        </c:when>
                        <c:otherwise>
                            <div class="bg-light rounded d-flex align-items-center justify-content-center" style="width:50px;height:50px">
                                <i class="bi bi-image text-muted"></i>
                            </div>
                        </c:otherwise>
                    </c:choose>
                </td>
              <td class="fw-semibold">${sp.tenSanPham}</td>
              <td><span class="badge bg-light text-dark border">${sp.tenDanhMuc}</span></td>
              <td class="text-danger fw-semibold"><fmt:formatNumber value="${sp.gia}" pattern="#,###"/>đ</td>
              <td><span class="${sp.tonKho == 0 ? 'text-danger' : (sp.tonKho < 5 ? 'text-warning' : 'text-success')} fw-semibold">${sp.tonKho}</span></td>
              <td><span class="badge ${sp.dangBan ? 'bg-success' : 'bg-secondary'}">${sp.dangBan ? 'Đang bán' : 'Ẩn'}</span></td>
              <td>
                <a href="${pageContext.request.contextPath}/admin/products/edit?id=${sp.sanPhamId}" class="btn btn-sm btn-outline-primary rounded-pill me-1"><i class="bi bi-pencil"></i></a>
                <form method="post" action="${pageContext.request.contextPath}/admin/products/delete" class="d-inline"
                      onsubmit="return confirm('Ẩn sản phẩm này?')">
                  <input type="hidden" name="id" value="${sp.sanPhamId}">
                  <button class="btn btn-sm btn-outline-danger rounded-pill"><i class="bi bi-eye-slash"></i></button>
                </form>
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
