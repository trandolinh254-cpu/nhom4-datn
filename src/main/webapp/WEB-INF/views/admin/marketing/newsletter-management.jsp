<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
            <!DOCTYPE html>
            <html lang="vi">

            <head>
                <meta charset="UTF-8">
                <meta name="viewport" content="width=device-width, initial-scale=1.0">
                <title>Quản lý Newsletter - XYZ Admin Premium</title>

                <link rel="preconnect" href="https://fonts.googleapis.com">
                <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
                <link href="https://fonts.googleapis.com/css2?family=Be+Vietnam+Pro:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">
                
                <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
                <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">

                <style>
/* ===========================
   CUSTOM VARIABLES (Đồng bộ với Dashboard)
=========================== */
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

/* ===========================
   SIDEBAR
=========================== */
.sidebar {
    height: 100vh;
    background: #ffffff;
    border-right: 1px solid #eaeaea;
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
    text-align: center;
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
}

.sidebar .nav-link i { width: 24px; text-align: center; font-size: 1.1rem; }
.sidebar .nav-link:hover { background: #f8f9fa; color: var(--primary); transform: translateX(5px); }
.sidebar .nav-link.active { background: var(--primary); color: #ffffff !important; font-weight: 600; transform: none; }
.sidebar hr { background-color: #eaeaea; opacity: 1; }

/* ===========================
   MAIN CONTENT & NAVBAR
=========================== */
.main-content { padding-left: 0; padding-top: 0; }

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

.navbar-admin h4 { color: var(--text-color); font-weight: 700; font-size: 1.5rem; }

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
.navbar-text i { color: var(--primary); font-size: 1.2rem; }

/* ===========================
   PAGE TITLE
=========================== */
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

/* ===========================
   CARDS
=========================== */
.card {
    border: 1px solid #eaeaea;
    border-radius: 12px;
    background: #ffffff;
    box-shadow: 0 2px 10px rgba(0,0,0,0.05);
    margin-bottom: 2rem;
    overflow: hidden;
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
.card-header i { color: var(--primary); }

/* ===========================
   STATS CARDS
=========================== */
.stat-card {
    border: 1px solid #eaeaea;
    border-radius: 12px;
    background: #ffffff;
    padding: 1.8rem;
    color: var(--text-color);
    position: relative;
    overflow: hidden;
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
    background: rgba(0,0,0,0.02);
    border-radius: 50%;
    pointer-events: none;
}

.stat-card:hover { transform: translateY(-4px); box-shadow: 0 8px 20px rgba(0,0,0,0.08); background: #ffffff; }
.stat-card h2 { font-weight: 700; font-size: 2.2rem; margin-bottom: 5px; color: var(--primary); }
.stat-card h5 { font-size: 0.9rem; opacity: 0.9; text-transform: uppercase; letter-spacing: 1px; font-weight: 500; }
.stat-icon-right { font-size: 3rem; opacity: 0.1; position: absolute; right: 20px; bottom: 20px; color: var(--primary); }


/* ===========================
   TABLE
=========================== */
.table { margin-bottom: 0; vertical-align: middle; color: var(--text-color); }
.table thead th { background: #f8f9fa; color: var(--text-color); font-weight: 600; text-transform: uppercase; font-size: 0.75rem; letter-spacing: 0.5px; border-bottom: 1px solid #eaeaea; padding: 1rem; }
.table tbody td { padding: 1rem; color: var(--text-color); border-bottom: 1px solid #eaeaea; font-size: 0.95rem; }
.table tbody tr:hover { background-color: #f8f9fa; }
.table tbody tr:last-child td { border-bottom: none; }

/* Badges */
.badge { padding: 0.5em 0.8em; font-weight: 500; border-radius: 6px; }
.badge.bg-success { background-color: rgba(16,185,129,0.1) !important; color: #059669; border: 1px solid #10b981; }
.badge.bg-secondary { background-color: #f8f9fa !important; color: var(--text-color); border: 1px solid #eaeaea; }

/* Buttons */
.btn-group .btn-sm { border-radius: 6px !important; font-weight: 500; padding: 6px 10px; }
.btn-outline-warning { color: #d97706; border-color: rgba(217,119,6,0.5); background: #ffffff; }
.btn-outline-warning:hover { background: #f59e0b; color: white; border-color:#f59e0b; }
.btn-outline-success { color: #059669; border-color: rgba(5,150,105,0.5); background: #ffffff; }
.btn-outline-success:hover { background: #10b981; color: white; border-color:#10b981; }
.btn-outline-danger { color: #dc2626; border-color: rgba(220,38,38,0.5); background: #ffffff; }
.btn-outline-danger:hover { background: #ef4444; color: white; border-color:#ef4444; }

/* Alerts */
.alert { border-radius: 8px; border: 1px solid #eaeaea; background: #ffffff; box-shadow: 0 2px 10px rgba(0,0,0,0.05); font-weight: 500; color: var(--text-color); }
.alert-success { border-left: 4px solid #10b981; }
.alert-danger { border-left: 4px solid #ef4444; }

/* Modal */
.modal-content { border-radius: 12px !important; background: #ffffff; border: 1px solid #eaeaea; color: var(--text-color); }
.modal-header { background: #f8f9fa; color: var(--text-color); font-weight: 600; border-radius: 12px 12px 0 0 !important; border-bottom: 1px solid #eaeaea; }
.modal-footer { border-radius: 0 0 12px 12px !important; background: transparent; border-top: 1px solid #eaeaea; }

                </style>
                <jsp:include page="/WEB-INF/views/components/dark-mode.jsp" />
            </head>

            <body>
                <div class="container-fluid">
                    <div class="row">
                        <jsp:include page="/WEB-INF/views/admin/components/admin-sidebar.jsp">
                <jsp:param name="activeMenu" value="newsletters" />
            </jsp:include>

            <div class="col-md-9 col-lg-10 ms-auto main-content">
                            <nav class="navbar navbar-expand-lg navbar-admin sticky-top">
                                <div class="container-fluid">
                                    <h4 class="mb-0">Quản lý Newsletter</h4>
                                    <div class="navbar-nav ms-auto">
                                        <span class="navbar-text">
                                            <i class="fas fa-user-circle"></i> Xin chào, ${sessionScope.currentUser.fullname}
                                        </span>
                                    </div>
                                </div>
                            </nav>

                            <div class="container-fluid px-4">
                                <h2 class="page-title">Quản lý Newsletter</h2>

                                <c:if test="${sessionScope.successMessage != null}">
                                    <div class="alert alert-success alert-dismissible fade show d-flex align-items-center" role="alert">
                                        <i class="fas fa-check-circle me-2 fs-5"></i> ${sessionScope.successMessage}
                                        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                                    </div>
                                    <c:remove var="successMessage" scope="session" />
                                </c:if>

                                <c:if test="${sessionScope.errorMessage != null}">
                                    <div class="alert alert-danger alert-dismissible fade show d-flex align-items-center" role="alert">
                                        <i class="fas fa-exclamation-circle me-2 fs-5"></i> ${sessionScope.errorMessage}
                                        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                                    </div>
                                    <c:remove var="errorMessage" scope="session" />
                                </c:if>

                                <div class="row g-4 pb-4">
                                    <div class="col-md-6">
                                        <div class="stat-card primary">
                                            <div class="d-flex flex-column position-relative z-1">
                                                <h2 class="mb-0">${totalNewsletters}</h2>
                                                <h5 class="mb-0">Tổng số đăng ký</h5>
                                            </div>
                                            <i class="fas fa-envelope stat-icon-right"></i>
                                        </div>
                                    </div>
                                    <div class="col-md-6">
                                        <div class="stat-card success">
                                            <div class="d-flex flex-column position-relative z-1">
                                                <h2 class="mb-0">${activeNewsletters}</h2>
                                                <h5 class="mb-0">Đang hoạt động</h5>
                                            </div>
                                            <i class="fas fa-check-circle stat-icon-right"></i>
                                        </div>
                                    </div>

                                    <div class="col-12">
                                        <div class="card">
                                            <div class="card-header">
                                                <h5 class="mb-0">
                                                    <i class="fas fa-list"></i> Danh sách đăng ký Newsletter
                                                </h5>
                                            </div>
                                            <div class="card-body p-0">
                                                <c:choose>
                                                    <c:when test="${not empty newsletters}">
                                                        <div class="table-responsive">
                                                            <table class="table table-hover align-middle">
                                                                <thead>
                                                                    <tr>
                                                                        <th>Email</th>
                                                                        <th>Trạng thái</th>
                                                                        <th class="text-end">Thao tác</th>
                                                                    </tr>
                                                                </thead>
                                                                <tbody>
                                                                    <c:forEach var="newsletter" items="${newsletters}">
                                                                        <tr>
                                                                            <td>
                                                                                <i class="fas fa-envelope-open-text me-2 text-muted"></i>
                                                                                ${newsletter.email}
                                                                            </td>
                                                                            <td>
                                                                                <c:choose>
                                                                                    <c:when
                                                                                        test="${newsletter.enabled}">
                                                                                        <span class="badge bg-success">
                                                                                            <i class="fas fa-check"></i>
                                                                                            Hoạt động
                                                                                        </span>
                                                                                    </c:when>
                                                                                    <c:otherwise>
                                                                                        <span
                                                                                            class="badge bg-secondary">
                                                                                            <i class="fas fa-times"></i>
                                                                                            Đã hủy
                                                                                        </span>
                                                                                    </c:otherwise>
                                                                                </c:choose>
                                                                            </td>
                                                                            <td class="text-end">
                                                                                <div class="btn-group" role="group">
                                                                                    <c:choose>
                                                                                        <c:when
                                                                                            test="${newsletter.enabled}">
                                                                                            <button type="button"
                                                                                                class="btn btn-sm btn-outline-warning"
                                                                                                onclick="toggleNewsletter('${newsletter.email}', false)"
                                                                                                title="Vô hiệu hóa">
                                                                                                <i
                                                                                                    class="fas fa-pause"></i>
                                                                                            </button>
                                                                                        </c:when>
                                                                                        <c:otherwise>
                                                                                            <button type="button"
                                                                                                class="btn btn-sm btn-outline-success"
                                                                                                onclick="toggleNewsletter('${newsletter.email}', true)"
                                                                                                title="Kích hoạt">
                                                                                                <i
                                                                                                    class="fas fa-play"></i>
                                                                                            </button>
                                                                                        </c:otherwise>
                                                                                    </c:choose>
                                                                                    <button type="button"
                                                                                        class="btn btn-sm btn-outline-danger"
                                                                                        onclick="deleteNewsletter('${newsletter.email}')"
                                                                                        title="Xóa">
                                                                                        <i class="fas fa-trash"></i>
                                                                                    </button>
                                                                                </div>
                                                                            </td>
                                                                        </tr>
                                                                    </c:forEach>
                                                                </tbody>
                                                            </table>
                                                        </div>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <div class="text-center py-5">
                                                            <i class="fas fa-envelope fa-4x mb-3" style="color: var(--accent); opacity: 0.5;"></i>
                                                            <h6 class="text-muted fw-normal">Chưa có đăng ký Newsletter nào</h6>
                                                            <p class="text-muted">Người dùng có thể đăng ký Newsletter từ trang chủ</p>
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

                <div class="modal fade" id="deleteModal" tabindex="-1">
                    <div class="modal-dialog">
                        <div class="modal-content">
                            <div class="modal-header">
                                <h5 class="modal-title"><i class="fas fa-exclamation-triangle me-2"></i> Xác nhận xóa</h5>
                                <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                            </div>
                            <div class="modal-body">
                                <p class="lead">Bạn có chắc chắn muốn xóa email **"<span id="deleteEmail" class="fw-bold"></span>"** khỏi danh sách Newsletter?</p>
                                <p class="text-danger fw-bold"><i class="fas fa-exclamation-circle me-1"></i> Hành động này không thể hoàn tác!</p>
                            </div>
                            <div class="modal-footer">
                                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Hủy</button>
                                <button type="button" class="btn btn-danger" id="confirmDelete">Xóa</button>
                            </div>
                        </div>
                    </div>
                </div>

                <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>

                <script>
                    function toggleNewsletter(email, enabled) {
                        const form = document.createElement('form');
                        form.method = 'POST';
                        form.action = '${pageContext.request.contextPath}/admin/newsletters/toggle';

                        const emailInput = document.createElement('input');
                        emailInput.type = 'hidden';
                        emailInput.name = 'email';
                        emailInput.value = email;

                        const enabledInput = document.createElement('input');
                        enabledInput.type = 'hidden';
                        enabledInput.name = 'enabled';
                        enabledInput.value = enabled;

                        form.appendChild(emailInput);
                        form.appendChild(enabledInput);
                        document.body.appendChild(form);
                        form.submit();
                    }

                    function deleteNewsletter(email) {
                        document.getElementById('deleteEmail').textContent = email;
                        document.getElementById('confirmDelete').onclick = function () {
                            const form = document.createElement('form');
                            form.method = 'POST';
                            form.action = '${pageContext.request.contextPath}/admin/newsletters/delete';

                            const emailInput = document.createElement('input');
                            emailInput.type = 'hidden';
                            emailInput.name = 'email';
                            emailInput.value = email;

                            form.appendChild(emailInput);
                            document.body.appendChild(form);
                            form.submit();
                        };

                        const modal = new bootstrap.Modal(document.getElementById('deleteModal'));
                        modal.show();
                    }
                </script>
            </body>

            </html>