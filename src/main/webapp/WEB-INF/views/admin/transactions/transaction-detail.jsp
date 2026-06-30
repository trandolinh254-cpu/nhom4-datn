<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Quản lý Hệ thống - Admin Dòng Chảy Tin Tức</title>

    <!-- FIX 1: Copy y hệt bộ Font của Dashboard -->
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Be+Vietnam+Pro:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    
    <!-- FIX 2: Phải dùng chung bản Bootstrap 5.1.3 của Dashboard mới không bị lệch -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <link href="${pageContext.request.contextPath}/css/admin.css" rel="stylesheet">
    <jsp:include page="/WEB-INF/views/components/dark-mode.jsp" />

    <!-- FIX 3: Bê ĐẦY ĐỦ cấu trúc CSS (cả Sidebar + Main Content + Font) -->
    <style>
        :root {
            --primary: #006389;
            --text-color: #333333;
            --text-muted: #6c757d;
        }
        body {
            font-family: 'Inter', 'Be Vietnam Pro', sans-serif; /* FIX: Ép font chữ chuẩn */
            background: #f8f9fa;
            color: var(--text-color);
            overflow-x: hidden;
            min-height: 100vh;
        }

        /* ======== SIDEBAR ======== */
        .sidebar { /* FIX: Thêm style sidebar bị thiếu để nó hiển thị đúng màu */
            background: #ffffff;
            border-right: 1px solid #eaeaea;
            min-height: 100vh;
            box-shadow: 2px 0 10px rgba(0,0,0,0.05);
            z-index: 1000;
            color: var(--text-color);
        }
        .sidebar h5 { font-weight: 700; letter-spacing: 0.5px; color: var(--text-color); padding-bottom: 20px; border-bottom: 1px solid #eaeaea; margin-bottom: 20px; }
        .sidebar .nav-link { color: var(--text-color); padding: 14px 20px; margin-bottom: 8px; border-radius: 8px; font-size: 0.95rem; font-weight: 500; display: flex; align-items: center; gap: 12px; transition: all 0.3s ease; }
        .sidebar .nav-link i { width: 24px; text-align: center; font-size: 1.1rem; transition: transform 0.3s; }
        .sidebar .nav-link:hover { background: #f8f9fa; color: var(--primary); transform: translateX(5px); }
        .sidebar .nav-link.active { background: var(--primary); color: #ffffff !important; }
        .sidebar hr { background-color: #eaeaea; opacity: 1; }
        
        /* ======== MAIN CONTENT & NAVBAR ======== */
        .main-content {
            padding-left: 0; /* FIX: Reset padding để Navbar dóng thẳng cột bên trái */
        }
        .navbar-admin { background: #ffffff; padding: 1rem 2rem; box-shadow: 0 2px 10px rgba(0,0,0,0.05); margin-bottom: 2rem; border-bottom: 1px solid #eaeaea; }
        .navbar-admin h4 { color: var(--text-color); font-weight: 700; font-size: 1.5rem; }
        .user-profile-badge { background: #f8f9fa; padding: 8px 16px; border-radius: 50px; display: flex; align-items: center; gap: 10px; color: var(--text-color); font-weight: 600; border: 1px solid #eaeaea; }
        .user-profile-badge i { color: var(--primary); font-size: 1.2rem; }
        
        /* ======== CARDS & TABLES ======== */
        .card { border: 1px solid #eaeaea; border-radius: 12px; background: #ffffff; box-shadow: 0 2px 10px rgba(0,0,0,0.05); margin-bottom: 2rem; color: var(--text-color); }
        .card-header { background: #ffffff; border-bottom: 1px solid #eaeaea; padding: 1.5rem; border-radius: 12px 12px 0 0 !important; }
        .card-header h5 { color: var(--text-color); font-weight: 700; font-size: 1.1rem; margin: 0; display: flex; align-items: center; gap: 10px; }
        .card-header h5 i { color: var(--primary); }
        .table { margin-bottom: 0; vertical-align: middle; color: var(--text-color); }
        .table thead th { background: #f8f9fa; color: var(--text-color); font-weight: 600; text-transform: uppercase; font-size: 0.75rem; letter-spacing: 0.5px; border-bottom: 1px solid #eaeaea; padding: 1rem; }
        .table tbody td { padding: 1rem; color: var(--text-color); border-bottom: 1px solid #eaeaea; font-size: 0.95rem; }
        .table tbody tr:hover { background-color: #f8fafc; }
        .table tbody tr:last-child td { border-bottom: none; }
        .badge { padding: 0.5em 0.8em; font-weight: 500; border-radius: 6px; }
        .badge.bg-secondary { background-color: #e2e8f0 !important; color: #475569; }
        .badge.bg-warning { background-color: #fef3c7 !important; color: #b45309; }

        /* Mở rộng cho file Chi tiết giao dịch */
        .detail-label { font-weight: 600; color: var(--text-color); margin-bottom: 0.2rem; }
        .detail-value { font-size: 1.1rem; margin-bottom: 1rem; }
    </style>
</head>
<body>
    <div class="container-fluid">
        <div class="row">
            <jsp:include page="/WEB-INF/views/admin/components/admin-sidebar.jsp">
                <jsp:param name="activeMenu" value="orders_transactions" />
            </jsp:include>

            <div class="col-md-9 col-lg-10 ms-auto main-content">
                <nav class="navbar navbar-expand-lg navbar-admin sticky-top">
                    <div class="container-fluid">
                        <h4 class="mb-0">
                            <a href="${pageContext.request.contextPath}/admin/orders/transactions" class="text-decoration-none text-muted me-2">
                                <i class="fas fa-arrow-left"></i>
                            </a>
                            Chi tiết Giao dịch #${transaction.id}
                        </h4>
                        <div class="navbar-nav ms-auto">
                            <span class="user-profile-badge">
                                <i class="fas fa-user-circle"></i> Xin chào, ${sessionScope.currentUser.fullname}
                            </span>
                        </div>
                    </div>
                </nav>

                <div class="container-fluid px-4 pb-4">
                    <div class="row g-4">
                        <div class="col-md-6">
                            <div class="card h-100">
                                <div class="card-header bg-light">
                                    <h5 class="mb-0"><i class="fas fa-info-circle me-2"></i>Thông tin Giao dịch</h5>
                                </div>
                                <div class="card-body">
                                    <div class="row">
                                        <div class="col-sm-6">
                                            <div class="detail-label">Mã giao dịch</div>
                                            <div class="detail-value text-primary fw-bold">#${transaction.id}</div>
                                        </div>
                                        <div class="col-sm-6">
                                            <div class="detail-label">Mã đơn hàng liên kết</div>
                                            <div class="detail-value">
                                                <c:choose>
                                                    <c:when test="${transaction.orderId != null}">#${transaction.orderId}</c:when>
                                                    <c:otherwise><span class="text-muted">Không có</span></c:otherwise>
                                                </c:choose>
                                            </div>
                                        </div>
                                        <div class="col-sm-6">
                                            <div class="detail-label">Ngày thanh toán</div>
                                            <div class="detail-value"><fmt:formatDate value="${transaction.createdDate}" pattern="dd/MM/yyyy HH:mm:ss"/></div>
                                        </div>
                                        <div class="col-sm-6">
                                            <div class="detail-label">Số tiền</div>
                                            <div class="detail-value text-success fw-bold fs-4"><fmt:formatNumber value="${transaction.amount}" pattern="#,###"/> đ</div>
                                        </div>
                                        <div class="col-sm-6">
                                            <div class="detail-label">Phương thức thanh toán</div>
                                            <div class="detail-value">
                                                <c:choose>
                                                    <c:when test="${transaction.paymentMethod == 'bank_transfer'}">Chuyển khoản ngân hàng</c:when>
                                                    <c:when test="${transaction.paymentMethod == 'e_wallet'}">Ví điện tử (Momo/ZaloPay)</c:when>
                                                    <c:when test="${transaction.paymentMethod == 'cod'}">Thanh toán tiền mặt khi nhận (COD)</c:when>
                                                    <c:otherwise>${transaction.paymentMethod}</c:otherwise>
                                                </c:choose>
                                            </div>
                                        </div>
                                        <div class="col-sm-6">
                                            <div class="detail-label">Trạng thái giao dịch</div>
                                            <div class="detail-value">
                                                <c:choose>
                                                    <c:when test="${transaction.status == 'success'}"><span class="badge bg-success fs-6">Thành công</span></c:when>
                                                    <c:when test="${transaction.status == 'failed'}"><span class="badge bg-danger fs-6">Thất bại</span></c:when>
                                                    <c:when test="${transaction.status == 'pending'}"><span class="badge bg-warning text-dark fs-6">Đang xử lý</span></c:when>
                                                    <c:otherwise><span class="badge bg-secondary fs-6">${transaction.status}</span></c:otherwise>
                                                </c:choose>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <div class="col-md-6">
                            <div class="card h-100">
                                <div class="card-header bg-light">
                                    <h5 class="mb-0"><i class="fas fa-user-tag me-2"></i>Thông tin Người dùng & Dịch vụ</h5>
                                </div>
                                <div class="card-body">
                                    <div class="row">
                                        <div class="col-sm-6">
                                            <div class="detail-label">Khách hàng</div>
                                            <div class="detail-value fw-bold">${transaction.userFullName != null ? transaction.userFullName : 'Khách vãng lai'}</div>
                                        </div>
                                        <div class="col-sm-6">
                                            <div class="detail-label">Tài khoản (Email)</div>
                                            <div class="detail-value">${transaction.userEmail != null ? transaction.userEmail : transaction.userId}</div>
                                        </div>
                                        <div class="col-sm-6">
                                            <div class="detail-label">Loại dịch vụ</div>
                                            <div class="detail-value">
                                                <c:choose>
                                                    <c:when test="${transaction.transactionType == 'premium'}"><span class="badge bg-warning text-dark fs-6"><i class="fas fa-crown"></i> Báo điện tử Premium</span></c:when>
                                                    <c:otherwise>${transaction.transactionType}</c:otherwise>
                                                </c:choose>
                                            </div>
                                        </div>
                                        <div class="col-sm-6">
                                            <div class="detail-label">Nội dung thao tác</div>
                                            <div class="detail-value">
                                                <c:choose>
                                                    <c:when test="${transaction.transactionAction == 'new'}">Mua mới</c:when>
                                                    <c:when test="${transaction.transactionAction == 'renew'}">Gia hạn gói</c:when>
                                                    <c:when test="${transaction.transactionAction == 'upgrade'}">Nâng cấp gói</c:when>
                                                    <c:when test="${transaction.transactionAction == 'refund'}">Hủy hoàn tiền</c:when>
                                                    <c:otherwise>${transaction.transactionAction}</c:otherwise>
                                                </c:choose>
                                            </div>
                                        </div>
                                    </div>

                                    <c:if test="${order != null}">
                                        <hr>
                                        <h6 class="text-primary mb-3"><i class="fas fa-box-open me-2"></i>Chi tiết gói đã đặt</h6>
                                        <div class="row">
                                            <div class="col-sm-6">
                                                <div class="detail-label">Gói đăng ký</div>
                                                <div class="detail-value">${order.packageDisplayName}</div>
                                            </div>

                                        </div>
                                    </c:if>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>