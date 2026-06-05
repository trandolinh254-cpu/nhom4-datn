<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
            <!DOCTYPE html>
            <html lang="vi">

            <head>
                <meta charset="UTF-8">
                <meta name="viewport" content="width=device-width, initial-scale=1.0">
                <title>Quản lý chuyên mục - XYZ Admin Premium</title>

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
   SIDEBAR (Đồng bộ hoàn toàn với Dashboard)
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

.sidebar .nav-link i {
    width: 24px;
    text-align: center;
    font-size: 1.1rem;
}

/* Hiệu ứng Hover */
.sidebar .nav-link:hover {
    background: #f8f9fa;
    color: var(--primary);
    transform: translateX(5px);
}

/* Hiệu ứng Active */
.sidebar .nav-link.active {
    background: var(--primary);
    color: #ffffff !important;
    font-weight: 600;
    transform: none;
}

.sidebar hr {
    background-color: #eaeaea;
    opacity: 1;
}

/* ===========================
   NAVBAR (Sticky Header)
=========================== */
.main-content {
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
    padding-top: 20px; 
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
   ALERTS
=========================== */
.alert {
    border-radius: 12px;
    border: none;
    font-weight: 500;
    box-shadow: 0 4px 8px rgba(0,0,0,0.05);
    padding: 1rem 1.5rem;
}

.alert-success {
    background: #10b981; 
    color: var(--white);
}

.alert-danger {
    background: #d32f2f; 
    color: var(--white);
}

.alert .btn-close {
    filter: invert(1);
    opacity: 0.8;
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
    font-weight: 600;
    font-size: 16px;
    padding: 1.2rem 1.5rem;
    border-bottom: 1px solid #eaeaea;
    border-radius: 12px 12px 0 0 !important;
}

.card-header h5 i {
    color: var(--primary);
}
.card-body {
    padding: 1.5rem;
}

/* ===========================
   TABLE
=========================== */
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
    font-size: 0.8rem;
    letter-spacing: 0.5px;
    border-bottom: 1px solid #eaeaea;
    padding: 1rem 1.5rem; 
}

.table tbody td {
    padding: 1rem 1.5rem;
    color: var(--text-color);
    border-bottom: 1px solid #eaeaea;
    font-size: 0.95rem;
}

.table tbody tr:hover {
    background-color: #f8f9fa;
}

.table tbody tr:last-child td {
    border-bottom: none;
}

/* Style cho <code> trong bảng */
code {
    font-size: 0.9em;
    color: var(--primary);
    background-color: #f1f5f9;
    padding: 2px 6px;
    border-radius: 4px;
    font-weight: 600;
}

/* ===========================
   FORM & INPUTS
=========================== */
.form-control {
    border-radius: 8px !important;
    border: 1px solid #eaeaea;
    background-color: #ffffff;
    padding: 10px 14px;
    color: var(--text-color);
}

.form-control:focus {
    background-color: #ffffff;
    border-color: var(--primary);
    box-shadow: 0 0 0 0.2rem rgba(0,99,137,0.25);
    color: var(--text-color);
}

/* ===========================
   BUTTONS
=========================== */
.btn {
    border-radius: 8px !important;
    font-weight: 600;
    padding: 10px 18px;
    transition: all 0.3s ease;
}

.btn-primary {
    background: var(--primary) !important;
    border: none;
    color: #ffffff !important;
}

.btn-primary:hover {
    background: #004c6b !important;
    color: #ffffff !important;
}

.btn-danger {
    background: #d32f2f;
    border: none;
}

.btn-danger:hover {
    background: #b71c1c;
}

/* Button Outlines in Table */
.table .btn-outline-primary {
    color: var(--primary);
    border-color: var(--primary);
    padding: 6px 10px;
    font-weight: 500;
}

.table .btn-outline-primary:hover {
    background: var(--primary);
    color: var(--white);
}

.table .btn-outline-danger {
    color: #d32f2f;
    border-color: #d32f2f;
    padding: 6px 10px;
    font-weight: 500;
}

.table .btn-outline-danger:hover {
    background: #d32f2f;
    color: var(--white);
}

/* ===========================
   MODAL
=========================== */
.modal-content { border-radius: 12px !important; background: #ffffff; border: 1px solid #eaeaea; color: var(--text-color); }
.modal-header { background: #f8f9fa; color: var(--text-color); font-weight: 600; border-radius: 12px 12px 0 0 !important; border-bottom: 1px solid #eaeaea; }
.modal-footer { border-radius: 0 0 12px 12px !important; background: #f8fafc; border-top: 1px solid #eaeaea; }
.modal-header .btn-close { filter: invert(0); opacity: 0.5; }
</style>
                <jsp:include page="/WEB-INF/views/components/dark-mode.jsp" />
            </head>

            <body>
                <div class="container-fluid">
                    <div class="row">
                        <jsp:include page="/WEB-INF/views/admin/components/admin-sidebar.jsp">
                <jsp:param name="activeMenu" value="categories" />
            </jsp:include>

            <div class="col-md-9 col-lg-10 ms-auto main-content">
                            <nav class="navbar navbar-expand-lg navbar-admin sticky-top">
                                <div class="container-fluid">
                                    <h4 class="mb-0">Quản lý chuyên mục</h4>
                                    <div class="navbar-nav ms-auto">
                                        <span class="user-profile-badge">
                                            <i class="fas fa-user-circle"></i> Xin chào, ${sessionScope.currentUser.fullname}
                                        </span>
                                    </div>
                                </div>
                            </nav>

                            <div class="container-fluid px-4">
                                <h2 class="page-title">Quản lý chuyên mục</h2>
    
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

                                <div class="row g-4">
                                    <div class="col-md-4">
                                        <div class="card">
                                            <div class="card-header">
                                                <h5 class="mb-0 d-flex align-items-center">
                                                    <i class="fas fa-plus me-2"></i> Thêm chuyên mục mới
                                                </h5>
                                            </div>
                                            <div class="card-body">
                                                <form action="${pageContext.request.contextPath}/admin/categories/save"
                                                    method="post">
                                                    <div class="mb-3">
                                                        <label for="categoryId" class="form-label fw-bold text-secondary">
                                                            <i class="fas fa-key"></i> Mã chuyên mục <span
                                                                class="text-danger">*</span>
                                                        </label>
                                                        <input type="text" class="form-control" id="categoryId"
                                                            name="id" required maxlength="50"
                                                            placeholder="VD: SPORT, TECH">
                                                    </div>
                                                    <div class="mb-3">
                                                        <label for="categoryName" class="form-label fw-bold text-secondary">
                                                            <i class="fas fa-tag"></i> Tên chuyên mục <span
                                                                class="text-danger">*</span>
                                                        </label>
                                                        <input type="text" class="form-control" id="categoryName"
                                                            name="name" required maxlength="255"
                                                            placeholder="VD: Thể thao, Công nghệ">
                                                    </div>
                                                    <button type="submit" class="btn btn-primary w-100 mt-2">
                                                        <i class="fas fa-save"></i> Thêm chuyên mục
                                                    </button>
                                                </form>
                                            </div>
                                        </div>
                                    </div>

                                    <div class="col-md-8">
                                        <div class="card">
                                            <div class="card-header">
                                                <h5 class="mb-0 d-flex align-items-center">
                                                    <i class="fas fa-list me-2"></i> Danh sách chuyên mục
                                                </h5>
                                            </div>
                                            <div class="card-body p-0">
                                                <c:choose>
                                                    <c:when test="${not empty categories}">
                                                        <div class="table-responsive">
                                                            <table class="table table-hover align-middle mb-0">
                                                                <thead>
                                                                    <tr>
                                                                        <th style="width: 30%;">Mã chuyên mục</th>
                                                                        <th style="width: 50%;">Tên chuyên mục</th>
                                                                        <th style="width: 20%;" class="text-end">Thao tác</th>
                                                                    </tr>
                                                                </thead>
                                                                <tbody>
                                                                    <c:forEach var="category" items="${categories}">
                                                                        <tr>
                                                                            <td><code>${category.id}</code></td>
                                                                            <td><strong>${category.name}</strong></td>
                                                                            <td class="text-end">
                                                                                <button type="button"
                                                                                    class="btn btn-sm btn-outline-primary"
                                                                                    onclick="editCategory('${category.id}', '${category.name}')"
                                                                                    title="Sửa">
                                                                                    <i class="fas fa-pen"></i>
                                                                                </button>
                                                                                <button type="button"
                                                                                    class="btn btn-sm btn-outline-danger"
                                                                                    onclick="deleteCategory('${category.id}', '${category.name}')"
                                                                                    title="Xóa">
                                                                                    <i class="fas fa-trash"></i>
                                                                                </button>
                                                                            </td>
                                                                        </tr>
                                                                    </c:forEach>
                                                                </tbody>
                                                            </table>
                                                        </div>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <div class="text-center py-5">
                                                            <i class="fas fa-tags fa-3x text-secondary mb-3"></i>
                                                            <h5 class="text-muted fw-bold">Chưa có chuyên mục nào</h5>
                                                            <p class="text-muted">Hãy thêm chuyên mục đầu tiên</p>
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

                <div class="modal fade" id="editModal" tabindex="-1">
                    <div class="modal-dialog">
                        <div class="modal-content">
                            <div class="modal-header">
                                <h5 class="modal-title"><i class="fas fa-edit me-2"></i>Sửa chuyên mục</h5>
                                <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                            </div>
                            <form action="${pageContext.request.contextPath}/admin/categories/save" method="post">
                                <div class="modal-body">
                                    <input type="hidden" id="editId" name="id">
                                    <div class="mb-3">
                                        <label for="editName" class="form-label fw-bold">Tên chuyên mục</label>
                                        <input type="text" class="form-control" id="editName" name="name" required>
                                    </div>
                                </div>
                                <div class="modal-footer">
                                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Hủy</button>
                                    <button type="submit" class="btn btn-primary">Cập nhật</button>
                                </div>
                            </form>
                        </div>
                    </div>
                </div>

                <div class="modal fade" id="deleteModal" tabindex="-1">
                    <div class="modal-dialog">
                        <div class="modal-content">
                            <div class="modal-header bg-danger">
                                <h5 class="modal-title"><i class="fas fa-exclamation-triangle me-2"></i>Xác nhận xóa</h5>
                                <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                            </div>
                            <div class="modal-body">
                                <p class="lead">Bạn có chắc chắn muốn xóa chuyên mục **"<span id="deleteName" class="fw-bold"></span>"**?</p>
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
                    function editCategory(id, name) {
                        document.getElementById('editId').value = id;
                        document.getElementById('editName').value = name;
                        const modal = new bootstrap.Modal(document.getElementById('editModal'));
                        modal.show();
                    }

                    function deleteCategory(id, name) {
                        document.getElementById('deleteName').textContent = name;
                        document.getElementById('confirmDelete').onclick = function () {
                            const form = document.createElement('form');
                            form.method = 'POST';
                            form.action = '${pageContext.request.contextPath}/admin/categories/delete';

                            const idInput = document.createElement('input');
                            idInput.type = 'hidden';
                            idInput.name = 'id';
                            idInput.value = id;

                            form.appendChild(idInput);
                            document.body.appendChild(form);
                            form.submit();
                        };

                        const modal = new bootstrap.Modal(document.getElementById('deleteModal'));
                        modal.show();
                    }
                </script>
            </body>

            </html>