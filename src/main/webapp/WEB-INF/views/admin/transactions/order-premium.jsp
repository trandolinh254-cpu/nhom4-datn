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
                <jsp:param name="activeMenu" value="orders_premium" />
            </jsp:include>

            <div class="col-md-9 col-lg-10 ms-auto main-content">
                <nav class="navbar navbar-expand-lg navbar-admin sticky-top">
                    <div class="container-fluid">
                        <h4 class="mb-0">Quản lý Đăng ký Premium</h4>
                        <div class="navbar-nav ms-auto">
                            <span class="user-profile-badge">
                                <i class="fas fa-user-circle"></i> Xin chào, ${sessionScope.currentUser.fullname}
                            </span>
                        </div>
                    </div>
                </nav>

                <div class="container-fluid px-4 pb-4">
                    <c:if test="${not empty sessionScope.successMessage}">
                        <div class="alert alert-success alert-dismissible fade show d-flex align-items-center" role="alert">
                            <i class="fas fa-check-circle me-2 fs-5"></i> ${sessionScope.successMessage}
                            <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                        </div>
                        <c:remove var="successMessage" scope="session"/>
                    </c:if>
                    
                    <div class="row">
                        <div class="col-12">
                            <div class="card">
                                <div class="card-header">
                                    <h5 class="mb-0"><i class="fas fa-crown"></i> Danh sách Premium</h5>
                                </div>
                                <div class="card-body p-0">
                                    <div class="table-responsive">
                                        <table class="table table-hover align-middle">
                                            <thead class="table-light">
                                                <tr>
                                                    <th>Mã ĐK</th>
                                                    <th>Khách hàng</th>
                                                    <th>Gói Premium</th>
                                                    <th>Thời gian</th>
                                                    <th>Trạng thái</th>
                                                    <th>Hành động</th>
                                                </tr>
                                            </thead>
                                            <tbody>
                                                <c:forEach var="order" items="${orders}">
                                                    <tr>
                                                        <td><span class="badge bg-secondary">#${order.id}</span></td>
                                                        <td>
                                                            <div class="fw-bold">${order.fullName}</div>
                                                            <div class="text-muted small">${order.email}</div>
                                                            <div class="text-muted small">${order.phone}</div>
                                                        </td>
                                                        <td>
                                                            <span class="badge bg-primary">${order.packageDisplayName}</span>
                                                        </td>
                                                        <td>
                                                            <div class="small">
                                                                <span class="text-muted">Bắt đầu:</span> 
                                                                <fmt:formatDate value="${order.startDate != null ? order.startDate : order.createdDate}" pattern="dd/MM/yyyy"/>
                                                            </div>
                                                            <div class="small">
                                                                <span class="text-muted">Kết thúc:</span> 
                                                                <c:choose>
                                                                    <c:when test="${order.endDate != null}">
                                                                        <fmt:formatDate value="${order.endDate}" pattern="dd/MM/yyyy"/>
                                                                    </c:when>
                                                                    <c:otherwise>
                                                                        <span class="fst-italic text-black-50">Chưa kích hoạt</span>
                                                                    </c:otherwise>
                                                                </c:choose>
                                                            </div>
                                                        </td>
                                                        <td>
                                                            <c:choose>
                                                                <c:when test="${order.status == 'pending'}"><span class="badge bg-warning text-dark">Chờ thanh toán</span></c:when>
                                                                <c:when test="${order.status == 'active' || order.status == 'confirmed'}"><span class="badge bg-success">Đang hoạt động</span></c:when>
                                                                <c:when test="${order.status == 'expired'}"><span class="badge bg-secondary">Hết hạn</span></c:when>
                                                                <c:when test="${order.status == 'cancelled'}"><span class="badge bg-danger">Đã hủy</span></c:when>
                                                                <c:otherwise><span class="badge bg-secondary">${order.status}</span></c:otherwise>
                                                            </c:choose>
                                                        </td>
                                                        <td>
                                                            <button class="btn btn-sm btn-outline-info" data-bs-toggle="modal" data-bs-target="#txModal${order.id}" title="Xem chi tiết giao dịch">
                                                                <i class="fa-solid fa-eye"></i>
                                                            </button>

                                                            <!-- Modal Chi tiết giao dịch -->
                                                            <div class="modal fade" id="txModal${order.id}" tabindex="-1" aria-hidden="true">
                                                              <div class="modal-dialog modal-dialog-centered">
                                                                <div class="modal-content">
                                                                  <div class="modal-body p-0">
                                                                    <!-- Header thanh lịch -->
                                                                    <div class="bg-primary text-white p-4 text-center rounded-top">
                                                                       <i class="fa-solid fa-circle-check display-4 mb-2"></i>
                                                                       <h4 class="mb-0 fw-bold">Giao dịch thành công</h4>
                                                                       <p class="text-white-50 small mb-0">Dịch vụ Premium AI đã kích hoạt</p>
                                                                    </div>
                                                                    
                                                                    <!-- Nội dung biên lai -->
                                                                    <div class="p-4 bg-light">
                                                                      <div class="bg-white rounded-3 shadow-sm p-4 border border-light">
                                                                        <div class="d-flex justify-content-between mb-3 pb-3 border-bottom" style="border-bottom-style: dashed !important;">
                                                                           <span class="text-muted small text-uppercase">Khách hàng</span>
                                                                           <span class="fw-bold text-dark">${order.fullName}</span>
                                                                        </div>
                                                                        <div class="d-flex justify-content-between mb-3 pb-3 border-bottom" style="border-bottom-style: dashed !important;">
                                                                           <span class="text-muted small text-uppercase">Gói Đăng ký</span>
                                                                           <span class="fw-bold text-primary">${order.packageDisplayName}</span>
                                                                        </div>
                                                                        <div class="d-flex justify-content-between mb-3 pb-3 border-bottom" style="border-bottom-style: dashed !important;">
                                                                           <span class="text-muted small text-uppercase">Số tiền</span>
                                                                           <span class="fw-bold fs-5 text-danger"><fmt:formatNumber value="${order.totalAmount}" type="currency" currencySymbol="VND" maxFractionDigits="0"/></span>
                                                                        </div>
                                                                        
                                                                        <c:set var="tx" value="${txMap[order.id]}" />
                                                                        <c:if test="${tx != null}">
                                                                            <div class="d-flex justify-content-between mb-3 pb-3 border-bottom" style="border-bottom-style: dashed !important;">
                                                                               <span class="text-muted small text-uppercase">Hình thức</span>
                                                                               <span>
                                                                                    <c:choose>
                                                                                        <c:when test="${tx.paymentMethod == 'bank_transfer'}"><span class="badge bg-info text-dark"><i class="fas fa-qrcode"></i> VietQR</span></c:when>
                                                                                        <c:when test="${tx.paymentMethod == 'cod'}"><span class="badge bg-secondary"><i class="fas fa-money-bill-wave"></i> Thu tiền mặt</span></c:when>
                                                                                        <c:otherwise><span class="badge bg-secondary">${tx.paymentMethod}</span></c:otherwise>
                                                                                    </c:choose>
                                                                               </span>
                                                                            </div>
                                                                            <div class="d-flex justify-content-between mb-3 pb-3 border-bottom" style="border-bottom-style: dashed !important;">
                                                                                <span class="text-muted small text-uppercase">Ngày ghi nhận</span>
                                                                                <span class="fw-bold text-dark"><fmt:formatDate value="${tx.createdDate}" pattern="HH:mm - dd/MM/yyyy"/></span>
                                                                            </div>
                                                                            <div class="d-flex justify-content-between">
                                                                                <span class="text-muted small text-uppercase">Trạng thái</span>
                                                                                <span>
                                                                                    <c:choose>
                                                                                        <c:when test="${tx.status == 'success'}"><span class="badge bg-success px-3 py-2 rounded-pill">Thành công</span></c:when>
                                                                                        <c:when test="${tx.status == 'failed'}"><span class="badge bg-danger px-3 py-2 rounded-pill">Thất bại</span></c:when>
                                                                                        <c:otherwise><span class="badge bg-warning text-dark px-3 py-2 rounded-pill">Đang xử lý</span></c:otherwise>
                                                                                    </c:choose>
                                                                                </span>
                                                                            </div>
                                                                        </c:if>
                                                                        <c:if test="${tx == null}">
                                                                            <!-- Xử lý tinh tế khi không có data giao dịch -->
                                                                            <div class="d-flex justify-content-between mb-3 pb-3 border-bottom" style="border-bottom-style: dashed !important;">
                                                                               <span class="text-muted small text-uppercase">Hình thức</span>
                                                                               <span class="badge bg-secondary text-white"><i class="fas fa-history"></i> Dữ liệu cũ</span>
                                                                            </div>
                                                                            <div class="d-flex justify-content-between mb-3 pb-3 border-bottom" style="border-bottom-style: dashed !important;">
                                                                                <span class="text-muted small text-uppercase">Ngày ghi nhận</span>
                                                                                <span class="fw-bold text-dark"><fmt:formatDate value="${order.createdDate}" pattern="HH:mm - dd/MM/yyyy"/></span>
                                                                            </div>
                                                                            <div class="d-flex justify-content-between">
                                                                                <span class="text-muted small text-uppercase">Trạng thái</span>
                                                                                <span class="badge bg-success px-3 py-2 rounded-pill">Đã kích hoạt</span>
                                                                            </div>
                                                                        </c:if>
                                                                      </div>
                                                                    </div>
                                                                  </div>
                                                                  <div class="modal-footer">
                                                                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Đóng</button>
                                                                  </div>
                                                                </div>
                                                              </div>
                                                            </div>
                                                        </td>
                                                    </tr>
                                                </c:forEach>
                                                <c:if test="${empty orders}">
                                                    <tr><td colspan="6" class="text-center py-4">Chưa có đăng ký Premium nào.</td></tr>
                                                </c:if>
                                            </tbody>
                                        </table>
                                    </div>
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