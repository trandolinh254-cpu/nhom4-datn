<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %> <!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Dashboard Quảng Cáo - XYZ Admin Premium</title>
    
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Be+Vietnam+Pro:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">

    <style>
        :root { 
            --primary: #006389;
            --text-color: #333333; 
            --text-muted: #6c757d;
        }
        body { 
            font-family: 'Inter', 'Be Vietnam Pro', sans-serif; /* FIX: Đồng bộ font hệ thống mượt mà */
            background: #f8f9fa; 
            color: var(--text-color);
            overflow-x: hidden; 
            min-height: 100vh; 
        }
        .main-content { padding-left: 0; }
        
        /* FIX: Cấu trúc Topbar mượt mà có đổ bóng nhẹ tinh tế */
        .navbar-admin { 
            background: #ffffff; 
            padding: 1rem 2rem; 
            box-shadow: 0 2px 10px rgba(0,0,0,0.05);
            border-bottom: 1px solid #eaeaea; 
            margin-bottom: 2rem; 
        }
        .navbar-admin h4 { font-weight: 700; color: var(--text-color); }
        
        /* FIX: Tối ưu Stat Card Premium phẳng, đổ bóng hiện đại và có hiệu ứng hover mượt */
        .stat-card { 
            border-radius: 12px; 
            padding: 1.8rem;
            position: relative; 
            overflow: hidden; 
            background: #ffffff; 
            box-shadow: 0 2px 10px rgba(0,0,0,0.05); 
            height: 100%; 
            border: 1px solid #eaeaea;
            transition: all 0.3s ease;
        }
        .stat-card:hover {
            transform: translateY(-3px);
            box-shadow: 0 4px 15px rgba(0,0,0,0.1);
        }
        .stat-card.warning { border-bottom: 4px solid #f59e0b; }
        .stat-card.success { border-bottom: 4px solid #10b981; }
        .stat-card.primary { border-bottom: 4px solid var(--primary); }
        
        .stat-card h3 { font-weight: 700; font-size: 2.2rem; margin-bottom: 5px; }
        .stat-icon { 
            font-size: 2.5rem; 
            position: absolute; 
            right: 20px; 
            bottom: 20px; 
            opacity: 0.15;
            transition: transform 0.3s ease, opacity 0.3s ease;
        }
        .stat-card:hover .stat-icon {
            transform: scale(1.1);
            opacity: 0.25;
        }
        
        /* FIX: Tinh chỉnh Card và Bảng dữ liệu đồng bộ giao diện quản trị chung */
        .card { 
            border-radius: 12px; 
            border: 1px solid #eaeaea;
            box-shadow: 0 2px 10px rgba(0,0,0,0.05); 
            background: #ffffff;
        }
        .card-header { 
            background: #ffffff;
            border-bottom: 1px solid #eaeaea; 
            padding: 1.5rem; 
            border-radius: 12px 12px 0 0 !important; 
            font-weight: 700;
            font-size: 1.1rem;
        }
        .table th {
            font-weight: 600;
            text-transform: uppercase;
            font-size: 0.85rem;
            letter-spacing: 0.5px;
            padding: 15px;
        }
        .table td {
            padding: 15px;
        }
    </style>
</head>
<body>
    <div class="container-fluid">
        <div class="row">
            <%-- Nhúng Sidebar --%>
            <jsp:include page="/WEB-INF/views/admin/components/admin-sidebar.jsp">
                <jsp:param name="activeMenu" value="ads_dashboard" />
            </jsp:include>

            <div class="col-md-9 col-lg-10 ms-auto main-content">
                <nav class="navbar navbar-admin sticky-top">
                    <div class="container-fluid">
                        <h4 class="mb-0 fw-bold">Dashboard Quảng Cáo</h4>
                    </div>
                </nav>

                <div class="container-fluid px-4 pb-4">
                    <div class="row g-4 mb-4">
                        <div class="col-md-4">
                            <div class="stat-card warning">
                                <h3 class="text-warning">${empty pendingAdsCount ? '0' : pendingAdsCount}</h3>
                                <p class="mb-0 fw-bold text-muted">Yêu cầu chờ duyệt</p>
                                <i class="fas fa-inbox stat-icon text-warning"></i>
                            </div>
                        </div>
                        <div class="col-md-4">
                            <div class="stat-card success">
                                <h3 class="text-success">${empty runningAdsCount ? '0' : runningAdsCount}</h3>
                                <p class="mb-0 fw-bold text-muted">Đang chạy</p>
                                <i class="fas fa-play-circle stat-icon text-success"></i>
                            </div>
                        </div>
                        <div class="col-md-4">
                            <div class="stat-card primary">
                                <h3 class="text-primary">
                                    <c:choose>
                                        <c:when test="${not empty revenueThisMonth}">
                                            <fmt:formatNumber value="${revenueThisMonth}" pattern="#,###"/> đ
                                        </c:when>
                                        <c:otherwise>0 đ</c:otherwise>
                                    </c:choose>
                                </h3>
                                <p class="mb-0 fw-bold text-muted">Doanh thu tháng</p>
                                <i class="fas fa-money-bill-wave stat-icon text-primary"></i>
                            </div>
                        </div>
                    </div>

                    <div class="card">
                        <div class="card-header text-danger">
                            <i class="fas fa-bell me-2"></i>Yêu cầu đặt chỗ mới nhất
                        </div>
                        <div class="card-body p-0">
                            <div class="table-responsive"> <table class="table table-hover align-middle mb-0">
                                    <thead class="bg-light text-muted">
                                        <tr>
                                            <th class="ps-4">Khách hàng</th>
                                            <th>Vị trí đăng ký</th>
                                            <th>Trạng thái</th>
                                            <th class="pe-4">Hành động</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <%-- Chỗ này sau sẽ dùng vòng lặp c:forEach đổ từ Database ra --%>
                                        <tr>
                                            <td colspan="4" class="text-center py-5 text-muted">
                                                <i class="fas fa-database fa-2x mb-2 opacity-25 d-block"></i>
                                                Chưa có dữ liệu từ Database
                                            </td>
                                        </tr>
                                    </tbody>
                                </table>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
    
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>