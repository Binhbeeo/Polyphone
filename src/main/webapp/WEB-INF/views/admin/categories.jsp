<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c"   uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html><html lang="vi"><head>
<meta charset="UTF-8"><meta name="viewport" content="width=device-width,initial-scale=1">
<title>Quản lý danh mục - PolyPhone</title>
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css">
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.css">
</head><body><div class="d-flex">
<jsp:include page="/WEB-INF/views/admin/sidebar.jsp"/>
<div class="flex-grow-1 p-4" style="background:#f8f9fa;min-height:100vh">
  <h4 class="fw-bold mb-4">Quản lý danh mục</h4>
  <div class="row g-4">
    <div class="col-md-4">
      <div class="card border-0 shadow-sm">
        <div class="card-header bg-white fw-bold">Thêm danh mục mới</div>
        <div class="card-body">
          <form method="post" action="${pageContext.request.contextPath}/admin/categories/add">
            <div class="mb-3"><label class="form-label">Tên danh mục <span class="text-danger">*</span></label>
              <input class="form-control" name="tenDanhMuc" required placeholder="VD: Điện thoại mới"></div>
            <div class="mb-3"><label class="form-label">Mô tả</label>
              <textarea class="form-control" name="moTa" rows="3"></textarea></div>
            <button class="btn btn-danger w-100 rounded-pill">Thêm</button>
          </form>
        </div>
      </div>
    </div>
    <div class="col-md-8">
      <div class="card border-0 shadow-sm">
        <div class="card-body p-0">
          <table class="table table-hover mb-0">
            <thead class="table-light"><tr><th>#</th><th>Tên danh mục</th><th>Mô tả</th><th>Trạng thái</th><th>Thao tác</th></tr></thead>
            <tbody>
              <c:forEach var="dm" items="${categories}">
                <tr>
                  <td>${dm.danhMucId}</td><td class="fw-semibold">${dm.tenDanhMuc}</td>
                  <td class="text-muted small">${dm.moTa}</td>
                  <td><span class="badge ${dm.dangHien ? 'bg-success' : 'bg-secondary'}">${dm.dangHien ? 'Hiện' : 'Ẩn'}</span></td>
                  <td>
                    <button class="btn btn-sm btn-outline-primary rounded-pill me-1" data-bs-toggle="modal" data-bs-target="#editModal${dm.danhMucId}"><i class="bi bi-pencil"></i></button>
                    <form method="post" action="${pageContext.request.contextPath}/admin/categories/delete" class="d-inline" onsubmit="return confirm('Ẩn danh mục?')">
                      <input type="hidden" name="id" value="${dm.danhMucId}">
                      <button class="btn btn-sm btn-outline-danger rounded-pill"><i class="bi bi-eye-slash"></i></button>
                    </form>
                  </td>
                </tr>
                <div class="modal fade" id="editModal${dm.danhMucId}" tabindex="-1">
                  <div class="modal-dialog"><div class="modal-content">
                    <div class="modal-header"><h5 class="modal-title">Sửa danh mục</h5><button type="button" class="btn-close" data-bs-dismiss="modal"></button></div>
                    <form method="post" action="${pageContext.request.contextPath}/admin/categories/edit">
                      <div class="modal-body">
                        <input type="hidden" name="danhMucId" value="${dm.danhMucId}">
                        <div class="mb-3"><label class="form-label">Tên</label><input class="form-control" name="tenDanhMuc" value="${dm.tenDanhMuc}" required></div>
                        <div class="mb-3"><label class="form-label">Mô tả</label><textarea class="form-control" name="moTa">${dm.moTa}</textarea></div>
                        <div class="mb-3"><label class="form-label">Trạng thái</label>
                          <select class="form-select" name="dangHien">
                            <option value="1" ${dm.dangHien?'selected':''}>Hiện</option>
                            <option value="0" ${!dm.dangHien?'selected':''}>Ẩn</option>
                          </select>
                        </div>
                      </div>
                      <div class="modal-footer"><button class="btn btn-danger">Lưu</button></div>
                    </form>
                  </div></div>
                </div>
              </c:forEach>
            </tbody>
          </table>
        </div>
      </div>
    </div>
  </div>
</div></div>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
</body></html>
