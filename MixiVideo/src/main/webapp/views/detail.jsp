<%@ page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>

<!DOCTYPE html>
<html lang="vi">
<head>
<meta charset="UTF-8">
<title>${empty video ? 'Chi tiết Video' : video.title}</title>

<link
	href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css"
	rel="stylesheet">
<link
	href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css"
	rel="stylesheet">

<style>
body {
	background: #f5f6fa;
}

.video-card {
	background: #fff;
	border-radius: 15px;
	overflow: hidden;
	box-shadow: 0 5px 20px rgba(0, 0, 0, .08);
}

.info-box {
	background: #f8f9fa;
	border-left: 4px solid #dc3545;
	border-radius: 6px;
	padding: 15px;
}
</style>

</head>

<body>

	<nav class="navbar navbar-dark bg-dark shadow">
		<div class="container">
			<a class="navbar-brand fw-bold fs-3"
				href="${pageContext.request.contextPath}/home"> <span
				class="text-white">Mixi</span> <span class="text-danger">Video</span>
			</a> <a href="${pageContext.request.contextPath}/home"
				class="btn btn-outline-light"> <i class="bi bi-arrow-left"></i>
				Trang chủ
			</a>
		</div>
	</nav>

	<div class="container mt-4 mb-5">
		<c:choose>
			<c:when test="${empty video}">
				<div class="alert alert-danger text-center p-5">
					<h3>Không tìm thấy video</h3>
					<p>Video không tồn tại hoặc đã bị xóa.</p>
					<a href="${pageContext.request.contextPath}/home"
						class="btn btn-danger"> Quay lại </a>
				</div>
			</c:when>

			<c:otherwise>
				<div class="row justify-content-center">
					<div class="col-lg-10">
						<div class="video-card">
							<div class="ratio ratio-16x9">
								<%-- SỬA Ở ĐÂY: Dùng ${video.id} thay vì ${video.videoUrl} --%>
								<iframe
									src="https://www.youtube.com/embed/${video.id}?autoplay=1"
									title="${video.title}" frameborder="0"
									allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture"
									allowfullscreen> </iframe>
							</div>

							<div class="p-4">
								<h2 class="fw-bold">${video.title}</h2>

								<div class="d-flex flex-wrap gap-4 mt-3 mb-4 text-muted">
									<div>
										<i class="bi bi-eye-fill text-danger"></i> ${video.views} lượt
										xem
									</div>
									<div>
										<i class="bi bi-hash text-primary"></i> ${video.id}
									</div>
									<div>
										<i class="bi bi-person-circle"></i>
										<c:choose>
											<c:when test="${not empty video.user}">
												${video.user.fullname}
											</c:when>
											<c:otherwise>
												Hệ thống
											</c:otherwise>
										</c:choose>
									</div>
								</div>

								<div class="mb-4">
									<button class="btn btn-outline-primary">
										<i class="bi bi-hand-thumbs-up"></i> Like
									</button>
									<button class="btn btn-outline-danger ms-2">
										<i class="bi bi-hand-thumbs-down"></i> Dislike
									</button>
								</div>

								<h4 class="fw-bold">
									<i class="bi bi-info-circle-fill text-danger"></i> Mô tả
								</h4>

								<div class="info-box">
									<c:choose>
										<c:when test="${empty video.description}">
											Chưa có mô tả cho video này.
										</c:when>
										<c:otherwise>
											${video.description}
										</c:otherwise>
									</c:choose>
								</div>

								<div class="mt-4">
									<c:if test="${sessionScope.currentUser != null}">
										<c:if test="${sessionScope.currentUser.admin}">
											<a
												href="${pageContext.request.contextPath}/video/edit?id=${video.id}"
												class="btn btn-warning"> <i class="bi bi-pencil-square"></i>
												Sửa
											</a>
											<a
												href="${pageContext.request.contextPath}/video/delete?id=${video.id}"
												class="btn btn-danger"
												onclick="return confirm('Bạn có chắc muốn xóa video này?')">
												<i class="bi bi-trash"></i> Xóa
											</a>
										</c:if>
									</c:if>
								</div>
							</div>
						</div>
					</div>
				</div>
			</c:otherwise>
		</c:choose>
	</div>
</body>
</html>