<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Khách hàng Đối tác - XYZ Admin</title>

    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Be+Vietnam+Pro:wght@300;400;500;600;700&display=swap" rel="stylesheet">

    <style>
        /* CSS CHUẨN ĐỒNG BỘ VỚI DASHBOARD.JSP */
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

        /* Thẻ Card dùng chung */
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

        /* Bảng dữ liệu chuẩn */
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
        
        /* Nút và Badge */
        .badge {
            padding: 0.5em 0.8em;
            font-weight: 500;
            border-radius: 6px;
        }
    </style>
</head>
<body>
    <div class="container-fluid">
        <div class="row">
            <%-- Sidebar chuẩn dark-theme --%>
            <jsp:include page="/WEB-INF/views/admin/components/admin-sidebar.jsp">
                <jsp:param name="activeMenu" value="ads_client_list" />
            </jsp:include>

            <div class="col-md-9 col-lg-10 ms-auto main-content">
                <nav class="navbar navbar-expand-lg navbar-admin sticky-top">
                    <div class="container-fluid">
                        <h4 class="mb-0">Danh sách Khách hàng</h4>
                    </div>
                </nav>

                <div class="container-fluid px-4 pb-4">
                    <div class="card">
                        <div class="card-header d-flex justify-content-between align-items-center">
                            <h5><i class="fas fa-handshake"></i> Đối tác & Khách hàng đã chạy QC</h5>
                            <button class="btn btn-sm btn-outline-success"><i class="fas fa-file-excel me-1"></i> Xuất Excel</button>
                        </div>
                        <div class="card-body p-0">
                            <div class="table-responsive">
                                <table class="table table-hover align-middle">
                                    <thead>
                                        <tr>
                                            <th width="30%">Khách hàng</th>
                                            <th>Thông tin liên hệ</th>
                                            <th class="text-center">Số lượng chiến dịch</th>
                                            <th class="text-end pe-4">Tổng chi tiêu (VNĐ)</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <c:forEach var="cus" items="${customers}">
                                            <tr>
                                                <td>
                                                    <div class="d-flex align-items-center">
                                                        <div class="bg-primary text-white rounded-circle d-flex justify-content-center align-items-center ms-2 me-3" style="width: 45px; height: 45px; font-weight: bold; font-size: 1.1rem;">
                                                            ${fn:substring(cus.fullname, 0, 1)}
                                                        </div>
                                                        <div class="fw-bold text-dark">${cus.fullname}</div>
                                                    </div>
                                                </td>
                                                <td>
                                                    <div class="text-muted mb-1"><i class="fas fa-envelope me-2"></i>${cus.email}</div>
                                                    <div class="text-muted"><i class="fas fa-phone-alt me-2"></i>${cus.phone}</div>
                                                </td>
                                                <td class="text-center">
                                                    <span class="badge bg-light text-dark border px-3 py-2 fs-6">${cus.totalCampaigns}</span>
                                                </td>
                                                <td class="text-end text-danger fw-bold pe-4" style="font-size: 1.1rem;">
                                                    <fmt:formatNumber value="${cus.totalSpent}" pattern="#,###"/>
                                                </td>
                                            </tr>
                                        </c:forEach>
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