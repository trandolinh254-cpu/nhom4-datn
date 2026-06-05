<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="vi">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Cổng Nội Bộ - XYZ News</title>

    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Be+Vietnam+Pro:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">

    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">

    <style>
        :root {
            --primary: #000000;
            --accent: #dc2626;
            --text-color: #333333;
            --text-muted: #6c757d;
        }

        * {
            font-family: 'Inter', 'Be Vietnam Pro', sans-serif;
            transition: all 0.3s ease;
        }

        body {
            background: #111827;
            color: #ffffff;
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
        }

        .login-card {
            background: #1f2937;
            border: 1px solid #374151;
            border-radius: 12px;
            box-shadow: 0 10px 30px rgba(0,0,0,0.5);
            overflow: hidden;
            animation: fadeIn 0.8s ease-out;
            color: #ffffff;
        }

        .login-header {
            background: #1f2937;
            border-bottom: 1px solid #374151;
            padding: 3rem 2rem;
            text-align: center;
        }

        .login-header h3 {
            font-weight: 800;
            letter-spacing: 1px;
            font-size: 1.8rem;
            color: #ffffff;
        }

        .login-header p {
            font-weight: 500;
            color: #9ca3af;
        }

        .login-body {
            padding: 2.5rem;
        }

        .form-label {
            font-weight: 600;
            color: #e5e7eb;
        }

        .form-control {
            border-radius: 8px;
            padding: 12px 15px;
            background: #374151;
            border: 1px solid #4b5563;
            color: #ffffff;
        }

        .form-control:focus {
            background: #374151;
            border-color: var(--accent);
            box-shadow: 0 0 0 0.2rem rgba(220, 38, 38, 0.25);
            color: #ffffff;
        }

        .btn-login {
            background: var(--accent);
            color: #fff !important;
            border: none;
            padding: 14px;
            font-weight: 700;
            text-transform: uppercase;
            letter-spacing: 1.5px;
            border-radius: 8px !important;
        }

        .btn-login:hover {
            background: #b91c1c;
            color: #fff !important;
            transform: translateY(-2px);
        }

        .back-home {
            position: absolute;
            top: 25px;
            left: 25px;
            color: #9ca3af;
            text-decoration: none;
            font-size: 1.1rem;
            font-weight: 500;
            background: rgba(255,255,255,0.05);
            padding: 8px 15px;
            border-radius: 8px;
            border: 1px solid #374151;
        }

        .back-home:hover {
            color: #ffffff;
            background: rgba(255,255,255,0.1);
            text-decoration: none;
        }

        .alert {
            border-radius: 10px;
            border: none;
            font-weight: 500;
        }
        .alert-danger { color: #fecaca; background-color: #991b1b; }
        .alert-success { color: #d1fae5; background-color: #065f46; }

        @keyframes fadeIn {
            from { opacity: 0; transform: translateY(-20px); }
            to { opacity: 1; transform: translateY(0); }
        }
    </style>
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
                            <i class="fas fa-shield-alt me-2 text-danger"></i> XYZ INTERNAL
                        </h3>
                        <p class="mb-0 mt-2">Cổng đăng nhập Quản trị & Tòa soạn</p>
                    </div>

                    <div class="login-body">
                        <c:if test="${not empty errorMessage}">
                            <div class="alert alert-danger alert-dismissible fade show" role="alert">
                                <i class="fas fa-exclamation-triangle me-2"></i> ${errorMessage}
                                <button type="button" class="btn-close btn-close-white" data-bs-dismiss="alert"></button>
                            </div>
                        </c:if>

                        <c:if test="${sessionScope.successMessage != null}">
                            <div class="alert alert-success alert-dismissible fade show" role="alert">
                                <i class="fas fa-check-circle me-2"></i> ${sessionScope.successMessage}
                                <button type="button" class="btn-close btn-close-white" data-bs-dismiss="alert"></button>
                            </div>
                            <c:remove var="successMessage" scope="session" />
                        </c:if>

                        <form action="${pageContext.request.contextPath}/admin/login" method="post">
                            <div class="mb-3">
                                <label for="username" class="form-label">
                                    <i class="fas fa-user-tie me-1"></i> Tài khoản nội bộ
                                </label>
                                <input type="text" class="form-control" id="username" name="username"
                                    value="${username}" placeholder="Nhập tài khoản">
                            </div>

                            <div class="mb-4">
                                <label for="password" class="form-label">
                                    <i class="fas fa-key me-1"></i> Mật khẩu
                                </label>
                                <input type="password" class="form-control" id="password" name="password"
                                    required placeholder="Nhập mật khẩu">
                            </div>

                            <button type="submit" class="btn btn-primary btn-login w-100">
                                <i class="fas fa-sign-in-alt me-2"></i> Truy cập hệ thống
                            </button>
                        </form>

                        <div class="text-center mt-4">
                            <small class="text-muted">© 2025 XYZ News Internal System. Restricted Access.</small>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
</body>

</html>
