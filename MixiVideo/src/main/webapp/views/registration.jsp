<%@ page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Đăng ký tài khoản - MixiVideo</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css" rel="stylesheet">
    
    <style>
        .logo-mixi { font-weight: bold; font-size: 1.8rem; color: #212529; }
        .logo-video { font-weight: bold; font-size: 1.8rem; color: #ff4d4f; }
        .register-card {
            border: none;
            border-top: 4px solid #ff4d4f; /* Viền đỏ đồng bộ thương hiệu */
        }
    </style>
</head>

<body class="bg-light d-flex flex-column min-vh-100 justify-content-center align-items-center">

    <div class="container" style="max-width: 450px;">
        
        <div class="text-center mb-4">
            <a href="${pageContext.request.contextPath}/home" class="text-decoration-none">
                <span class="logo-mixi">Mixi</span><span class="logo-video">Video</span>
            </a>
        </div>

        <form action="${pageContext.request.contextPath}/registration" method="POST" class="p-4 bg-white shadow-sm rounded register-card">
            <h4 class="mb-4 fw-bold text-secondary text-center">ĐĂNG KÝ TÀI KHOẢN</h4>
            
            <c:if test="${not empty error}">
                <div class="alert alert-danger d-flex align-items-center small py-2" role="alert">
                    <i class="bi bi-exclamation-triangle-fill me-2"></i>
                    <div>${error}</div>
                </div>
            </c:if>

            <div class="mb-3">
                <label class="form-label fw-semibold text-muted small">Địa chỉ Email</label>
                <div class="input-group">
                    <span class="input-group-text bg-white text-muted"><i class="bi bi-envelope"></i></span>
                    <input type="email" name="email" class="form-control" placeholder="name@example.com" required>
                </div>
            </div>

            <div class="mb-3">
                <label class="form-label fw-semibold text-muted small">Họ và tên</label>
                <div class="input-group">
                    <span class="input-group-text bg-white text-muted"><i class="bi bi-person"></i></span>
                    <input type="text" name="fullname" class="form-control" placeholder="Nguyễn Văn A" required>
                </div>
            </div>

            <div class="mb-3">
                <label class="form-label fw-semibold text-muted small">Mật khẩu</label>
                <div class="input-group">
                    <span class="input-group-text bg-white text-muted"><i class="bi bi-lock"></i></span>
                    <input type="password" name="password" class="form-control" placeholder="Tối thiểu 6 ký tự" required>
                </div>
            </div>

            <button type="submit" class="btn btn-danger w-100 fw-bold shadow-sm mb-3">
                <i class="bi bi-person-plus-fill"></i> Đăng ký ngay
            </button>

            <hr class="text-muted opacity-25">

            <div class="text-center small mt-3">
                <span class="text-muted">Đã có tài khoản?</span> 
                <a href="${pageContext.request.contextPath}/login" class="text-danger fw-semibold text-decoration-none">Đăng nhập</a>
            </div>

            <div class="text-center small mt-2">
                <a href="${pageContext.request.contextPath}/home" class="text-muted text-decoration-none">
                    <i class="bi bi-arrow-left"></i> Quay lại trang chủ
                </a>
            </div>
        </form>
        
    </div>

</body>
</html>