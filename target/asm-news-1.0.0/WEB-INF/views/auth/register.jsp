<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Đăng ký tài khoản - XYZ News</title>
    <link href="https://fonts.googleapis.com/css2?family=Be+Vietnam+Pro:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <style>
        :root {
            --primary: #006389;
            --text-color: #333333;
            --text-muted: #6c757d;
        }
        * { font-family: 'Inter', 'Be Vietnam Pro', sans-serif; transition: all 0.3s ease; }
        body { background: #f8f9fa; color: var(--text-color); min-height: 100vh; display: flex; align-items: center; justify-content: center; padding: 40px 0; }
        .login-card { background: #ffffff; border: 1px solid #eaeaea; border-radius: 12px; box-shadow: 0 4px 15px rgba(0,0,0,0.05); overflow: hidden; animation: fadeIn 0.8s ease-out; width: 100%; color: var(--text-color); }
        .login-header { background: #ffffff; border-bottom: 1px solid #eaeaea; color: var(--text-color); padding: 2rem; text-align: center; }
        .login-header h3 { color: var(--text-color); font-weight: 800; }
        .login-body { padding: 2rem; }
        .btn-login { background: var(--primary); color: #fff !important; border: none; padding: 12px; font-weight: 700; border-radius: 8px !important; }
        .btn-login:hover { background: #004c6b; color: #fff !important; transform: translateY(-2px); }
        .form-label { font-weight: 600; color: var(--text-color); margin-bottom: 5px; }
        .form-control { background: #ffffff; border: 1px solid #eaeaea; color: var(--text-color); border-radius: 8px; padding: 12px 15px; }
        .form-control:focus { background: #ffffff; border-color: var(--primary); box-shadow: 0 0 0 0.2rem rgba(0,99,137,0.25); color: var(--text-color); }
        .back-home { position: absolute; top: 25px; left: 25px; color: var(--text-color); text-decoration: none; padding: 8px 15px; background: #ffffff; border-radius: 8px; font-weight: 500; border: 1px solid #eaeaea; }
        .back-home:hover { color: var(--primary); background: #f8f9fa; border-color: var(--primary); text-decoration: none; }
        
        .alert { border-radius: 8px; border: none; font-weight: 500; background: #ffffff; box-shadow: 0 2px 8px rgba(0,0,0,0.05); }
        .alert-danger { color: #b91c1c; border-left: 5px solid #ef4444; }
        @keyframes fadeIn { from { opacity: 0; transform: translateY(-20px); } to { opacity: 1; transform: translateY(0); } }
    </style>
    <jsp:include page="/WEB-INF/views/components/dark-mode.jsp" />
</head>
<body>
    <a href="${pageContext.request.contextPath}/login" class="back-home">
        <i class="fas fa-arrow-left me-2"></i> Quay lại Đăng nhập
    </a>

    <div class="container">
        <div class="row justify-content-center">
            <div class="col-md-8 col-lg-6">
                <div class="login-card">
                    <div class="login-header">
                        <h3 class="mb-0"><i class="fas fa-user-plus me-2"></i> ĐĂNG KÝ TÀI KHOẢN</h3>
                    </div>
                    <div class="login-body">
                        <c:if test="${not empty errorMessage}">
                            <div class="alert alert-danger alert-dismissible fade show" role="alert">
                                <i class="fas fa-exclamation-circle me-2"></i> ${errorMessage}
                                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                            </div>
                        </c:if>

                        <form action="${pageContext.request.contextPath}/register" method="post">
                            <div class="row">
                                <div class="col-md-6 mb-3">
                                    <label class="form-label">Tên đăng nhập *</label>
                                    <input type="text" name="id" class="form-control" required>
                                </div>
                                <div class="col-md-6 mb-3">
                                    <label class="form-label">Mật khẩu *</label>
                                    <input type="password" name="password" class="form-control" required>
                                </div>
                            </div>
                            
                            <div class="mb-3">
                                <label class="form-label">Họ và tên *</label>
                                <input type="text" name="fullname" class="form-control" required>
                            </div>

                            <div class="mb-3">
                                <label class="form-label">Email *</label>
                                <input type="email" name="email" class="form-control" required>
                            </div>

                            <div class="row">
                                <div class="col-md-6 mb-3">
                                    <label class="form-label">Số điện thoại</label>
                                    <input type="text" name="mobile" class="form-control">
                                </div>
                                <div class="col-md-6 mb-3">
                                    <label class="form-label">Ngày sinh</label>
                                    <input type="date" name="birthday" class="form-control">
                                </div>
                            </div>

                            <div class="mb-4">
                                <label class="form-label d-block">Giới tính</label>
                                <div class="form-check form-check-inline">
                                    <input class="form-check-input" type="radio" name="gender" id="m" value="1" checked>
                                    <label class="form-check-label" for="m">Nam</label>
                                </div>
                                <div class="form-check form-check-inline">
                                    <input class="form-check-input" type="radio" name="gender" id="f" value="0">
                                    <label class="form-check-label" for="f">Nữ</label>
                                </div>
                            </div>

                            <button type="submit" class="btn btn-primary btn-login w-100">
                                <i class="fas fa-check-circle me-2"></i> HOÀN TẤT ĐĂNG KÝ
                            </button>
                        </form>

                        <!-- Đăng ký nhanh bằng mạng xã hội (Chỉ dành cho Độc giả) -->
                        <div class="d-flex align-items-center my-4">
                            <hr class="flex-grow-1 text-muted">
                            <span class="mx-3 text-muted" style="font-size: 0.9rem;">Hoặc đăng ký nhanh bằng</span>
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
                    </div>
                </div>
            </div>
        </div>
    </div>
</body>
</html>