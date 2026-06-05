<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="vi">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Quản lý người dùng - XYZ Admin Premium</title>

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

/* SIDEBAR */
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

/* MAIN CONTENT & NAVBAR */
.main-content { background-color: transparent; padding-left: 0; padding-top: 0; }
.navbar-admin { background: #ffffff; padding: 1rem 2rem; box-shadow: 0 2px 10px rgba(0,0,0,0.05); margin-bottom: 2rem; border-bottom: 1px solid #eaeaea; z-index: 900; display: flex; align-items: center; }
.navbar-admin h4 { color: var(--text-color); font-weight: 700; font-size: 1.5rem; }
.navbar-text { background: #f8f9fa; padding: 8px 16px; border-radius: 50px; display: flex; align-items: center; gap: 10px; color: var(--text-color); font-weight: 600; border: 1px solid #eaeaea; }
.navbar-text i { color: var(--primary); font-size: 1.2rem; }

/* PAGE TITLE */
.page-title { font-size: 26px; font-weight: 700; margin-bottom: 12px; position: relative; padding-bottom: 12px; color: var(--text-color); }
.page-title::after { content: ""; position: absolute; bottom: 0; left: 0; width: 60px; height: 3px; background: var(--primary); border-radius: 2px; }

/* CARDS & TABLE */
.card { border: 1px solid #eaeaea; border-radius: 12px; background: #ffffff; box-shadow: 0 2px 10px rgba(0,0,0,0.05); margin-bottom: 2rem; overflow: hidden; color: var(--text-color); }
.card-header { background: #ffffff; color: var(--text-color); font-weight: 700; font-size: 1.1rem; padding: 1.2rem 1.5rem; border-bottom: 1px solid #eaeaea; border-radius: 12px 12px 0 0 !important; display: flex; align-items: center; gap: 10px; }
.card-header i { color: var(--primary); }
.table { margin-bottom: 0; vertical-align: middle; color: var(--text-color); }
.table thead th { background: #f8f9fa; color: var(--text-color); font-weight: 600; text-transform: uppercase; font-size: 0.75rem; letter-spacing: 0.5px; border-bottom: 1px solid #eaeaea; padding: 1rem; }
.table tbody td { padding: 1rem; color: var(--text-color); border-bottom: 1px solid #eaeaea; font-size: 0.95rem; }
.table tbody tr:hover { background-color: #f8f9fa; }
.table tbody tr:last-child td { border-bottom: none; }

/* Badges */
.badge { padding: 0.5em 0.8em; font-weight: 600; border-radius: 6px; }
.badge.bg-danger { background-color: #dc2626 !important; }
.badge.bg-info { background-color: #3b82f6 !important; }
.badge.bg-secondary { background-color: #64748b !important; }

/* Buttons */
.btn { border-radius: 8px !important; font-weight: 600; padding: 10px 18px; transition: all 0.3s ease; }
.btn-primary { background-color: var(--primary) !important; border-color: var(--primary) !important; color: #ffffff !important; }
.btn-primary:hover { background-color: #004c6b !important; border-color: #004c6b !important; color: #ffffff !important; }
.btn-group .btn-sm { border-radius: 6px !important; font-weight: 500; padding: 6px 10px; }
.btn-outline-primary { color: var(--primary); border-color: var(--primary); }
.btn-outline-primary:hover { background: var(--primary); color: white; }
.btn-outline-danger { color: #ef4444; border-color: #ef4444; }
.btn-outline-danger:hover { background: #ef4444; color: white; }

/* Modal */
.modal-content { border-radius: 12px !important; background: #ffffff; border: 1px solid #eaeaea; color: var(--text-color); }
.modal-header { background: #f8f9fa; color: var(--text-color); font-weight: 600; border-radius: 12px 12px 0 0 !important; border-bottom: 1px solid #eaeaea; }
.modal-footer { border-radius: 0 0 12px 12px !important; background: transparent; border-top: 1px solid #eaeaea; }

/* Alerts */
.alert { border-radius: 8px; border: 1px solid #eaeaea; background: #ffffff; box-shadow: 0 2px 10px rgba(0,0,0,0.05); font-weight: 500; color: var(--text-color); }
.alert-success { border-left: 4px solid #10b981; }
.alert-danger { border-left: 4px solid #ef4444; }
.alert .btn-close { filter: invert(0); opacity: 0.8; }
.form-check-inline { margin-right: 1.5rem; }
    </style>
    <jsp:include page="/WEB-INF/views/components/dark-mode.jsp" />
</head>

<body>
    <div class="container-fluid">
        <div class="row">
            <%-- // FIX: Thay thế toàn bộ khối sidebar viết cứng cũ bằng component dùng chung để đồng bộ giao diện --%>
            <%-- // FIX: Truyền activeMenu là "users" để thanh điều hướng nhận biết đúng vị trí sáng đèn --%>
            <jsp:include page="/WEB-INF/views/admin/components/admin-sidebar.jsp">
                <jsp:param name="activeMenu" value="users" />
            </jsp:include>

            <%-- // FIX: Cấu trúc lại grid thành ms-auto và xóa bỏ ký tự lỗi dư thừa ">" ở cuối class --%>
            <div class="col-md-9 col-lg-10 ms-auto main-content">
                <nav class="navbar navbar-expand-lg navbar-admin sticky-top">
                    <div class="container-fluid">
                        <h4 class="mb-0">Quản lý người dùng</h4>
                        <div class="navbar-nav ms-auto">
                            <span class="navbar-text">
                                <i class="fas fa-user-circle"></i> Xin chào, ${sessionScope.currentUser.fullname}
                            </span>
                        </div>
                    </div>
                </nav>

                <div class="container-fluid px-4">
                    <h2 class="page-title">Danh sách người dùng</h2>

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

                    <div class="row mb-4">
                        <div class="col-12">
                            <button type="button" class="btn btn-primary" onclick="showAddUserModal()">
                                <i class="fas fa-plus"></i> Thêm người dùng mới
                            </button>
                        </div>
                    </div>

                    <div class="row">
                        <div class="col-12">
                            <div class="card">
                                <div class="card-header d-flex justify-content-between align-items-center flex-wrap gap-2">
                                    <h5 class="mb-0">
                                        <i class="fas fa-users"></i> Phân loại người dùng
                                    </h5>
                                    <ul class="nav nav-pills" id="userFilterTabs">
                                        <li class="nav-item"><a class="nav-link active px-3 py-1 fw-bold" href="javascript:void(0)" onclick="filterUsers('all', this)">Tất cả</a></li>
                                        <li class="nav-item"><a class="nav-link px-3 py-1 fw-bold text-secondary" href="javascript:void(0)" onclick="filterUsers('reader', this)">Độc giả</a></li>
                                        <li class="nav-item"><a class="nav-link px-3 py-1 fw-bold text-info" href="javascript:void(0)" onclick="filterUsers('reporter', this)">Phóng viên</a></li>
                                        <li class="nav-item"><a class="nav-link px-3 py-1 fw-bold text-danger" href="javascript:void(0)" onclick="filterUsers('admin', this)">Quản trị</a></li>
                                    </ul>
                                </div>
                                <div class="card-body p-0">
                                    <c:choose>
                                        <c:when test="${not empty users}">
                                            <div class="table-responsive">
                                                <table class="table table-hover align-middle">
                                                    <thead>
                                                        <tr>
                                                            <th>ID</th>
                                                            <th>Họ tên</th>
                                                            <th>Email</th>
                                                            <th>Ngày sinh</th>
                                                            <th>Giới tính</th>
                                                            <th>Điện thoại</th>
                                                            <th>Vai trò</th><th>Trạng thái</th>
                                                            <th class="text-end">Thao tác</th>
                                                        </tr>
                                                    </thead>
                                                    <tbody id="userTableBody">
                                                        <c:forEach var="user" items="${users}">
                                                            <tr class="user-row" data-role="${user.admin ? 'admin' : (user.reporter ? 'reporter' : 'reader')}">
                                                                <td><code>${user.id}</code></td>
                                                                <td><strong>${user.fullname}</strong></td>
                                                                <td>${user.email}</td>
                                                                <td>
                                                                    <c:if test="${user.birthday != null}">
                                                                        <fmt:formatDate value="${user.birthday}" pattern="dd/MM/yyyy" />
                                                                    </c:if>
                                                                </td>
                                                                <td>
                                                                    <c:choose>
                                                                        <c:when test="${user.gender}">
                                                                            <span class="text-primary fw-bold"><i class="fas fa-mars me-1"></i> Nam</span>
                                                                        </c:when>
                                                                        <c:otherwise>
                                                                            <span class="text-danger fw-bold"><i class="fas fa-venus me-1"></i> Nữ</span>
                                                                        </c:otherwise>
                                                                    </c:choose>
                                                                </td>
                                                                <td>${user.mobile}</td>
                                                                
                                                                <td>
                                                                    <c:choose>
                                                                        <c:when test="${user.admin}"><span class="badge bg-danger"><i class="fas fa-crown me-1"></i> Quản trị</span></c:when>
                                                                        <c:when test="${user.reporter}"><span class="badge bg-info"><i class="fas fa-pencil-alt me-1"></i> Phóng viên</span></c:when>
                                                                        <c:otherwise><span class="badge bg-secondary"><i class="fas fa-book-open me-1"></i> Độc giả</span></c:otherwise>
                                                                    </c:choose>
                                                                </td>
                                                                
                                                                <td>
                                                                    <c:choose>
                                                                        <c:when test="${user.active}">
                                                                            <span class="badge bg-success">Hoạt động</span>
                                                                        </c:when>
                                                                        <c:otherwise>
                                                                            <span class="badge bg-secondary">Bị khóa</span>
                                                                        </c:otherwise>
                                                                    </c:choose>
                                                                </td>
                                                                
                                                                <td class="text-end">
                                                                    <div class="btn-group" role="group">
                                                                        <button type="button" class="btn btn-sm btn-outline-primary"
                                                                            onclick="editUser('${user.id}', '${user.fullname}', '${user.email}', '${user.birthday}', '${user.gender}', '${user.mobile}', '${user.role}')"
                                                                            title="Sửa">
                                                                            <i class="fas fa-edit"></i>
                                                                        </button>
                                                                        
                                                                        <c:if test="${user.id != sessionScope.currentUser.id}">
                                                                            <c:choose>
                                                                                <c:when test="${user.active}">
                                                                                    <button type="button" class="btn btn-sm btn-outline-warning"
                                                                                        onclick="toggleUserStatus('${user.id}', '${user.fullname}', false)" title="Khóa tài khoản">
                                                                                        <i class="fas fa-lock"></i>
                                                                                    </button>
                                                                                </c:when>
                                                                                <c:otherwise>
                                                                                    <button type="button" class="btn btn-sm btn-outline-success"
                                                                                        onclick="toggleUserStatus('${user.id}', '${user.fullname}', true)" title="Mở khóa">
                                                                                        <i class="fas fa-unlock"></i>
                                                                                    </button>
                                                                                </c:otherwise>
                                                                            </c:choose>
                                                                        </c:if>
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
                                                <i class="fas fa-users-cog fa-4x text-light mb-3"></i>
                                                <h6 class="text-muted fw-normal">Chưa có người dùng nào</h6>
                                                <button type="button" class="btn btn-primary mt-3" onclick="showAddUserModal()">
                                                    <i class="fas fa-plus"></i> Thêm người dùng đầu tiên
                                                </button>
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

    <!-- Modal Form -->
    <div class="modal fade" id="userModal" tabindex="-1">
        <div class="modal-dialog modal-lg">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title" id="userModalTitle"><i class="fas fa-user-plus me-2"></i> Thêm người dùng mới</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>

                <form action="${pageContext.request.contextPath}/admin/users/save" method="post">
                    <div class="modal-body">
                        <div class="mb-3">
                            <label for="userIdInput" class="form-label">ID đăng nhập <span class="text-danger">*</span></label>
                            <input type="text" class="form-control" id="userIdInput" name="id" required>
                        </div>

                        <div class="row">
                            <div class="col-md-6">
                                <div class="mb-3">
                                    <label for="userFullname" class="form-label">Họ tên <span class="text-danger">*</span></label>
                                    <input type="text" class="form-control" id="userFullname" name="fullname" required>
                                </div>
                            </div>
                            <div class="col-md-6">
                                <div class="mb-3">
                                    <label for="userEmail" class="form-label">Email <span class="text-danger">*</span></label>
                                    <input type="email" class="form-control" id="userEmail" name="email" required>
                                </div>
                            </div>
                        </div>

                        <div class="row">
                            <div class="col-md-6">
                                <div class="mb-3">
                                    <label for="userPassword" class="form-label">Mật khẩu <span class="text-danger" id="passwordRequiredLabel">*</span></label>
                                    <input type="password" class="form-control" id="userPassword" name="password">
                                </div>
                            </div>
                            <div class="col-md-6">
                                <div class="mb-3">
                                    <label for="userMobile" class="form-label">Điện thoại</label>
                                    <input type="text" class="form-control" id="userMobile" name="mobile">
                                </div>
                            </div>
                        </div>

                        <div class="row">
                            <div class="col-md-6">
                                <div class="mb-3">
                                    <label for="userBirthday" class="form-label">Ngày sinh</label>
                                    <input type="date" class="form-control" id="userBirthday" name="birthday">
                                </div>
                            </div>
                            <div class="col-md-6">
                                <label class="form-label">Giới tính</label>
                                <div class="pt-2">
                                    <label class="form-check form-check-inline">
                                        <input type="radio" class="form-check-input" name="gender" id="genderMale" value="true"> Nam
                                    </label>
                                    <label class="form-check form-check-inline">
                                        <input type="radio" class="form-check-input" name="gender" id="genderFemale" value="false"> Nữ
                                    </label>
                                </div>
                            </div>
                        </div>

                        <div class="mb-3">
                            <label class="form-label">Vai trò</label>
                            <div class="pt-2">
                                <label class="form-check form-check-inline">
                                    <input type="radio" class="form-check-input" name="role" id="roleReader" value="2" checked> Độc giả
                                </label>
                                <label class="form-check form-check-inline">
                                    <input type="radio" class="form-check-input" name="role" id="roleReporter" value="0"> Phóng viên
                                </label>
                                <label class="form-check form-check-inline">
                                    <input type="radio" class="form-check-input" name="role" id="roleAdmin" value="1"> Quản trị
                                </label>
                            </div>
                        </div>

                    </div>

                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Hủy</button>
                        <button type="submit" class="btn btn-primary" id="saveUserBtn">Thêm mới</button>
                    </div>
                </form>
            </div>
        </div>
    </div>

    <!-- Modal Confirm Toggle Lock Status -->
    <div class="modal fade" id="deleteModal" tabindex="-1">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title"><i class="fas fa-exclamation-triangle me-2"></i> Xác nhận khóa</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body">
                    <p class="lead" id="modalActionText"></p>
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
    function showAddUserModal() {
        document.getElementById('userModalTitle').innerHTML = '<i class="fas fa-user-plus me-2"></i> Thêm người dùng mới';
        document.getElementById('saveUserBtn').textContent = 'Thêm mới';

        document.getElementById('userIdInput').value = '';
        document.getElementById('userIdInput').disabled = false;
        document.getElementById('userIdInput').required = true;

        document.getElementById('userFullname').value = '';
        document.getElementById('userEmail').value = '';
        document.getElementById('userPassword').value = '';
        document.getElementById('userMobile').value = '';
        document.getElementById('userBirthday').value = '';

        document.getElementById('genderMale').checked = true;
        document.getElementById('roleReader').checked = true;

        document.getElementById('userPassword').required = true;
        document.getElementById('passwordRequiredLabel').style.display = "inline";

        new bootstrap.Modal(document.getElementById('userModal')).show();
    }

    function filterUsers(role, element) {
        // 1. Gỡ class active của tất cả các tab
        document.querySelectorAll('#userFilterTabs .nav-link').forEach(el => el.classList.remove('active'));
        // 2. Thêm class active cho tab vừa click
        element.classList.add('active');

        // 3. Lọc các dòng (rows) dựa trên data-role
        const rows = document.querySelectorAll('.user-row');
        rows.forEach(row => {
            if (role === 'all' || row.getAttribute('data-role') === role) {
                row.style.display = ''; // Hiện
            } else {
                row.style.display = 'none'; // Ẩn
            }
        });
    }

    function editUser(id, fullname, email, birthday, gender, mobile, role) {
        document.getElementById('userModalTitle').innerHTML = '<i class="fas fa-user-edit me-2"></i> Sửa thông tin người dùng';
        document.getElementById('saveUserBtn').textContent = 'Cập nhật';

        document.getElementById('userIdInput').value = id;
        document.getElementById('userIdInput').disabled = true;
        document.getElementById('userIdInput').required = false;

        document.getElementById('userFullname').value = fullname;
        document.getElementById('userEmail').value = email;
        document.getElementById('userMobile').value = mobile || '';
        document.getElementById('userBirthday').value = birthday || '';

        document.getElementById('genderMale').checked = gender === 'true';
        document.getElementById('genderFemale').checked = gender === 'false';

        document.getElementById('roleAdmin').checked = role === '1';
        document.getElementById('roleReporter').checked = role === '0';
        document.getElementById('roleReader').checked = role === '2';

        document.getElementById('userPassword').required = false;
        document.getElementById('passwordRequiredLabel').style.display = "none";
        document.getElementById('userPassword').value = '';

        new bootstrap.Modal(document.getElementById('userModal')).show();
    }

    function toggleUserStatus(id, fullname, isActivating) {
        const modalTitle = document.querySelector('.modal-title');
        const confirmBtn = document.getElementById('confirmDelete');
        const modalText = document.getElementById('modalActionText');

        if(isActivating) {
            modalTitle.innerHTML = '<i class="fas fa-unlock text-success me-2"></i> Xác nhận mở khóa';
            modalText.innerHTML = `Bạn có chắc chắn muốn <b>mở khóa</b> tài khoản của "<b>` + fullname + `</b>"?`;
            confirmBtn.className = 'btn btn-success';
            confirmBtn.textContent = 'Mở khóa';
        } else {
            modalTitle.innerHTML = '<i class="fas fa-lock text-warning me-2"></i> Xác nhận khóa tài khoản';
            modalText.innerHTML = `Bạn có chắc chắn muốn <b>khóa</b> tài khoản của "<b>` + fullname + `</b>"?<br><br><small class="text-danger fw-bold"><i class="fas fa-exclamation-circle me-1"></i> Người dùng này sẽ không thể đăng nhập vào hệ thống!</small>`;
            confirmBtn.className = 'btn btn-warning text-dark';
            confirmBtn.textContent = 'Khóa ngay';
        }

        confirmBtn.onclick = function () {
            const form = document.createElement('form');
            form.method = 'POST';
            form.action = '${pageContext.request.contextPath}/admin/users/toggle-status';

            const idInput = document.createElement('input');
            idInput.type = 'hidden';
            idInput.name = 'id';
            idInput.value = id;

            const activeInput = document.createElement('input');
            activeInput.type = 'hidden';
            activeInput.name = 'isActive';
            activeInput.value = isActivating;

            form.appendChild(idInput);
            form.appendChild(activeInput);
            document.body.appendChild(form);
            form.submit();
        };

        const modal = new bootstrap.Modal(document.getElementById('deleteModal'));
        modal.show();
    }
    </script>
</body>
</html>