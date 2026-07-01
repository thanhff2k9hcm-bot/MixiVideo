<%@ page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>MixiVideo - Thế giới Video Giải Trí</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css" rel="stylesheet">
</head>
<body class="bg-light">

    <nav class="navbar navbar-expand-lg navbar-dark bg-dark px-4 shadow-sm">
        <div class="container">
            <a class="navbar-brand fw-bold fs-3" href="${pageContext.request.contextPath}/home">
                <span class="text-white">Mixi</span><span class="text-danger">Video</span>
            </a>
            <div class="d-flex align-items-center ms-auto">
                <c:choose>
                    <c:when test="${not empty sessionScope.currentUser}">
                        <span class="text-white me-3"><i class="bi bi-person-circle text-warning"></i> Chào, <strong>${sessionScope.currentUser.fullname}</strong></span>
                        <c:if test="${sessionScope.currentUser.admin}">
                            <a href="${pageContext.request.contextPath}/admin" class="btn btn-warning btn-sm me-2 fw-bold text-dark"><i class="bi bi-speedometer2"></i> Quản trị viên</a>
                        </c:if>
                        <a href="${pageContext.request.contextPath}/logout" class="btn btn-outline-danger btn-sm"><i class="bi bi-box-arrow-right"></i> Đăng xuất</a>
                    </c:when>
                    <c:otherwise>
                        <a href="${pageContext.request.contextPath}/login" class="btn btn-outline-light btn-sm me-2">Đăng nhập</a>
                        <a href="${pageContext.request.contextPath}/registration" class="btn btn-danger btn-sm">Đăng ký</a>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>
    </nav>

    <div class="container mt-4">
        <form action="${pageContext.request.contextPath}/home" method="GET" class="row justify-content-center">
            <div class="col-md-6 d-flex">
                <input type="text" name="keyword" class="form-control me-2 shadow-sm" placeholder="Tìm kiếm video theo tiêu đề..." value="${param.keyword}">
                <button type="submit" class="btn btn-danger px-4 shadow-sm fw-bold"><i class="bi bi-search"></i> Tìm</button>
            </div>
        </form>
    </div>

    <div class="container mt-5 mb-5">
        <h3 class="fw-bold text-dark mb-4"><i class="bi bi-fire text-danger"></i> Tất cả video đề xuất</h3>
        <div class="row row-cols-1 row-cols-md-2 row-cols-lg-3 g-4">
            <c:choose>
                <c:when test="${empty videos}">
                    <div class="col-12 text-center py-5">
                        <i class="bi bi-camera-video-off display-3 text-muted"></i>
                        <p class="text-muted mt-2 fs-5">Không tìm thấy video nào phù hợp!</p>
                    </div>
                </c:when>
                <c:otherwise>
                    <c:forEach var="v" items="${videos}">
                        <c:if test="${v.active}">
                            <div class="col">
                                <div class="card h-100 border-0 shadow-sm rounded-3 overflow-hidden">
                                    <c:choose>
                                        <c:when test="${not empty v.poster && v.poster.startsWith('http')}">
                                            <img src="${v.poster}" class="card-img-top" alt="${v.title}" style="height: 200px; object-fit: cover;" onerror="this.src='https://placehold.co/640x360?text=No+Image'">
                                        </c:when>
                                        <c:otherwise>
                                            <img src="${pageContext.request.contextPath}/images/${v.poster}" class="card-img-top" alt="${v.title}" style="height: 200px; object-fit: cover;" onerror="this.src='https://placehold.co/640x360?text=MixiVideo'">
                                        </c:otherwise>
                                    </c:choose>
                                    
                                    <div class="card-body p-3 d-flex flex-column">
                                        <h5 class="card-title fw-bold text-dark text-truncate mb-2" title="${v.title}">${v.title}</h5>
                                        <p class="card-text text-muted small text-truncate-2 mb-3" style="display: -webkit-box; -webkit-line-clamp: 2; -webkit-box-orient: vertical; overflow: hidden;">
                                            ${empty v.description ? 'Không có mô tả nội dung.' : v.description}
                                        </p>
                                        <div class="d-flex justify-content-between align-items-center mt-auto border-top pt-2">
                                            <span class="small text-muted fw-semibold"><i class="bi bi-eye"></i> ${v.views} lượt xem</span>
                                            <a href="${pageContext.request.contextPath}/video/detail?id=${v.id}" class="btn btn-danger btn-sm px-3 rounded-pill fw-bold">Xem ngay</a>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </c:if>
                    </c:forEach>
                </c:otherwise>
            </c:choose>
        </div>
    </div>

</body>
</html>	