<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <title>Quên mật khẩu - Dòng Chảy System</title>
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
    <a href="${pageContext.request.contextPath}/login" class="back-btn"><i class="fas fa-arrow-left"></i> Về trang đăng nhập</a>
    
    <div class="auth-card">
        <div class="auth-header">
            <h4 class="mb-0"><i class="fas fa-unlock-alt me-2"></i> Khôi phục mật khẩu</h4>
        </div>
        <div class="p-4">
            <p class="text-muted text-center mb-4" style="font-size: 14px;">Vui lòng nhập Email đã đăng ký để hệ thống cấp lại mật khẩu.</p>
            
            <c:if test="${not empty sessionScope.errorMessage}">
                <div class="alert alert-danger py-2">${sessionScope.errorMessage}</div>
                <c:remove var="errorMessage" scope="session" />
            </c:if>

                        <form action="${pageContext.request.contextPath}/forgot-password?action=verify" method="POST" id="forgotForm"> 
                            
                            <div class="mb-3"> 
                                <label class="form-label text-muted small fw-bold">EMAIL ĐĂNG KÝ</label> 
                                <input type="email" class="form-control bg-light" name="email" id="email" required placeholder="Ví dụ: nguyenvan@gmail.com"> 
                            </div> 

                            <div class="mb-4"> 
                                <label class="form-label text-muted small fw-bold">MÃ XÁC THỰC (OTP)</label> 
                                <div class="input-group"> 
                                    <input type="text" class="form-control bg-light" name="otpCode" id="otpCode" required placeholder="Nhập mã 6 số"> 
                                    
                                    <button class="btn btn-outline-info fw-bold px-3" type="button" id="btnGetCode" onclick="sendOTP()" style="border-color: #0dcaf0; color: #0dcaf0;"> 
                                        Lấy mã 
                                    </button> 
                                </div> 
                                <small class="text-success mt-1 fw-bold" id="otpMessage" style="display:none;"> 
                                    <i class="fas fa-check-circle me-1"></i>Đã gửi mã về email của bạn! 
                                </small> 
                            </div> 

                            <button type="submit" class="btn btn-info w-100 text-white fw-bold py-2" style="background-color: #0dcaf0; border-radius: 8px;"> 
                                <i class="fas fa-paper-plane me-1"></i> KHÔI PHỤC MẬT KHẨU 
                            </button> 
                        </form> 
        </div>
    </div>
    <script> 
        function sendOTP() { 
            const email = document.getElementById('email').value.trim(); 
            if(!email) { 
                alert("Vui lòng nhập Email trước khi lấy mã!"); 
                document.getElementById('email').focus(); 
                return; 
            } 
            
            const btn = document.getElementById('btnGetCode'); 
            btn.disabled = true; // Khóa nút tránh bấm nhiều lần 
            btn.innerText = "Đang gửi..."; 

            // Gọi đến Servlet Backend để bắn Email 
            fetch('${pageContext.request.contextPath}/forgot-password?action=sendOTP', { 
                method: 'POST', 
                headers: { 'Content-Type': 'application/x-www-form-urlencoded' }, 
                body: 'email=' + encodeURIComponent(email) 
            }) 
            .then(response => response.json()) 
            .then(data => { 
                if(data.status === 'success') { 
                    document.getElementById('otpMessage').style.display = 'block'; 
                    btn.innerText = "Đã gửi (60s)"; 
                    // Xử lý logic đếm ngược 60s nếu cần... 
                } else { 
                    alert("Lỗi: " + data.message); 
                    btn.disabled = false; 
                    btn.innerText = "Lấy mã"; 
                } 
            }) 
            .catch(err => { 
                alert("Lỗi kết nối tới máy chủ!"); 
                btn.disabled = false; 
                btn.innerText = "Lấy mã"; 
            }); 
        } 
    </script> 
</body>
</html>