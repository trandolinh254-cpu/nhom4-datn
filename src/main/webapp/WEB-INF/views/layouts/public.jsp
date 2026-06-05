<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
            <!DOCTYPE html>
            <html lang="vi">

            <head>
                <meta charset="UTF-8">
                <meta name="viewport" content="width=device-width, initial-scale=1.0">
                <title>${pageTitle != null ? pageTitle : 'ASM News'} - Tin tức 24h</title>

                <!-- Bootstrap CSS -->
                <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
                <!-- Font Awesome -->
                <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">

               <style>
    /* ------------------------------------------- */
    /* SỬ DỤNG BẢNG MÀU CHUYÊN NGHIỆP VÀ SANG TRỌNG */
    /* ------------------------------------------- */
    :root {
        --navy: #091C35; /* Navy Dark - Màu chủ đạo cho Menu/Footer */
        --navy-light: #1D3557; /* Navy Tối nhẹ */
        --navy-hover: #2c5282; /* Màu hover cho chữ/link */
        --accent: #00A896; /* Xanh ngọc lục bảo (Teal) - Màu nhấn */
        --background-content: #EBEBEB; /* Nền nội dung xám sáng (theo yêu cầu cuối) */
        --text-color: #2d3748; /* Màu chữ chính */
        --shadow-navbar: 0 6px 30px rgba(9, 28, 53, 0.4); /* Bóng đổ mạnh cho Navbar */
        --shadow-subtle: 0 4px 15px rgba(0, 0, 0, 0.05); /* Bóng đổ nhẹ */
    }

    body {
        font-family: sans-serif; /* Giữ nguyên font mặc định của Bootstrap hoặc dùng 'Inter' */
        background-color: var(--background-content); /* Nền xám sáng đồng bộ */
        color: var(--text-color);
    }

    /* ------------------------------------------- */
    /* 1. NAVBAR (THANH MENU) SANG TRỌNG */
    /* ------------------------------------------- */
    .navbar {
        /* Áp dụng Gradient Navy và Shadow */
        background: linear-gradient(135deg, var(--navy), var(--navy-light)) !important;
        box-shadow: var(--shadow-navbar); 
        position: sticky; /* Đặt sticky/ed nếu cần, mặc định giữ sticky */
        top: 0;
        z-index: 1030;
    }

    .navbar-brand {
        font-weight: 700;
        color: white !important;
        font-size: 1.5rem;
    }

    .navbar .nav-link {
        color: rgba(255, 255, 255, 0.9) !important; /* Màu trắng sáng nhẹ */
        font-weight: 500;
        transition: all 0.3s ease;
    }

    .navbar .nav-link:hover,
    .navbar .nav-link.active {
        color: var(--accent) !important; /* Màu accent nổi bật */
        border-bottom: 2px solid var(--accent); /* Gạch dưới tinh tế */
        padding-bottom: 0.2rem;
    }

    .navbar-toggler {
        border-color: rgba(255, 255, 255, 0.5);
    }
    .navbar-toggler-icon {
        filter: invert(1); /* Biến icon thành màu trắng */
    }
    
    /* Dropdown Menu - Thêm bóng đổ mềm mại */
    .dropdown-menu {
        border: none;
        box-shadow: 0 10px 30px rgba(0,0,0,0.15);
        border-radius: 8px;
    }

    /* ------------------------------------------- */
    /* 2. CÁC THÀNH PHẦN KHÁC (Đồng bộ với Accent) */
    /* ------------------------------------------- */

    /* Sidebar Widget - Đổi nền trắng để nổi bật trên nền xám */
    .sidebar-widget {
        background: white; 
        border-radius: 12px;
        padding: 20px;
        margin-bottom: 25px;
        border-left: 5px solid var(--accent); /* Đổi sang màu Accent mới */
        box-shadow: var(--shadow-subtle);
    }

    .widget-title {
        color: var(--navy);
        border-bottom: 2px solid var(--accent); /* Gạch dưới màu Accent */
        padding-bottom: 10px;
        margin-bottom: 15px;
    }

    /* Cards - Đảm bảo nổi bật */
    .news-card {
        background: white; /* Nền trắng */
        border-radius: 12px;
        box-shadow: var(--shadow-subtle);
        transition: all 0.3s ease;
    }

    .news-card:hover {
        transform: translateY(-5px);
        box-shadow: 0 8px 20px rgba(0, 0, 0, 0.1);
    }

    /* Buttons & Badges */
    .badge.bg-primary {
        background-color: var(--accent) !important; /* Đổi Primary sang Accent */
    }

    .btn-primary {
        background-color: var(--accent) !important;
        border-color: var(--accent) !important;
        transition: all 0.3s ease;
    }

    .btn-primary:hover {
        background-color: var(--navy) !important; /* Hover sang màu Navy */
        border-color: var(--navy) !important;
    }
    /* ------------------------------------------- */
    /* 3. FOOTER (CHÂN TRANG) ĐỒNG BỘ */
    /* ------------------------------------------- */
    .footer {
        /* Áp dụng Gradient Navy đồng bộ với Navbar */
        background: linear-gradient(135deg, var(--navy), var(--navy-light)); 
        color: #e3e8ee; /* Màu chữ sáng nhạt */
        padding: 60px 0 30px;
        margin-top: 80px;
    }

    .footer input.form-control {
        background-color: rgba(255, 255, 255, 0.1);
        border: 1px solid rgba(255, 255, 255, 0.3);
        color: white;
    }

    .footer input.form-control::placeholder {
        color: rgba(255, 255, 255, 0.7);
    }

    .footer .btn-primary {
        background-color: var(--accent) !important;
        border-color: var(--accent) !important;
    }
</style>
            </head>

            <body>
                <!-- Header -->
                <nav class="navbar navbar-expand-lg navbar-light bg-light shadow-sm">
                    <div class="container">
                        <a class="navbar-brand" href="${pageContext.request.contextPath}/">
                            <i class="fas fa-newspaper"></i> DANGKHOI News
                        </a>

                        <button class="navbar-toggler" type="button" data-bs-toggle="collapse"
                            data-bs-target="#navbarNav">
                            <span class="navbar-toggler-icon"></span>
                        </button>

                        <div class="collapse navbar-collapse" id="navbarNav">
                            <ul class="navbar-nav me-auto">
                                <li class="nav-item">
                                    <a class="nav-link" href="${pageContext.request.contextPath}/">Trang chủ</a>
                                </li>
                                <li class="nav-item">
                                    <a class="nav-link" href="${pageContext.request.contextPath}/news">Tin tức</a>
                                </li>
                                <c:forEach var="category" items="${categories}">
                                    <li class="nav-item">
                                        <a class="nav-link"
                                            href="${pageContext.request.contextPath}/news?action=category&id=${category.id}">
                                            ${category.name}
                                        </a>
                                    </li>
                                </c:forEach>
                            </ul>

                            <%-- Search form cố định trong navbar để tránh nav-item xuống dòng --%>
                            <form class="d-flex me-3" action="${pageContext.request.contextPath}/news" method="get">
                                <input type="hidden" name="action" value="search">
                                <div class="input-group" style="width: 220px;">
                                    <input class="form-control form-control-sm"
                                           type="search" name="keyword"
                                           placeholder="Tìm kiếm bài viết..."
                                           value="${searchKeyword}"
                                           style="background:rgba(255,255,255,0.15); border-color:rgba(255,255,255,0.3); color:white;">
                                    <button class="btn btn-sm" type="submit"
                                            style="background:var(--accent); border:none; color:white;">
                                        <i class="fas fa-search"></i>
                                    </button>
                                </div>
                            </form>

                            <ul class="navbar-nav">
                                <c:choose>
                                    <c:when test="${sessionScope.currentUser.admin || sessionScope.currentUser.reporter}">
                                        <li class="nav-item dropdown">
                                            <a class="nav-link dropdown-toggle" href="#" id="navbarDropdown"
                                                role="button" data-bs-toggle="dropdown">
                                                <i class="fas fa-user"></i> ${sessionScope.currentUser.fullname}
                                            </a>
                                            <ul class="dropdown-menu">
                                                <li><a class="dropdown-item"
                                                        href="${pageContext.request.contextPath}/profile">
                                                        <i class="fas fa-user me-2"></i> Hồ sơ
                                                    </a></li>
                                                <li><a class="dropdown-item"
                                                        href="${pageContext.request.contextPath}${sessionScope.currentUser.admin ? '/admin/news' : '/reporter/news'}">
                                                        <i class="fas fa-list-alt me-2"></i> Bài viết của tôi
                                                    </a></li>
                                                <c:if test="${sessionScope.currentUser.admin}">
                                                    <li><a class="dropdown-item"
                                                            href="${pageContext.request.contextPath}/admin">
                                                            <i class="fas fa-tachometer-alt"></i> Quản trị
                                                        </a></li>
                                                </c:if>
                                                <li>
                                                    <hr class="dropdown-divider">
                                                </li>
                                                <li><a class="dropdown-item"
                                                        href="${pageContext.request.contextPath}/logout">
                                                        <i class="fas fa-sign-out-alt"></i> Đăng xuất
                                                    </a></li>
                                            </ul>
                                        </li>
                                    </c:when>
                                    <c:otherwise>
                                        <li class="nav-item">
                                            <a class="nav-link" href="${pageContext.request.contextPath}/login">
                                                <i class="fas fa-sign-in-alt"></i> Đăng nhập
                                            </a>
                                        </li>
                                    </c:otherwise>
                                </c:choose>
                            </ul>
                        </div>
                    </div>
                </nav>

                <!-- Messages -->
                <c:if test="${sessionScope.successMessage != null}">
                    <div class="container mt-3">
                        <div class="alert alert-success alert-dismissible fade show" role="alert">
                            <i class="fas fa-check-circle"></i> ${sessionScope.successMessage}
                            <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                        </div>
                    </div>
                    <c:remove var="successMessage" scope="session" />
                </c:if>

                <c:if test="${sessionScope.errorMessage != null}">
                    <div class="container mt-3">
                        <div class="alert alert-danger alert-dismissible fade show" role="alert">
                            <i class="fas fa-exclamation-circle"></i> ${sessionScope.errorMessage}
                            <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                        </div>
                    </div>
                    <c:remove var="errorMessage" scope="session" />
                </c:if>

                <!-- Main Content -->
                <main class="container my-4">
                    <jsp:include page="${contentPage}" />
                </main>

                <!-- Footer -->
                <footer class="footer">
                    <div class="container">
                        <div class="row">
                            <div class="col-md-6">
                                <h5><i class="fas fa-newspaper"></i> DANGKHOI News</h5>
                                <p>Website tin tức 24h cập nhật nhanh nhất</p>
                            </div>
                            <div class="col-md-6">
                                <h5>Đăng ký nhận tin</h5>
                                <form action="${pageContext.request.contextPath}/newsletter" method="post"
                                    class="d-flex">
                                    <input type="hidden" name="action" value="subscribe">
                                    <input type="email" name="email" class="form-control me-2"
                                        placeholder="Email của bạn" required>
                                    <button type="submit" class="btn btn-primary">
                                        <i class="fas fa-paper-plane"></i>
                                    </button>
                                </form>
                            </div>
                        </div>
                        <hr class="my-4">
                        <div class="row">
                            <div class="col-12 text-center">
                                <p>&copy; 2025 ASM News. All rights reserved. | Developed by FPT Polytechnic Student</p>
                            </div>
                        </div>
                    </div>
                </footer>

                <!-- Bootstrap JS -->
                <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
            </body>

            </html>