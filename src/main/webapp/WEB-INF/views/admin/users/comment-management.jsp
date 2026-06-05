<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="vi">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Quản lý Bình luận - XYZ Admin Premium</title>

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
            box-shadow: 2px 0 10px rgba(0,0,0,0.05);
            min-height: 100vh;
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
            color: #ffffff;
        }

        .sidebar hr {
            background-color: #eaeaea;
            opacity: 1;
        }

        /* ======== MAIN CONTENT & NAVBAR ======== */
        .main-content { padding-left: 0; }
        .navbar-admin {
            background: #ffffff;
            padding: 1rem 2rem;
            box-shadow: 0 2px 10px rgba(0,0,0,0.05);
            margin-bottom: 2rem;
            border-bottom: 1px solid #eaeaea;
            z-index: 900;
        }
        .navbar-admin h4 { color: var(--text-color); font-weight: 700; font-size: 1.5rem; }
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
            cursor: pointer;
            transition: all 0.3s ease;
        }
        .user-profile-badge:hover { background: #ffffff; }
        .user-profile-badge i { color: var(--primary); font-size: 1.2rem; }

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
            color: var(--text-color);
        }

        .card-header h5 {
            font-weight: 700;
            font-size: 1.1rem;
            margin: 0;
            display: flex;
            align-items: center;
            gap: 10px;
        }
        .card-header h5 i { color: var(--text-color) !important; }

        .table { margin-bottom: 0; vertical-align: middle; color: var(--text-color); }
        .table thead th { background: rgba(255,255,255,0.4); color: var(--text-color); font-weight: 600; text-transform: uppercase; font-size: 0.75rem; border-bottom: 1px solid rgba(0,198,217,0.3); padding: 1rem; }
        .table tbody td { padding: 1rem; color: var(--text-color); border-bottom: 1px solid rgba(0,198,217,0.1); font-size: 0.95rem; }
        .table tbody tr:hover { background-color: rgba(255,255,255,0.2); }
        .table tbody tr:last-child td { border-bottom: none; }
        .badge { padding: 0.5em 0.8em; font-weight: 500; border-radius: 6px; }

        .table-danger td { background-color: #fee2e2 !important; border-bottom-color: #fca5a5 !important; }
        .table-danger:hover td { background-color: #fecaca !important; }

        .alert { border-radius: 12px; border: none; box-shadow: 0 4px 6px rgba(0,0,0,0.05); }
    </style>
    <jsp:include page="/WEB-INF/views/components/dark-mode.jsp" />
</head>

<body>
    <div class="container-fluid">
        <div class="row">
            <%-- // FIX: Loại bỏ cụm liên kết menu tĩnh cũ, nhúng Component dùng chung để kích hoạt giao diện tối --%>
            <%-- // FIX: Truyền tham số activeMenu là 'comments' để sidebar nhận biết đúng tab --%>
            <jsp:include page="/WEB-INF/views/admin/components/admin-sidebar.jsp">
                <jsp:param name="activeMenu" value="comments" />
            </jsp:include>

            <%-- // FIX: Đồng bộ cấu trúc class thành 'ms-auto' để căn chỉnh cột giao diện chính xác --%>
            <div class="col-md-9 col-lg-10 ms-auto main-content">
                <nav class="navbar navbar-expand-lg navbar-admin sticky-top">
                    <div class="container-fluid">
                        <h4 class="mb-0">Quản lý Bình luận</h4>
                        
                        <div class="navbar-nav ms-auto dropdown">
                            <a href="#" class="user-profile-badge text-decoration-none dropdown-toggle" data-bs-toggle="dropdown" aria-expanded="false">
                                <i class="fas fa-user-circle"></i> Xin chào, ${sessionScope.currentUser.fullname}
                            </a>
                            <ul class="dropdown-menu dropdown-menu-end shadow-sm border-0 mt-2" style="border-radius: 12px;">
                                <li><a class="dropdown-item py-2" href="${pageContext.request.contextPath}/profile">
                                    <i class="fas fa-id-badge me-2 text-success"></i> Thông tin cá nhân
                                </a></li>
                                <li><a class="dropdown-item py-2" href="${pageContext.request.contextPath}/change-password">
                                    <i class="fas fa-key me-2 text-warning"></i> Đổi mật khẩu
                                </a></li>
                                <li><hr class="dropdown-divider"></li>
                                <li><a class="dropdown-item py-2 text-danger" href="${pageContext.request.contextPath}/logout">
                                    <i class="fas fa-sign-out-alt me-2"></i> Đăng xuất
                                </a></li>
                            </ul>
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
                    <div class="card">
                        <div class="card-header border-bottom-0">
                            <h5 class="mb-0 text-danger"><i class="fas fa-exclamation-circle text-danger me-2"></i> Danh sách bình luận cần kiểm duyệt</h5>
                        </div>
                        <div class="card-body p-0">
                            <c:choose>
                                <c:when test="${not empty commentsList}">
                                    <div class="table-responsive">
                                        <table class="table table-hover align-middle mb-0">
                                            <thead>
                                                <tr>
                                                    <th>Người đăng</th>
                                                    <th style="width: 40%">Nội dung bình luận</th>
                                                    <th>Bài báo</th>
                                                    <th class="text-center">Báo cáo</th>
                                                    <th class="text-end">Hành động</th>
                                                </tr>
                                            </thead>
                                            <tbody>
                                                <c:forEach var="cmt" items="${commentsList}">
                                                    <tr class="${cmt.reportCount >= 3 ? 'table-danger' : ''}">
                                                        <td>
                                                            <strong>${cmt.userFullName}</strong><br>
                                                            <small class="text-muted"><fmt:formatDate value="${cmt.createdDate}" pattern="dd/MM/yyyy HH:mm"/></small>
                                                        </td>
                                                        <td>${cmt.content}</td>
                                                        <td><span class="badge bg-primary">${cmt.newsTitle}</span></td>
                                                        <td class="text-center">
                                                            <c:if test="${cmt.reportCount > 0}">
                                                                <span class="badge bg-warning text-dark px-2 py-1 fs-6 rounded-pill"><i class="fas fa-flag text-danger"></i> ${cmt.reportCount}</span>
                                                            </c:if>
                                                            <c:if test="${cmt.reportCount == 0}">
                                                                <span class="text-muted">0</span>
                                                            </c:if>
                                                        </td>
                                                        <td class="text-end">
                                                            <button type="button" class="btn btn-sm btn-danger" onclick="showDeleteModal('${cmt.id}', '${cmt.userFullName}')">
                                                                <i class="fas fa-trash me-1"></i> Xóa
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
                                        <div class="mb-3"><i class="fas fa-check-circle fa-4x text-success opacity-50"></i></div>
                                        <h6 class="text-muted fw-normal">Hệ thống đang sạch sẽ. Không có bình luận nào cần xử lý.</h6>
                                    </div>
                                </c:otherwise>
                            </c:choose>
                        </div>
                    </div>
                </div>

            </div>
        </div>
    </div>

    <!-- Delete Confirm Modal -->
    <div class="modal fade" id="deleteModal" tabindex="-1">
        <div class="modal-dialog modal-dialog-centered">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title"><i class="fas fa-exclamation-triangle me-2 text-warning"></i> Xác nhận xóa</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body p-4 text-center">
                    <p class="fs-6 mb-2">Bạn có chắc chắn muốn xóa bình luận của</p>
                    <p class="fs-5 fw-bold mb-3" id="deleteAuthorText" style="color: var(--accent);"></p>
                    <p class="text-danger mb-0"><i class="fas fa-info-circle me-1"></i> Hành động này không thể hoàn tác!</p>
                </div>
                <div class="modal-footer justify-content-center">
                    <button type="button" class="btn btn-secondary px-4 me-2" data-bs-dismiss="modal">Hủy</button>
                    <form action="${pageContext.request.contextPath}/admin/comments" method="POST" class="d-inline">
                        <input type="hidden" name="action" value="delete">
                        <input type="hidden" name="id" id="deleteId">
                        <button type="submit" class="btn btn-danger px-4">Xóa</button>
                    </form>
                </div>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        function showDeleteModal(id, author) {
            document.getElementById('deleteId').value = id;
            document.getElementById('deleteAuthorText').innerText = author;
            var myModal = new bootstrap.Modal(document.getElementById('deleteModal'));
            myModal.show();
        }
    </script>
</body>
</html>