<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html><html lang="vi"><head>
<meta charset="UTF-8"><meta name="viewport" content="width=device-width,initial-scale=1">
<title>${empty product ? 'Thêm' : 'Sửa'} sản phẩm - PolyPhone</title>
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css">
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.css">
<style>
    .img-preview { width:80px;height:80px;object-fit:cover;border-radius:10px;border:2px solid #dee2e6; }
    .img-preview-placeholder { width:80px;height:80px;border-radius:10px;border:2px dashed #dee2e6;display:flex;align-items:center;justify-content:center;color:#aaa; }
    .anh-row { display:flex;align-items:center;gap:10px;margin-bottom:10px; }
</style>
</head><body><div class="d-flex">
<jsp:include page="/WEB-INF/views/admin/sidebar.jsp"/>
<div class="flex-grow-1 p-4" style="background:#f8f9fa;min-height:100vh">
    <h4 class="fw-bold mb-4">${empty product ? 'Thêm sản phẩm mới' : 'Chỉnh sửa sản phẩm'}</h4>
    <div class="card border-0 shadow-sm" style="max-width:750px">
        <div class="card-body">
            <form method="post" action="${pageContext.request.contextPath}/admin/products/${empty product ? 'add' : 'edit'}">
                <c:if test="${not empty product}">
                    <input type="hidden" name="sanPhamId" value="${product.sanPhamId}">
                </c:if>
                <div class="row g-3">

                    <div class="col-12">
                        <label class="form-label fw-semibold">Tên sản phẩm <span class="text-danger">*</span></label>
                        <input class="form-control" name="tenSanPham" required value="${product.tenSanPham}" placeholder="VD: Samsung Galaxy S24 Ultra">
                    </div>

                    <div class="col-md-6">
                        <label class="form-label fw-semibold">Danh mục <span class="text-danger">*</span></label>
                        <select class="form-select" name="danhMucId" required>
                            <option value="">-- Chọn danh mục --</option>
                            <c:forEach var="dm" items="${danhMucs}">
                                <option value="${dm.danhMucId}" ${product.danhMucId == dm.danhMucId ? 'selected' : ''}>${dm.tenDanhMuc}</option>
                            </c:forEach>
                        </select>
                    </div>

                    <div class="col-md-6">
                        <label class="form-label fw-semibold">Thương hiệu</label>
                        <select class="form-select" name="thuongHieuId">
                            <option value="">-- Chọn thương hiệu --</option>
                            <c:forEach var="th" items="${thuongHieus}">
                                <option value="${th.thuongHieuId}" ${product.thuongHieuId == th.thuongHieuId ? 'selected' : ''}>${th.tenThuongHieu}</option>
                            </c:forEach>
                        </select>
                    </div>

                    <div class="col-md-6">
                        <label class="form-label fw-semibold">Giá (đ) <span class="text-danger">*</span></label>
                        <input class="form-control" name="gia" type="number" required min="0" value="${product.gia}" placeholder="VD: 25000000">
                    </div>

                    <div class="col-md-6">
                        <label class="form-label fw-semibold">Tồn kho <span class="text-danger">*</span></label>
                        <input class="form-control" name="tonKho" type="number" required min="0" value="${product.tonKho}">
                    </div>

                    <c:if test="${not empty product}">
                        <div class="col-md-6">
                            <label class="form-label fw-semibold">Trạng thái</label>
                            <select class="form-select" name="dangBan">
                                <option value="1" ${product.dangBan ? 'selected' : ''}>Đang bán</option>
                                <option value="0" ${!product.dangBan ? 'selected' : ''}>Ẩn</option>
                            </select>
                        </div>
                    </c:if>

                    <!-- ===== PHẦN ẢNH NHIỀU URL ===== -->
                    <div class="col-12">
                        <label class="form-label fw-semibold">
                            Ảnh sản phẩm
                            <span class="text-muted fw-normal small">(dán Direct Link từ ImgBB, tối đa 5 ảnh)</span>
                        </label>
                        <div id="anhContainer">
                            <%-- Nếu đang sửa: hiển thị các ảnh đã có --%>
                            <c:choose>
                                <c:when test="${not empty product.anhUrls}">
                                    <c:forEach var="url" items="${product.anhUrls}" varStatus="st">
                                        <div class="anh-row" id="anhRow${st.index}">
                                            <c:choose>
                                                <c:when test="${not empty url}">
                                                    <img src="${url}" class="img-preview" id="preview${st.index}"
                                                         onerror="this.style.display='none';document.getElementById('placeholder${st.index}').style.display='flex'">
                                                    <div class="img-preview-placeholder" id="placeholder${st.index}" style="display:none">
                                                        <i class="bi bi-image fs-4"></i>
                                                    </div>
                                                </c:when>
                                                <c:otherwise>
                                                    <div class="img-preview-placeholder" id="placeholder${st.index}">
                                                        <i class="bi bi-image fs-4"></i>
                                                    </div>
                                                </c:otherwise>
                                            </c:choose>
                                            <input type="text" class="form-control" name="anhUrls"
                                                   value="${url}" placeholder="https://i.ibb.co/..."
                                                   oninput="previewImg(this, 'preview${st.index}', 'placeholder${st.index}')">
                                            <button type="button" class="btn btn-outline-danger btn-sm rounded-pill"
                                                    onclick="xoaHang(this)" ${st.index == 0 ? 'style=visibility:hidden' : ''}>
                                                <i class="bi bi-trash"></i>
                                            </button>
                                        </div>
                                    </c:forEach>
                                </c:when>
                                <c:otherwise>
                                    <%-- Thêm mới: 1 ô trống sẵn --%>
                                    <div class="anh-row" id="anhRow0">
                                        <div class="img-preview-placeholder" id="placeholder0"><i class="bi bi-image fs-4"></i></div>
                                        <img src="" class="img-preview" id="preview0" style="display:none"
                                             onerror="this.style.display='none';document.getElementById('placeholder0').style.display='flex'">
                                        <input type="text" class="form-control" name="anhUrls"
                                               placeholder="https://i.ibb.co/..."
                                               oninput="previewImg(this, 'preview0', 'placeholder0')">
                                        <button type="button" class="btn btn-outline-danger btn-sm rounded-pill"
                                                style="visibility:hidden" onclick="xoaHang(this)">
                                            <i class="bi bi-trash"></i>
                                        </button>
                                    </div>
                                </c:otherwise>
                            </c:choose>
                        </div>

                        <button type="button" class="btn btn-outline-secondary btn-sm rounded-pill mt-2"
                                onclick="themHang()" id="btnThemAnh">
                            <i class="bi bi-plus-lg me-1"></i>Thêm ảnh
                        </button>
                    </div>
                    <!-- ============================= -->

                    <div class="col-12">
                        <label class="form-label fw-semibold">Mô tả</label>
                        <textarea class="form-control" name="moTa" rows="4" placeholder="Mô tả chi tiết sản phẩm...">${product.moTa}</textarea>
                    </div>

                    <div class="col-12 d-flex gap-2">
                        <button type="submit" class="btn btn-danger rounded-pill px-4"><i class="bi bi-check-lg me-1"></i>Lưu</button>
                        <a href="${pageContext.request.contextPath}/admin/products" class="btn btn-outline-secondary rounded-pill px-4">Hủy</a>
                    </div>

                </div>
            </form>
        </div>
    </div>
</div></div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
<script>
    let soHang = document.querySelectorAll('.anh-row').length;
    const MAX_ANH = 5;

    function previewImg(input, previewId, placeholderId) {
        const preview     = document.getElementById(previewId);
        const placeholder = document.getElementById(placeholderId);
        const url = input.value.trim();
        if (url) {
            preview.src = url;
            preview.style.display = 'block';
            placeholder.style.display = 'none';
        } else {
            preview.style.display = 'none';
            placeholder.style.display = 'flex';
        }
    }

    function themHang() {
        if (soHang >= MAX_ANH) {
            alert('Tối đa ' + MAX_ANH + ' ảnh!');
            return;
        }
        const idx = soHang;
        const container = document.getElementById('anhContainer');
        const row = document.createElement('div');
        row.className = 'anh-row';
        row.id = 'anhRow' + idx;
        row.innerHTML = `
      <div class="img-preview-placeholder" id="placeholder${idx}"><i class="bi bi-image fs-4"></i></div>
      <img src="" class="img-preview" id="preview${idx}" style="display:none"
           onerror="this.style.display='none';document.getElementById('placeholder${idx}').style.display='flex'">
      <input type="text" class="form-control" name="anhUrls"
             placeholder="https://i.ibb.co/..."
             oninput="previewImg(this,'preview${idx}','placeholder${idx}')">
      <button type="button" class="btn btn-outline-danger btn-sm rounded-pill" onclick="xoaHang(this)">
        <i class="bi bi-trash"></i>
      </button>`;
        container.appendChild(row);
        soHang++;
        if (soHang >= MAX_ANH) document.getElementById('btnThemAnh').disabled = true;
    }

    function xoaHang(btn) {
        const row = btn.closest('.anh-row');
        row.remove();
        soHang--;
        document.getElementById('btnThemAnh').disabled = false;
    }
</script>
</body></html>
