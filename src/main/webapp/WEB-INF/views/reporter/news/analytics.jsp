<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="vi">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Thống kê bài viết - XYZ Reporter</title>

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

        * {
            font-family: 'Inter', 'Be Vietnam Pro', sans-serif;
            transition: all 0.3s ease;
        }

        body {
            background: #f8f9fa;
            color: var(--text-color);
            overflow-x: hidden;
            min-height: 100vh;
        }

        .main-content {
            background-color: transparent;
            padding-left: 0;
            padding-top: 0;
        }

        .navbar-admin {
            background: #ffffff;
            padding: 1rem 2rem;
            box-shadow: 0 2px 10px rgba(0,0,0,0.05);
            margin-bottom: 2rem;
            border-bottom: 1px solid #eaeaea;
            z-index: 900;
            display: flex;
            align-items: center;
        }

        .navbar-admin h4 {
            color: var(--text-color);
            font-weight: 700;
            font-size: 1.5rem;
        }

        .navbar-text {
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

        .navbar-text i {
            color: var(--primary);
            font-size: 1.2rem;
        }

        .page-title {
            font-size: 26px;
            font-weight: 700;
            margin-bottom: 12px;
            position: relative;
            padding-bottom: 12px;
            color: var(--text-color);
        }

        .page-title::after {
            content: "";
            position: absolute;
            bottom: 0;
            left: 0;
            width: 60px;
            height: 3px;
            background: var(--primary);
            border-radius: 2px;
        }

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
            color: var(--text-color);
            font-weight: 700;
            font-size: 1.1rem;
            padding: 1.2rem 1.5rem;
            border-bottom: 1px solid #eaeaea;
            border-radius: 12px 12px 0 0 !important;
            display: flex;
            align-items: center;
            gap: 10px;
        }

        .card-header i {
            color: var(--primary);
        }

        .stat-card {
            border-left: 4px solid var(--primary);
            border-radius: 12px;
            padding: 1.5rem;
            background: #ffffff;
            display: flex;
            align-items: center;
            justify-content: space-between;
            box-shadow: 0 4px 6px rgba(0,0,0,0.02);
        }

        .stat-card-title {
            font-size: 0.9rem;
            font-weight: 600;
            color: var(--text-muted);
            text-transform: uppercase;
            letter-spacing: 0.5px;
        }

        .stat-card-value {
            font-size: 2rem;
            font-weight: 800;
            margin-top: 5px;
            color: var(--text-color);
        }

        .stat-card-icon {
            font-size: 2.5rem;
            opacity: 0.2;
            color: var(--primary);
        }
    </style>
    <jsp:include page="/WEB-INF/views/components/dark-mode.jsp" />
</head>

<body>
    <div class="container-fluid">
        <div class="row">
            <jsp:include page="/WEB-INF/views/reporter/components/reporter-sidebar.jsp">
                <jsp:param name="activeMenu" value="analytics" />
            </jsp:include>

            <div class="col-md-9 col-lg-10 ms-auto main-content">
                <nav class="navbar navbar-expand-lg navbar-admin sticky-top">
                    <div class="container-fluid">
                        <h4 class="mb-0">Thống kê bài viết</h4>
                        <div class="navbar-nav ms-auto">
                            <span class="navbar-text">
                                <i class="fas fa-user-circle"></i> Xin chào, ${sessionScope.currentUser.fullname}
                            </span>
                        </div>
                    </div>
                </nav>

                <div class="container-fluid px-4">
                    <h2 class="page-title">Báo cáo hiệu suất bài viết</h2>

                    <!-- Thống kê tổng quan dạng thẻ -->
                    <div class="row mt-4">
                        <div class="col-md-4">
                            <div class="stat-card" style="border-left-color: #0d6efd;">
                                <div>
                                    <div class="stat-card-title">Tổng số bài viết</div>
                                    <div class="stat-card-value">${totalArticles}</div>
                                </div>
                                <i class="fas fa-file-alt stat-card-icon" style="color: #0d6efd;"></i>
                            </div>
                        </div>
                        <div class="col-md-4">
                            <div class="stat-card" style="border-left-color: #198754;">
                                <div>
                                    <div class="stat-card-title">Tổng lượt xem (Views)</div>
                                    <div class="stat-card-value">
                                        <fmt:formatNumber value="${totalViews}" type="number" />
                                    </div>
                                </div>
                                <i class="fas fa-eye stat-card-icon" style="color: #198754;"></i>
                            </div>
                        </div>
                        <div class="col-md-4">
                            <div class="stat-card" style="border-left-color: #ffc107;">
                                <div>
                                    <div class="stat-card-title">Tổng bình luận</div>
                                    <div class="stat-card-value">${totalComments}</div>
                                </div>
                                <i class="fas fa-comments stat-card-icon" style="color: #ffc107;"></i>
                            </div>
                        </div>
                    </div>

                    <!-- Khu vực Đồ họa trực quan -->
                    <div class="row mt-4">
                        <!-- Đồ thị lượt xem -->
                        <div class="col-lg-6">
                            <div class="card">
                                <div class="card-header">
                                    <i class="fas fa-chart-bar"></i> Top 5 bài viết xem nhiều nhất
                                </div>
                                <div class="card-body">
                                    <canvas id="viewsChart" style="max-height: 300px;"></canvas>
                                </div>
                            </div>
                        </div>
                        <!-- Đồ thị bình luận -->
                        <div class="col-lg-6">
                            <div class="card">
                                <div class="card-header">
                                    <i class="fas fa-chart-pie"></i> Top 5 bài viết bình luận nhiều nhất
                                </div>
                                <div class="card-body">
                                    <canvas id="commentsChart" style="max-height: 300px;"></canvas>
                                </div>
                            </div>
                        </div>
                    </div>

                    <!-- Bảng dữ liệu thống kê chi tiết -->
                    <div class="card mt-4">
                        <div class="card-header">
                            <i class="fas fa-table"></i> Chi tiết bài viết nổi bật
                        </div>
                        <div class="card-body p-0">
                            <div class="table-responsive">
                                <table class="table table-hover table-striped mb-0">
                                    <thead>
                                        <tr class="table-dark">
                                            <th class="ps-3" style="width: 50%;">Tiêu đề bài viết</th>
                                            <th class="text-center" style="width: 25%;">Lượt xem</th>
                                            <th class="text-center" style="width: 25%;">Lượt bình luận</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <c:choose>
                                            <c:when test="${empty topViews}">
                                                <tr>
                                                    <td colspan="3" class="text-center text-muted py-4">Chưa có dữ liệu bài viết</td>
                                                </tr>
                                            </c:when>
                                            <c:otherwise>
                                                <c:forEach var="news" items="${topViews}">
                                                    <tr>
                                                        <td class="ps-3 fw-semibold">${news.title}</td>
                                                        <td class="text-center">
                                                            <fmt:formatNumber value="${news.viewCount}" type="number" />
                                                        </td>
                                                        <td class="text-center text-muted">
                                                            <%-- Tìm kiếm trong topComments để lấy số bình luận nếu có --%>
                                                            <c:set var="cmtCount" value="0" />
                                                            <c:forEach var="item" items="${topComments}">
                                                                <c:if test="${item.id == news.id}">
                                                                    <c:set var="cmtCount" value="${item.comments}" />
                                                                </c:if>
                                                            </c:forEach>
                                                            ${cmtCount}
                                                        </td>
                                                    </tr>
                                                </c:forEach>
                                            </c:otherwise>
                                        </c:choose>
                                    </tbody>
                                </table>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- Hidden elements containing raw data to safely pass to Chart.js without EL function errors or quote escaping bugs -->
    <div id="raw-chart-data" class="d-none">
        <c:forEach var="n" items="${topViews}">
            <div class="raw-view-item" data-title="<c:out value="${n.title}"/>" data-views="${n.viewCount}"></div>
        </c:forEach>
        <c:forEach var="c" items="${topComments}">
            <div class="raw-comment-item" data-title="<c:out value="${c.title}"/>" data-comments="${c.comments}"></div>
        </c:forEach>
    </div>

    <!-- Script Chart.js -->
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
    <script>
        // Chuẩn bị dữ liệu cho Chart.js
        const viewsLabels = [];
        const viewsData = [];
        document.querySelectorAll('.raw-view-item').forEach(el => {
            const title = el.dataset.title || '';
            const shortTitle = title.length > 25 ? title.substring(0, 22) + '...' : title;
            viewsLabels.push(shortTitle);
            viewsData.push(parseInt(el.dataset.views) || 0);
        });

        const commentsLabels = [];
        const commentsData = [];
        document.querySelectorAll('.raw-comment-item').forEach(el => {
            const title = el.dataset.title || '';
            const shortTitle = title.length > 25 ? title.substring(0, 22) + '...' : title;
            commentsLabels.push(shortTitle);
            commentsData.push(parseInt(el.dataset.comments) || 0);
        });

        // Vẽ biểu đồ Lượt xem (Bar Chart)
        const ctxViews = document.getElementById('viewsChart').getContext('2d');
        new Chart(ctxViews, {
            type: 'bar',
            data: {
                labels: viewsLabels,
                datasets: [{
                    label: 'Lượt xem',
                    data: viewsData,
                    backgroundColor: '#0d6efd',
                    borderColor: '#0b5ed7',
                    borderWidth: 1,
                    borderRadius: 5
                }]
            },
            options: {
                responsive: true,
                maintainAspectRatio: false,
                scales: {
                    y: {
                        beginAtZero: true
                    }
                },
                plugins: {
                    legend: {
                        display: false
                    }
                }
            }
        });

        // Vẽ biểu đồ Bình luận (Doughnut Chart)
        const ctxComments = document.getElementById('commentsChart').getContext('2d');
        new Chart(ctxComments, {
            type: 'doughnut',
            data: {
                labels: commentsLabels,
                datasets: [{
                    label: 'Bình luận',
                    data: commentsData,
                    backgroundColor: [
                        '#ffc107',
                        '#198754',
                        '#0dcaf0',
                        '#0d6efd',
                        '#6f42c1'
                    ]
                }]
            },
            options: {
                responsive: true,
                maintainAspectRatio: false,
                plugins: {
                    legend: {
                        position: 'bottom'
                    }
                }
            }
        });
    </script>
</body>

</html>
