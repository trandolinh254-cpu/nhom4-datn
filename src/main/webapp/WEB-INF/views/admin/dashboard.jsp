<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="vi">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Dashboard - XYZ Admin Premium</title>

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

        /* ======== SIDEBAR ======== */
        .sidebar {
            background: #ffffff;
            border-right: 1px solid #eaeaea;
            min-height: 100vh;
            box-shadow: 2px 0 10px rgba(0,0,0,0.05);
            z-index: 1000;
            color: var(--text-color);
        }

        .sidebar h5 {
            font-weight: 700;
            letter-spacing: 0.5px;
            color: var(--text-color);
            padding-bottom: 20px;
            border-bottom: 1px solid #eaeaea;
            margin-bottom: 20px;
        }

        .sidebar .nav-link {
            color: var(--text-color);
            padding: 14px 20px;
            margin-bottom: 8px;
            border-radius: 8px;
            font-size: 0.95rem;
            font-weight: 500;
            display: flex;
            align-items: center;
            gap: 12px;
            transition: all 0.3s ease;
        }

        .sidebar .nav-link i {
            width: 24px;
            text-align: center;
            font-size: 1.1rem;
            transition: transform 0.3s;
        }

        .sidebar .nav-link:hover {
            background: #f8f9fa;
            color: var(--primary);
            transform: translateX(5px);
        }

        .sidebar .nav-link.active {
            background: var(--primary);
            color: #ffffff !important;
        }

        .sidebar hr {
            background-color: #eaeaea;
            opacity: 1;
        }

        /* ======== MAIN CONTENT & NAVBAR ======== */
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

        /* ======== STAT CARDS ======== */
        .stat-card {
            border-radius: 12px;
            padding: 1.8rem;
            color: var(--text-color);
            position: relative;
            overflow: hidden;
            border: 1px solid #eaeaea;
            background: #ffffff;
            box-shadow: 0 2px 10px rgba(0,0,0,0.05);
            transition: all 0.3s ease;
            height: 100%;
        }

        .stat-card::before {
            content: '';
            position: absolute;
            top: -50%;
            right: -20%;
            width: 150px;
            height: 150px;
            background: rgba(0, 0, 0, 0.02);
            border-radius: 50%;
            pointer-events: none;
        }

        .stat-card:hover {
            transform: translateY(-4px);
            box-shadow: 0 8px 20px rgba(0,0,0,0.08);
        }

        .stat-card h3 {
            font-weight: 700;
            font-size: 2.2rem;
            margin-bottom: 5px;
        }

        .stat-card p {
            font-size: 0.9rem;
            opacity: 0.9;
            text-transform: uppercase;
            letter-spacing: 1px;
            font-weight: 500;
        }

        .stat-icon {
            font-size: 3rem;
            opacity: 0.1;
            position: absolute;
            right: 20px;
            bottom: 20px;
        }

        /* Card Colors - Light style */
        .stat-card.primary { border-bottom: 4px solid var(--primary); } 
        .stat-card.success { border-bottom: 4px solid #10b981; } 
        .stat-card.warning { border-bottom: 4px solid #f59e0b; } 
        .stat-card.info { border-bottom: 4px solid #3b82f6; } 

        /* ======== TABLES & CARDS ======== */
        .card {
            border: 1px solid #eaeaea;
            border-radius: 12px;
            background: #ffffff;
            box-shadow: 0 2px 10px rgba(0,0,0,0.05);
            margin-bottom: 2rem;
            color: var(--text-color);
        }

        .card-header {
            background: #ffffff;
            border-bottom: 1px solid #eaeaea;
            padding: 1.5rem;
            border-radius: 12px 12px 0 0 !important;
        }

        .card-header h5 {
            color: var(--text-color);
            font-weight: 700;
            font-size: 1.1rem;
            margin: 0;
            display: flex;
            align-items: center;
            gap: 10px;
        }

        .card-header h5 i {
            color: var(--primary);
        }

        .table {
            margin-bottom: 0;
            vertical-align: middle;
            color: var(--text-color);
        }

        .table thead th {
            background: #f8f9fa;
            color: var(--text-color);
            font-weight: 600;
            text-transform: uppercase;
            font-size: 0.75rem;
            letter-spacing: 0.5px;
            border-bottom: 1px solid #eaeaea;
            padding: 1rem;
        }

        .table tbody td {
            padding: 1rem;
            color: var(--text-color);
            border-bottom: 1px solid #eaeaea;
            font-size: 0.95rem;
        }

        .table tbody tr:hover {
            background-color: #f8fafc;
        }

        .table tbody tr:last-child td {
            border-bottom: none;
        }

        /* Badges & Buttons */
        .badge {
            padding: 0.5em 0.8em;
            font-weight: 500;
            border-radius: 6px;
        }
        .badge.bg-secondary { background-color: #e2e8f0 !important; color: #475569; }
        .badge.bg-warning { background-color: #fef3c7 !important; color: #b45309; }

        .btn-outline-primary {
            border-color: #cbd5e1;
            color: #64748b;
        }
        .btn-outline-primary:hover {
            background: var(--accent-blue);
            border-color: var(--accent-blue);
            color: white;
        }

        /* Alerts */
        .alert {
            border-radius: 12px;
            border: none;
            box-shadow: 0 4px 6px rgba(0,0,0,0.05);
        }
    </style>
    <jsp:include page="/WEB-INF/views/components/dark-mode.jsp" />
</head>

<body>
    <div class="container-fluid">
        <div class="row">
            <jsp:include page="/WEB-INF/views/admin/components/admin-sidebar.jsp">
                <jsp:param name="activeMenu" value="dashboard" />
            </jsp:include>

            <div class="col-md-9 col-lg-10 ms-auto main-content">
                <nav class="navbar navbar-expand-lg navbar-admin sticky-top">
                    <div class="container-fluid">
                        <h4 class="mb-0">Tổng quan hệ thống</h4>
                        <div class="navbar-nav ms-auto">
                            <span class="user-profile-badge">
                                <i class="fas fa-user-circle"></i>
                                Xin chào, ${sessionScope.currentUser.fullname}
                            </span>
                        </div>
                    </div>
                </nav>

                <div class="container-fluid px-4">
                    <c:if test="${sessionScope.successMessage != null}">
                        <div class="alert alert-success alert-dismissible fade show d-flex align-items-center" role="alert">
                            <i class="fas fa-check-circle me-2 fs-5"></i>
                            <div>${sessionScope.successMessage}</div>
                            <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                        </div>
                        <c:remove var="successMessage" scope="session" />
                    </c:if>

                    <c:if test="${sessionScope.errorMessage != null}">
                        <div class="alert alert-danger alert-dismissible fade show d-flex align-items-center" role="alert">
                            <i class="fas fa-exclamation-triangle me-2 fs-5"></i>
                            <div>${sessionScope.errorMessage}</div>
                            <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                        </div>
                        <c:remove var="errorMessage" scope="session" />
                    </c:if>
                </div>

                <div class="container-fluid px-4 pb-4">
                    <div class="row g-4 mb-4">
                        <div class="col-md-6 col-xl-3">
                            <div class="stat-card primary">
                                <div class="d-flex flex-column position-relative z-1">
                                    <h3 class="mb-0">${totalNews}</h3>
                                    <p class="mb-0">Tin tức</p>
                                </div>
                                <i class="fas fa-newspaper stat-icon"></i>
                            </div>
                        </div>

                        <div class="col-md-6 col-xl-3">
                            <div class="stat-card success">
                                <div class="d-flex flex-column position-relative z-1">
                                    <h3 class="mb-0">${totalCategories}</h3>
                                    <p class="mb-0">Chuyên mục</p>
                                </div>
                                <i class="fas fa-tags stat-icon"></i>
                            </div>
                        </div>

                        <div class="col-md-6 col-xl-3">
                            <div class="stat-card warning">
                                <div class="d-flex flex-column position-relative z-1">
                                    <h3 class="mb-0">${totalUsers}</h3>
                                    <p class="mb-0">Người dùng</p>
                                </div>
                                <i class="fas fa-users stat-icon"></i>
                            </div>
                        </div>

                        <div class="col-md-6 col-xl-3">
                            <div class="stat-card info">
                                <div class="d-flex flex-column position-relative z-1">
                                    <h3 class="mb-0">${totalNewsletters}</h3>
                                    <p class="mb-0">Đăng ký tin</p>
                                </div>
                                <i class="fas fa-envelope stat-icon"></i>
                            </div>
                        </div>
                    </div>



                    <!-- KHU VỰC BIỂU ĐỒ THỐNG KÊ -->
                    <div class="row g-4 mb-4">
                        <!-- Chart 1: News Category (Doughnut) -->
                        <div class="col-md-8 mx-auto">
                            <div class="card h-100">
                                <div class="card-header">
                                    <h5 class="mb-0"><i class="fas fa-chart-pie"></i> Tỷ lệ bài viết theo chuyên mục</h5>
                                </div>
                                <div class="card-body d-flex justify-content-center align-items-center">
                                    <canvas id="categoryChart" style="max-height: 400px; width: 100%;"></canvas>
                                </div>
                            </div>
                        </div>
                    </div>

                    <div class="row">
                        <div class="col-12">
                            <div class="card">
                                <div class="card-header">
                                    <h5 class="mb-0">
                                        <i class="fas fa-clock"></i> Tin tức mới nhất
                                    </h5>
                                </div>
                                <div class="card-body p-0">
                                    <c:choose>
                                        <c:when test="${not empty latestNews}">
                                            <div class="table-responsive">
                                                <table class="table table-hover align-middle">
                                                    <thead>
                                                        <tr>
                                                            <th width="40%">Tiêu đề</th>
                                                            <th>Tác giả</th>
                                                            <th>Chuyên mục</th>
                                                            <th>Ngày đăng</th>
                                                            <th>Lượt xem</th>
                                                            <th class="text-end">Hành động</th>
                                                        </tr>
                                                    </thead>
                                                    <tbody>
                                                        <c:forEach var="news" items="${latestNews}">
                                                            <tr>
                                                                <td>
                                                                    <div class="d-flex align-items-center">
                                                                        <div class="ms-2">
                                                                            <a href="${pageContext.request.contextPath}/news?action=detail&id=${news.id}"
                                                                                class="text-decoration-none fw-bold text-dark"
                                                                                target="_blank">
                                                                                ${news.title}
                                                                            </a>
                                                                            <c:if test="${news.home}">
                                                                                <span class="badge bg-warning ms-2" style="font-size: 0.7em;">
                                                                                    <i class="fas fa-star me-1"></i>Hot
                                                                                </span>
                                                                            </c:if>
                                                                        </div>
                                                                    </div>
                                                                </td>
                                                                <td>
                                                                    <span class="text-muted"><i class="far fa-user me-1"></i>${news.authorName}</span>
                                                                </td>
                                                                <td>
                                                                    <span class="badge bg-secondary">${news.categoryName}</span>
                                                                </td>
                                                                <td>
                                                                    <span class="text-muted" style="font-size: 0.9em;">
                                                                        <fmt:formatDate value="${news.postedDate}" pattern="dd/MM/yyyy" />
                                                                    </span>
                                                                </td>
                                                                <td>
                                                                    <span class="fw-bold text-primary">
                                                                        ${news.viewCount}
                                                                    </span>
                                                                </td>
                                                                <td class="text-end">
                                                                    <a href="${pageContext.request.contextPath}/admin/news/edit?id=${news.id}"
                                                                        class="btn btn-sm btn-outline-primary"
                                                                        title="Chỉnh sửa">
                                                                        <i class="fas fa-pen"></i>
                                                                    </a>
                                                                </td>
                                                            </tr>
                                                        </c:forEach>
                                                    </tbody>
                                                </table>
                                            </div>
                                        </c:when>
                                        <c:otherwise>
                                            <div class="text-center py-5">
                                                <div class="mb-3">
                                                    <i class="fas fa-newspaper fa-4x text-light"></i>
                                                </div>
                                                <h6 class="text-muted fw-normal">Chưa có dữ liệu tin tức nào</h6>
                                                <a href="${pageContext.request.contextPath}/admin/news/add"
                                                    class="btn btn-primary mt-3 px-4 rounded-pill">
                                                    <i class="fas fa-plus me-2"></i> Thêm mới
                                                </a>
                                            </div>
                                        </c:otherwise>
                                    </c:choose>
                                </div>
                            </div>
                        </div>
                    </div>


                </div>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
    
    <!-- Thêm thư viện Chart.js -->
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
    <script type="application/json" id="categoryLabelsData">
        ${empty chartCategoryLabels ? "[]" : chartCategoryLabels}
    </script>
    <script type="application/json" id="categoryDataData">
        ${empty chartCategoryData ? "[]" : chartCategoryData}
    </script>
    
    <script>
        // Dữ liệu biểu đồ từ Java truyền sang
        const categoryLabels = JSON.parse(document.getElementById('categoryLabelsData').textContent || "[]");
        const categoryData = JSON.parse(document.getElementById('categoryDataData').textContent || "[]");

        // Render Biểu đồ tròn
        const ctxCategory = document.getElementById('categoryChart').getContext('2d');
        new Chart(ctxCategory, {
            type: 'doughnut',
            data: {
                labels: categoryLabels,
                datasets: [{
                    data: categoryData,
                    backgroundColor: ['#006389', '#10b981', '#f59e0b', '#3b82f6', '#ef4444', '#8b5cf6', '#ec4899', '#14b8a6'],
                    borderWidth: 1
                }]
            },
            options: {
                responsive: true,
                maintainAspectRatio: false,
                plugins: {
                    legend: { position: 'right' }
                }
            }
        });
    </script>
</body>

</html>