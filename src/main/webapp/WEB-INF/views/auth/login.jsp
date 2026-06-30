<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="vi">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Đăng nhập</title>

    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Be+Vietnam+Pro:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">

    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">

    <style>
        :root {
            --primary: #006389;
            --text-color: #333333;
            --text-muted: #6c757d;
        }

        /* ===========================
           RESET & TYPOGRAPHY
        =========================== */
        * {
            font-family: 'Inter', 'Be Vietnam Pro', sans-serif;
            transition: all 0.3s ease;
        }

        body {
            background: #f8f9fa;
            color: var(--text-color);
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
        }

        /* ===========================
           LOGIN CARD
        =========================== */
        .login-card {
            background: #ffffff;
            border: 1px solid #eaeaea;
            border-radius: 12px;
            box-shadow: 0 4px 15px rgba(0,0,0,0.05);
            overflow: hidden;
            animation: fadeIn 0.8s ease-out;
            color: var(--text-color);
        }

        .login-header {
            background: #ffffff;
            border-bottom: 1px solid #eaeaea;
            color: var(--text-color);
            padding: 3rem 2rem;
            text-align: center;
        }

        .login-header h3 {
            font-weight: 800;
            letter-spacing: 1px;
            font-size: 1.8rem;
            color: var(--text-color);
        }

        .login-header p {
            font-weight: 500;
            color: var(--text-muted);
        }

        .login-body {
            padding: 2.5rem;
        }

        .form-label {
            font-weight: 600;
            color: var(--text-color);
        }

        .form-control {
            border-radius: 8px;
            padding: 12px 15px;
            background: #ffffff;
            border: 1px solid #eaeaea;
            color: var(--text-color);
        }

        .form-control:focus {
            background: #ffffff;
            border-color: var(--primary);
            box-shadow: 0 0 0 0.2rem rgba(0,99,137,0.25);
            color: var(--text-color);
        }

        .btn-login {
            background: var(--primary);
            color: #fff !important;
            border: none;
            padding: 14px;
            font-weight: 700;
            text-transform: uppercase;
            letter-spacing: 1.5px;
            border-radius: 8px !important;
        }

        .btn-login:hover {
            background: #004c6b;
            color: #fff !important;
            transform: translateY(-2px);
        }

        .back-home {
            position: absolute;
            top: 25px;
            left: 25px;
            color: var(--text-color);
            text-decoration: none;
            font-size: 1.1rem;
            font-weight: 500;
            background: #ffffff;
            padding: 8px 15px;
            border-radius: 8px;
            border: 1px solid #eaeaea;
        }

        .back-home:hover {
            color: var(--primary);
            background: #f8f9fa;
            border-color: var(--primary);
            text-decoration: none;
        }

        .text-muted {
            color: var(--text-muted) !important;
        }

        .text-primary {
            color: var(--accent) !important;
        }

        .alert {
            border-radius: 10px;
            border: none;
            font-weight: 500;
            background: rgba(255, 255, 255, 0.6);
            box-shadow: 0 2px 8px rgba(0,0,0,0.1);
            backdrop-filter: blur(10px);
        }
        .alert-danger { color: #b91c1c; border-left: 5px solid #ef4444; }
        .alert-success { color: #065f46; border-left: 5px solid #10b981; }

        @keyframes fadeIn {
            from { opacity: 0; transform: translateY(-20px); }
            to { opacity: 1; transform: translateY(0); }
        }
    </style>
    <jsp:include page="/WEB-INF/views/components/dark-mode.jsp" />
</head>

<body>
    <a href="${pageContext.request.contextPath}/" class="back-home">
        <i class="fas fa-arrow-left me-2"></i> Về trang chủ
    </a>

    <div class="container">
        <div class="row justify-content-center">
            <div class="col-md-6 col-lg-5">
                <div class="login-card">
                    <div class="login-header">
                        <h3 class="mb-0">
                            <i class="fas fa-layer-group me-2"></i> DÒNG CHẢY ADMIN
                        </h3>
                        <p class="mb-0 mt-2">Hi</p>
                    </div>

                    <div class="login-body">
                        <h5 class="text-center text-muted mb-4 fw-bold">Đăng nhập</h5>

                        <c:if test="${not empty errorMessage}">
                            <div class="alert alert-danger alert-dismissible fade show" role="alert">
                                <i class="fas fa-exclamation-circle me-2"></i> ${errorMessage}
                                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                            </div>
                        </c:if>

                        <c:if test="${sessionScope.successMessage != null}">
                            <div class="alert alert-success alert-dismissible fade show" role="alert">
                                <i class="fas fa-check-circle me-2"></i> ${sessionScope.successMessage}
                                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                            </div>
                            <c:remove var="successMessage" scope="session" />
                        </c:if>

                        <form action="${pageContext.request.contextPath}/login" method="post">
                            <div class="mb-3">
                                <label for="username" class="form-label">
                                    <i class="fas fa-user-circle me-1 text-muted"></i> Tên đăng nhập
                                </label>
                                <input type="text" class="form-control" id="username" name="username"
                                    value="${username}" >
                            </div>

                            <div class="mb-4">
                                <label for="password" class="form-label">
                                    <i class="fas fa-lock me-1 text-muted"></i> Mật khẩu
                                </label>
                                <input type="password" class="form-control" id="password" name="password"
                                    required placeholder="Nhập mật khẩu của bạn">
                            </div>

                            <button type="submit" class="btn btn-primary btn-login w-100">
                                <i class="fas fa-sign-in-alt me-2"></i> Đăng nhập
                            </button>
                        </form>

                        <!-- Đăng nhập mạng xã hội (Chỉ dành cho Độc giả) -->
                        <div class="d-flex align-items-center my-4">
                            <hr class="flex-grow-1 text-muted">
                            <span class="mx-3 text-muted" style="font-size: 0.9rem;">Hoặc đăng nhập bằng</span>
                            <hr class="flex-grow-1 text-muted">
                        </div>

                        <div class="row g-2">
                            <div class="col-6">
                                <a href="${pageContext.request.contextPath}/login-google" class="btn btn-outline-danger w-100 py-2 fw-bold d-flex align-items-center justify-content-center" style="border-color: #ea4335; color: #ea4335; font-size: 0.95rem; border-radius: 8px;">
                                    <i class="fab fa-google me-2"></i> Google
                                </a>
                            </div>
                            <div class="col-6">
                                <a href="${pageContext.request.contextPath}/login-facebook" class="btn btn-outline-primary w-100 py-2 fw-bold d-flex align-items-center justify-content-center" style="border-color: #1877f2; color: #1877f2; font-size: 0.95rem; border-radius: 8px;">
                                    <i class="fab fa-facebook-f me-2"></i> Facebook
                                </a>
                            </div>
                        </div>

                        <div class="text-center mt-4">
                            <p class="mb-0 text-muted">Chưa có tài khoản? 
                                <a href="${pageContext.request.contextPath}/register" class="text-primary fw-bold text-decoration-none">Đăng ký ngay</a>
                            </p>
                        </div>

                        <div class="text-center mt-3">
    <a href="${pageContext.request.contextPath}/forgot-password" class="text-decoration-none">Quên mật khẩu?</a>
</div>

                        <div class="text-center mt-4">
                            <small class="text-muted">© 2025 Dòng Chảy Tin Tức. All rights reserved<a href="${pageContext.request.contextPath}/admin/login" style="color: inherit; text-decoration: none; cursor: default;">.</a></small>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
</body>

</html>