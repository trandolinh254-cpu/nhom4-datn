<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <title>Đổi mật khẩu - Dòng Chảy System</title>
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
        .auth-header { 
            background: #ffffff; 
            color: var(--text-color); 
            text-align: center; 
            padding: 25px; 
            border-bottom: 1px solid #eaeaea;
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
        .btn-primary { 
            background-color: var(--primary); 
            border: none; 
            border-radius: 8px; 
            padding: 12px; 
            font-weight: 600; 
            color: white;
            transition: all 0.3s ease;
        }
        .btn-primary:hover {
            background-color: #004c6b;
            color: white;
        }
        .back-btn { 
            position: absolute; 
            top: 20px; 
            left: 20px; 
            color: var(--text-color); 
            text-decoration: none; 
            font-weight: 500;
        }
        .back-btn:hover {
            color: var(--primary);
        }
    </style>
    <jsp:include page="/WEB-INF/views/components/dark-mode.jsp" />
</head>
<body>
    <a href="javascript:history.back()" class="back-btn"><i class="fas fa-arrow-left"></i> Quay lại</a>
    
    <div class="auth-card">
        <div class="auth-header">
            <h4 class="mb-0"><i class="fas fa-key me-2"></i> Đổi mật khẩu</h4>
        </div>
        <div class="p-4">
            <c:if test="${not empty sessionScope.errorMessage}">
                <div class="alert alert-danger py-2">${sessionScope.errorMessage}</div>
                <c:remove var="errorMessage" scope="session" />
            </c:if>

            <form action="${pageContext.request.contextPath}/change-password" method="post">
                <div class="mb-3">
                    <label class="form-label fw-bold text-secondary text-uppercase" style="font-size: 12px;">Mật khẩu hiện tại</label>
                    <input type="password" class="form-control" name="oldPassword" required>
                </div>
                <div class="mb-3">
                    <label class="form-label fw-bold text-secondary text-uppercase" style="font-size: 12px;">Mật khẩu mới</label>
                    <input type="password" class="form-control" name="newPassword" required>
                </div>
                <div class="mb-4">
                    <label class="form-label fw-bold text-secondary text-uppercase" style="font-size: 12px;">Xác nhận mật khẩu mới</label>
                    <input type="password" class="form-control" name="confirmPassword" required>
                </div>
                <button type="submit" class="btn btn-primary w-100"><i class="fas fa-save me-2"></i> CẬP NHẬT MẬT KHẨU</button>
            </form>
        </div>
    </div>
</body>
</html>