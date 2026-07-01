<%@ page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Hệ thống Quản trị - MixiVideo</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css" rel="stylesheet">
</head>
<body class="bg-light">

    <nav class="navbar navbar-expand-lg navbar-dark bg-dark px-4 shadow-sm">
        <div class="container-fluid">
            <a class="navbar-brand fw-bold fs-3" href="${pageContext.request.contextPath}/home">
                <span class="text-white">Mixi</span><span class="text-danger">Admin</span>
            </a>
            <div class="d-flex align-items-center ms-auto">
                <span class="text-white me-3">
                    <i class="bi bi-person-workspace text-warning"></i> Chào Quản trị viên, <strong>${sessionScope.currentUser.fullname}</strong>
                </span>
                <a href="${pageContext.request.contextPath}/home" class="btn btn-outline-light btn-sm me-2">
                    <i class="bi bi-house"></i> Xem Trang chủ
                </a>
                <a href="${pageContext.request.contextPath}/logout" class="btn btn-danger btn-sm">
                    <i class="bi bi-box-arrow-right"></i> Đăng xuất
                </a>
            </div>
        </div>
    </nav>

    <div class="container-fluid mt-4 px-4 mb-5">
        <div class="row">
            
            <div class="col-xl-4 col-lg-5 mb-4">
                <div class="card shadow-sm border-0">
                    <div class="card-header bg-secondary text-white fw-bold py-3">
                        <i class="bi bi-pencil-square"></i> THÔNG TIN VIDEO
                    </div>
                    <div class="card-body p-4">
                        
                        <c:if test="${not empty message}">
                            <div class="alert alert-danger alert-dismissible fade show small py-2 shadow-sm mb-3" role="alert">
                                <i class="bi bi-shield-lock-fill"></i> ${message}
                                <button type="button" class="btn-close py-2" data-bs-dismiss="alert" aria-label="Close"></button>
                            </div>
                        </c:if>
                        
                        <form id="videoForm" method="POST" action="${pageContext.request.contextPath}/admin/video/${empty videoForm.id ? 'create' : 'update'}">
                            
                            <div class="mb-3">
                                <label class="form-label fw-semibold small text-muted">Mã Video (Dùng làm ID nhúng YouTube)</label>
                                <input type="text" name="id" class="form-control" placeholder="Ví dụ: dQw4w9WgXcQ" 
                                       value="${videoForm.id}" ${not empty videoForm.id ? 'readonly bg-light' : 'required'}>
                                <div class="form-text text-info small" style="font-size: 11px;">
                                    * Mẹo: Nên lấy mã ID sau chữ <code>v=</code> trên link YouTube để video chạy được.
                                </div>
                            </div>

                            <div class="mb-3">
                                <label class="form-label fw-semibold small text-muted">Tiêu đề Video</label>
                                <input type="text" name="title" class="form-control" placeholder="Nhập tiêu đề video..." 
                                       value="${videoForm.title}" required>
                            </div>

                            <div class="mb-3">
                                <label class="form-label fw-semibold small text-muted">Đường dẫn hình ảnh (Poster URL)</label>
                                <input type="text" name="poster" class="form-control" placeholder="Ví dụ: poster1.png hoặc link ảnh online" 
                                       value="${videoForm.poster}">
                            </div>

                            <div class="mb-3">
                                <label class="form-label fw-semibold small text-muted">Số lượt xem (Views)</label>
                                <input type="number" name="views" class="form-control" min="0" 
                                       value="${empty videoForm.views ? 0 : videoForm.views}">
                            </div>

                            <div class="mb-3 form-check form-switch mt-4">
                                <input class="form-check-input" type="checkbox" name="active" id="activeSwitch" 
                                       value="true" ${videoForm.active != false ? 'checked' : ''}>
                                <label class="form-check-label fw-semibold text-muted small" for="activeSwitch">Hiển thị ngoài trang chủ (Active)</label>
                            </div>

                            <div class="mb-4">
                                <label class="form-label fw-semibold small text-muted">Mô tả video</label>
                                <textarea name="description" class="form-control" rows="3" placeholder="Nhập tóm tắt nội dung video...">${videoForm.description}</textarea>
                            </div>

                            <div class="row g-2 pt-2 border-top">
                                <div class="col-6">
                                    <button type="submit" formaction="${pageContext.request.contextPath}/admin/video/create" class="btn btn-primary w-100 fw-bold shadow-sm" ${not empty videoForm.id ? 'disabled' : ''}>
                                        <i class="bi bi-plus-circle"></i> Create
                                    </button>
                                </div>
                                <div class="col-6">
                                    <button type="submit" formaction="${pageContext.request.contextPath}/admin/video/update" class="btn btn-warning w-100 fw-bold shadow-sm text-white" ${empty videoForm.id ? 'disabled' : ''}>
                                        <i class="bi bi-arrow-clockwise"></i> Update
                                    </button>
                                </div>
                                <div class="col-6">
                                    <button type="submit" formaction="${pageContext.request.contextPath}/admin/video/delete" class="btn btn-danger w-100 fw-bold shadow-sm" ${empty videoForm.id ? 'disabled' : ''} onclick="return confirm('Bạn có chắc chắn muốn xóa video này?')">
                                        <i class="bi bi-trash"></i> Delete
                                    </button>
                                </div>
                                <div class="col-6">
                                    <a href="${pageContext.request.contextPath}/admin" class="btn btn-success w-100 fw-bold shadow-sm">
                                        <i class="bi bi-arrow-counterclockwise"></i> Reset
                                    </a>
                                </div>
                            </div>

                        </form>
                    </div>
                </div>
            </div>

            <div class="col-xl-8 col-lg-7 mb-4">
                <div class="card shadow-sm border-0 h-100">
                    <div class="card-header bg-dark text-white fw-bold py-3 d-flex justify-content-between align-items-center">
                        <span><i class="bi bi-collection-play"></i> DANH SÁCH VIDEO HỆ THỐNG</span>
                        <span class="badge bg-danger">${empty videos ? 0 : videos.size()} Videos</span>
                    </div>
                    <div class="card-body p-0 table-responsive">
                        
                        <table class="table table-hover align-middle mb-0 text-nowrap">
                            <thead class="table-light">
                                <tr>
                                    <th class="ps-3">Mã Video</th>
                                    <th>Hình ảnh</th>
                                    <th>Tiêu đề video</th>
                                    <th>Lượt xem</th>
                                    <th>Trạng thái</th>
                                    <th class="text-center pe-3">Hành động</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:choose>
                                    <c:when test="${empty videos}">
                                        <tr>
                                            <td colspan="6" class="text-center text-muted py-5">
                                                <i class="bi bi-inbox display-4 d-block mb-2"></i> Chưa có dữ liệu video nào thuộc quyền quản lý của bạn.
                                            </td>
                                        </tr>
                                    </c:when>
                                    <c:otherwise>
                                        <c:forEach var="v" items="${videos}">
                                            <tr>
                                                <td class="ps-3 fw-bold text-secondary">${v.id}</td>
                                                <td>
                                                    <c:choose>
                                                        <c:when test="${not empty v.poster && v.poster.startsWith('http')}">
                                                            <img src="${v.poster}" alt="Poster" class="rounded border" style="width: 70px; height: 40px; object-fit: cover;" onerror="this.src='https://placehold.co/70x40?text=No+Image'">
                                                        </c:when>
                                                        <c:otherwise>
                                                            <img src="${pageContext.request.contextPath}/images/${v.poster}" alt="Poster" class="rounded border" style="width: 70px; height: 40px; object-fit: cover;" onerror="this.src='https://placehold.co/70x40?text=Fix+Path'">
                                                        </c:otherwise>
                                                    </c:choose>
                                                </td>
                                                <td class="fw-semibold text-dark text-truncate" style="max-width: 220px;" title="${v.title}">
                                                    ${v.title}
                                                </td>
                                                <td><i class="bi bi-eye text-muted"></i> ${v.views}</td>
                                                <td>
                                                    <c:choose>
                                                        <c:when test="${v.active}">
                                                            <span class="badge bg-success-subtle text-success border border-success-subtle px-2 py-1 rounded-pill">Active</span>
                                                        </c:when>
                                                        <c:otherwise>
                                                            <span class="badge bg-danger-subtle text-danger border border-danger-subtle px-2 py-1 rounded-pill">Inactive</span>
                                                        </c:otherwise>
                                                    </c:choose>
                                                </td>
                                                <td class="text-center pe-3">
                                                    <a href="${pageContext.request.contextPath}/admin/video/edit?id=${v.id}" class="btn btn-outline-primary btn-sm px-3 rounded-pill">
                                                        <i class="bi bi-pencil"></i> Edit
                                                    </a>
                                                </td>
                                            </tr>
                                        </c:forEach>
                                    </c:otherwise>
                                </c:choose>
                            </tbody>
                        </table>
                        
                    </div>

                    <div class="card-footer bg-white py-3 border-top d-flex justify-content-center">
                        <nav aria-label="Page navigation">
                            <ul class="pagination pagination-sm mb-0">
                                <li class="page-item"><a class="page-item btn btn-outline-secondary btn-sm mx-1 fw-bold" href="?page=1">|&lt;&lt;</a></li>
                                <li class="page-item"><a class="page-item btn btn-outline-secondary btn-sm mx-1 fw-bold" href="?page=prev">&lt;&lt;</a></li>
                                <li class="page-item"><a class="page-item btn btn-outline-secondary btn-sm mx-1 fw-bold" href="?page=next">&gt;&gt;</a></li>
                                <li class="page-item"><a class="page-item btn btn-outline-secondary btn-sm mx-1 fw-bold" href="?page=max">&gt;&gt;|</a></li>
                            </ul>
                        </nav>
                    </div>

                </div>
            </div>

        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>