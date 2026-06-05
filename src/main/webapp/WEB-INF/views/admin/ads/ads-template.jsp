<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="vi">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>${pageTitle} - XYZ Admin</title>

    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Be+Vietnam+Pro:wght@300;400;500;600;700&display=swap" rel="stylesheet">

    <style>
        :root {
            --primary: #006389;
            --text-color: #333333;
            --text-muted: #6c757d;
        }

        body {
            font-family: 'Inter', 'Be Vietnam Pro', sans-serif; 
            background: #f8f9fa;
            color: var(--text-color);
            overflow-x: hidden;
            min-height: 100vh;
        }

        .main-content {
            padding-left: 0;
        }

        .navbar-admin {
            background: #ffffff;
            padding: 1rem 2rem;
            box-shadow: 0 2px 10px rgba(0,0,0,0.05);
            margin-bottom: 2rem;
            border-bottom: 1px solid #eaeaea;
        }

        .navbar-admin h4 {
            color: var(--text-color);
            font-weight: 700;
            font-size: 1.5rem;
        }

        .user-profile-badge {
            background: #f8f9fa;
            padding: 8px 16px;
            border-radius: 50px;
            display: flex;
            align-items: center;
            gap: 10px;
            color: var(--text-color);
            font-weight: 600;
            border: 1px solid #eaeaea;
        }

        .user-profile-badge i {
            color: var(--primary);
            font-size: 1.2rem;
        }

        .card-custom {
            border: 1px dashed #cbd5e1;
            border-radius: 12px;
            padding: 5rem 2rem;
            text-align: center;
            background-color: #f8fafc;
        }
    </style>
    <jsp:include page="/WEB-INF/views/components/dark-mode.jsp" />
</head>

<body>
    <div class="container-fluid">
        <div class="row">
            <%-- Nhúng Sidebar với activeMenu được truyền từ Servlet --%>
            <jsp:include page="/WEB-INF/views/admin/components/admin-sidebar.jsp">
                <jsp:param name="activeMenu" value="${activeMenu}" />
            </jsp:include>

            <div class="col-md-9 col-lg-10 ms-auto main-content">
                <nav class="navbar navbar-expand-lg navbar-admin sticky-top">
                    <div class="container-fluid">
                        <h4 class="mb-0 fw-bold">${pageTitle}</h4>
                        <div class="navbar-nav ms-auto">
                            <span class="user-profile-badge">
                                <i class="fas fa-user-circle"></i>
                                Xin chào, ${sessionScope.currentUser.fullname}
                            </span>
                        </div>
                    </div>
                </nav>

                <div class="container-fluid px-4 pb-4">
                    <div class="card-custom">
                        <div class="mb-4">
                            <i class="fas fa-tools fa-4x text-muted opacity-50"></i>
                        </div>
                        <h3 class="text-primary fw-bold mb-2">${pageTitle}</h3>
                        <p class="text-muted">Giao diện và bảng dữ liệu của tính năng này đang trong quá trình xây dựng.</p>
                        <a href="${pageContext.request.contextPath}/admin/ads" class="btn btn-primary mt-3 px-4 rounded-pill">
                            <i class="fas fa-arrow-left me-2"></i> Quay lại Dashboard
                        </a>
                    </div>
                </div>
            </div>
        </div>
    </div>
    
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>