<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <title>Đặt lại mật khẩu - Hệ thống</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Be+Vietnam+Pro:wght@400;600;700&display=swap" rel="stylesheet">
    <style>
        :root {
            --primary: #006389;
            --text-color: #333333;
            --text-muted: #6c757d;
        }
        body { 
            background: #f8f9fa;
            font-family: 'Inter', 'Be Vietnam Pro', sans-serif; 
            height: 100vh; 
            display: flex; 
            align-items: center; 
            justify-content: center;
            color: var(--text-color);
        }
        .auth-card { 
            background: #ffffff; 
            border: 1px solid #eaeaea;
            border-radius: 12px; 
            width: 100%; 
            max-width: 400px; 
            box-shadow: 0 4px 15px rgba(0,0,0,0.05); 
            overflow: hidden; 
        }
        .form-control { 
            border-radius: 8px; 
            padding: 10px 15px; 
            border: 1px solid #eaeaea;
            background-color: #ffffff;
            color: var(--text-color);
        }
        .form-control:focus {
            background-color: #ffffff;
            border-color: var(--primary);
            box-shadow: 0 0 0 0.2rem rgba(0,99,137,0.25);
            color: var(--text-color);
        }
    </style>
    <jsp:include page="/WEB-INF/views/components/dark-mode.jsp" />
</head>
<body>
    <div class="auth-card">
        <div class="p-4">
            <c:if test="${not empty error}">
                <div class="alert alert-danger py-2 text-center fw-bold">${error}</div>
            </c:if>

            <form action="${pageContext.request.contextPath}/forgot-password?action=reset" method="POST"> 
                
                <h5 class="text-center mb-4 fw-bold text-dark"> 
                    <i class="fas fa-unlock-alt me-2"></i>Tạo mật khẩu mới 
                </h5> 
                
                <input type="hidden" name="email" value="${sessionScope.RESET_EMAIL}"> 

                <div class="mb-3"> 
                    <label class="form-label text-muted small fw-bold">MẬT KHẨU MỚI</label> 
                                <input type="password" class="form-control bg-light" name="newPassword" required placeholder="Nhập mật khẩu mới"> 
                            </div> 

                            <div class="mb-4"> 
                                <label class="form-label text-muted small fw-bold">XÁC NHẬN MẬT KHẨU</label> 
                                <input type="password" class="form-control bg-light" name="confirmPassword" required placeholder="Nhập lại mật khẩu mới"> 
                            </div> 

                            <button type="submit" class="btn btn-info w-100 text-white fw-bold py-2" style="background-color: #0dcaf0; border-radius: 8px;"> 
                                LƯU MẬT KHẨU 
                            </button> 
                        </form> 
        </div>
    </div>
</body>
</html>
