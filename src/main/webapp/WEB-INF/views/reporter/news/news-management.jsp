<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html lang="vi">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Quản lý tin tức - XYZ Reporter</title>

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

        /* ===========================
   RESET & TYPOGRAPHY
=========================== */
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

        .sidebar .nav-link i {
            width: 24px;
            text-align: center;
            font-size: 1.1rem;
        }

        .sidebar .nav-link:hover {
            background: #f8f9fa;
            color: var(--primary);
            transform: translateX(5px);
        }

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
   MAIN CONTENT & NAVBAR
=========================== */
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
   CARDS & TABLE
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

        .card-header i {
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
            background-color: #f8f9fa;
        }

        .table tbody tr:last-child td {
            border-bottom: none;
        }

        /* Image Preview */
        .news-image-preview {
            width: 80px;
            height: 60px;
            object-fit: cover;
            border-radius: 8px;
            box-shadow: 0 2px 6px rgba(0, 0, 0, 0.1);
            border: 1px solid #e2e8f0;
        }

        .no-image-placeholder {
            /* Placeholder no image */
            width: 80px;
            height: 60px;
            display: flex;
            align-items: center;
            justify-content: center;
            border: 1px dashed #cfd7e3;
            background: #f8fafc !important;
        }

        .no-image-placeholder i {
            font-size: 1.2rem;
        }

        /* Badges */
        .badge {
            padding: 0.5em 0.8em;
            font-weight: 600;
            border-radius: 6px;
        }

        .badge.bg-secondary {
            background-color: #64748b !important;
        }

        .badge.bg-warning {
            background-color: #f59e0b !important;
            color: var(--white);
        }

        .badge.bg-info {
            background-color: #3b82f6 !important;
            color: var(--white);
        }

        /* Buttons */
        .btn {
            border-radius: 8px !important;
            font-weight: 600;
            padding: 10px 18px;
            transition: all 0.3s ease;
        }

        .btn-primary {
            background-color: var(--primary) !important;
            border-color: var(--primary) !important;
            color: #ffffff !important;
        }

        .btn-primary:hover {
            background-color: #004c6b !important;
            border-color: #004c6b !important;
            color: #ffffff !important;
        }

        .btn-group .btn-sm {
            border-radius: 6px !important;
            font-weight: 500;
            padding: 6px 10px;
        }

        .btn-outline-info {
            color: #3b82f6;
            border-color: #3b82f6;
        }

        .btn-outline-info:hover {
            background: #3b82f6;
            color: white;
        }

        .btn-outline-primary {
            color: var(--primary);
            border-color: var(--primary);
        }

        .btn-outline-primary:hover {
            background: var(--primary);
            color: white;
        }

        .btn-outline-danger {
            color: #ef4444;
            border-color: #ef4444;
        }

        .btn-outline-danger:hover {
            background: #ef4444;
            color: white;
        }

        /* Modal */
        .modal-content { border-radius: 12px !important; background: #ffffff; border: 1px solid #eaeaea; color: var(--text-color); }
        .modal-header { background: #f8f9fa; color: var(--text-color); font-weight: 600; border-radius: 12px 12px 0 0 !important; border-bottom: 1px solid #eaeaea; }
        .modal-footer { border-radius: 0 0 12px 12px !important; background: transparent; border-top: 1px solid #eaeaea; }

        /* Alerts */
        .alert {
            border-radius: 12px;
            border: none;
            box-shadow: 0 4px 6px rgba(0, 0, 0, 0.05);
            font-weight: 500;
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
   CUSTOM PAGINATION
=========================== */
        .custom-pagination {
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 8px;
            list-style: none;
            padding: 0;
        }
        .custom-pagination li {
            margin: 0;
        }
        .page-btn {
            display: inline-flex;
            align-items: center;
            justify-content: center;
            padding: 8px 16px;
            border-radius: 6px;
            font-size: 0.95rem;
            font-weight: 500;
            text-decoration: none;
            transition: all 0.2s;
            cursor: pointer;
        }
        .page-btn:hover {
            color: white;
        }
        .page-btn.dots {
            color: #64748b;
            background: transparent;
            pointer-events: none;
            padding: 8px 4px;
        }
        .page-btn.num-btn {
            background-color: #2b313f;
            color: #ffffff;
            min-width: 40px;
            padding: 8px 12px;
        }
        .page-btn.num-btn:hover {
            background-color: #3e485a;
        }
        .page-btn.num-btn.active {
            background-color: #1a73e8;
            color: #ffffff;
        }
        .page-btn.dark-btn {
            background-color: #2b313f;
            color: #ffffff;
        }
        .page-btn.dark-btn:hover {
            background-color: #3e485a;
        }
        .page-btn.disabled {
            opacity: 0.5;
            pointer-events: none;
        }
    </style>
    <jsp:include page="/WEB-INF/views/components/dark-mode.jsp" />
</head>

<body>
    <div class="container-fluid">
        <div class="row">
            <%-- // FIX: Loại bỏ sidebar hardcode tĩnh, thay thế bằng component dùng chung --%>
            <%-- // FIX: Truyền tham số activeMenu là 'news' để điều hướng sáng đúng danh mục --%>
            <jsp:include page="/WEB-INF/views/reporter/components/reporter-sidebar.jsp">
                <jsp:param name="activeMenu" value="news" />
            </jsp:include>

            <%-- // FIX: Cấu trúc lại class Grid sang 'ms-auto' để đồng bộ layout hiển thị với Dashboard --%>
            <div class="col-md-9 col-lg-10 ms-auto main-content">
                <nav class="navbar navbar-expand-lg navbar-admin sticky-top">
                    <div class="container-fluid">
                        <h4 class="mb-0">Quản lý tin tức</h4>
                        <div class="navbar-nav ms-auto">
                            <span class="navbar-text">
                                <i class="fas fa-user-circle"></i> Xin chào, ${sessionScope.currentUser.fullname}
                            </span>
                        </div>
                    </div>
                </nav>

                <div class="container-fluid px-4">
                    <h2 class="page-title">Danh sách tin tức</h2>

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
                        <div class="col-12 d-flex justify-content-between align-items-center">
                            <a href="${pageContext.request.contextPath}/reporter/news/add" class="btn btn-primary">
                                <i class="fas fa-plus"></i> Thêm tin tức mới
                            </a>
                        </div>
                    </div>

                    <%-- // FIX: Thêm bộ lọc bài viết theo từ khóa, trạng thái, chuyên mục và thời gian đăng --%>
                    <div class="card mb-4">
                        <div class="card-header bg-light">
                            <h5 class="mb-0 text-dark"><i class="fas fa-filter me-2 text-primary"></i>Bộ lọc & Tìm kiếm</h5>
                        </div>
                        <div class="card-body">
                            <form method="GET" action="${pageContext.request.contextPath}/reporter/news" class="row g-3">
                                <div class="col-md-3">
                                    <label for="search" class="form-label fw-bold">Tìm kiếm tiêu đề</label>
                                    <div class="input-group">
                                        <span class="input-group-text bg-light"><i class="fas fa-search"></i></span>
                                        <input type="text" class="form-control" id="search" name="search" placeholder="Nhập tiêu đề tin tức..." value="${search}">
                                    </div>
                                </div>
                                <div class="col-md-2">
                                    <label for="status" class="form-label fw-bold">Trạng thái</label>
                                    <select class="form-select" id="status" name="status">
                                        <option value="all" ${status == null || status == 'all' ? 'selected' : ''}>Tất cả trạng thái</option>
                                        <option value="0" ${status == '0' ? 'selected' : ''}>Chờ duyệt</option>
                                        <option value="1" ${status == '1' ? 'selected' : ''}>Đã duyệt</option>
                                        <option value="2" ${status == '2' ? 'selected' : ''}>Từ chối</option>
                                        <option value="3" ${status == '3' ? 'selected' : ''}>Bản nháp</option>
                                    </select>
                                </div>
                                <div class="col-md-3">
                                    <label for="categoryId" class="form-label fw-bold">Chuyên mục</label>
                                    <select class="form-select" id="categoryId" name="categoryId">
                                        <option value="" ${empty selectedCategoryId ? 'selected' : ''}>Tất cả chuyên mục</option>
                                        <c:forEach var="cat" items="${categories}">
                                            <option value="${cat.id}" ${selectedCategoryId == cat.id ? 'selected' : ''}>${cat.name}</option>
                                        </c:forEach>
                                    </select>
                                </div>
                                <div class="col-md-2">
                                    <label for="dateFrom" class="form-label fw-bold">Từ ngày</label>
                                    <input type="date" class="form-control" id="dateFrom" name="dateFrom" value="${dateFrom}">
                                </div>
                                <div class="col-md-2">
                                    <label for="dateTo" class="form-label fw-bold">Đến ngày</label>
                                    <input type="date" class="form-control" id="dateTo" name="dateTo" value="${dateTo}">
                                </div>
                                <div class="col-12 d-flex justify-content-end gap-2 mt-3">
                                    <a href="${pageContext.request.contextPath}/reporter/news" class="btn btn-outline-secondary">
                                        <i class="fas fa-redo me-1"></i> Xóa bộ lọc
                                    </a>
                                    <button type="submit" class="btn btn-primary">
                                        <i class="fas fa-search-plus me-1"></i> Tìm kiếm
                                    </button>
                                </div>
                            </form>
                        </div>
                    </div>

                    <div class="row">
                        <div class="col-12">
                            <div class="card">
                                <div class="card-header">
                                    <h5 class="mb-0">
                                        <i class="fas fa-list"></i> Danh sách tin tức
                                    </h5>
                                </div>
                                <div class="card-body p-0">
                                    <c:choose>
                                        <c:when test="${not empty newsList}">
                                            <div class="table-responsive">
                                                <table class="table table-hover align-middle">
                                                    <thead>
                                                        <tr>
                                                            <th>Hình ảnh</th>
                                                            <th>Tiêu đề</th>
                                                            <th>Tác giả</th>
                                                            <th>Chuyên mục</th>
                                                            <th>Ngày đăng</th>
                                                            <th>Lượt xem</th>
                                                            <th>Trạng thái</th>
                                                            <th class="text-end">Thao tác</th>
                                                        </tr>
                                                    </thead>
                                                    <tbody>
                                                        <c:forEach var="news" items="${newsList}">
                                                            <tr>
                                                                <td>
                                                                    <c:choose>
                                                                        <c:when test="${not empty news.image}">
                                                                            <c:choose>
                                                                                <c:when test="${fn:startsWith(news.image, 'http')}">
                                                                                    <img src="${news.image}" class="news-image-preview" alt="${news.title}">
                                                                                </c:when>
                                                                                <c:otherwise>
                                                                                    <img src="${pageContext.request.contextPath}/images/${news.image}" class="news-image-preview" alt="${news.title}">
                                                                                </c:otherwise>
                                                                            </c:choose>
                                                                        </c:when>
                                                                        <c:otherwise>
                                                                             <div class="no-image-placeholder p-2 rounded text-center">
                                                                                 <i class="fas fa-image text-muted"></i>
                                                                             </div>
                                                                        </c:otherwise>
                                                                    </c:choose>
                                                                </td>

                                                                <td>
                                                                    <strong>${news.title}</strong><br>
                                                                    <small class="text-muted">${news.getShortContent(50)}...</small>
                                                                </td>

                                                                <td>${news.authorName}</td>

                                                                <td>
                                                                    <span class="badge bg-secondary">${news.categoryName}</span>
                                                                </td>

                                                                <td>
                                                                    <fmt:formatDate value="${news.postedDate}" pattern="dd/MM/yyyy" />
                                                                </td>

                                                                <td>
                                                                    <i class="fas fa-eye me-1 text-muted"></i> ${news.viewCount}
                                                                </td>

                                                                <td>
                                                                    <c:choose>
                                                                        <c:when test="${news.status == 1}">
                                                                            <span class="badge bg-success">Đã duyệt</span>
                                                                        </c:when>
                                                                        <c:when test="${news.status == 2}">
                                                                            <span class="badge bg-danger">Từ chối</span>
                                                                            <%-- // FIX: Hiển thị lý do từ chối bài viết từ Admin dưới dạng nhãn nhỏ --%>
                                                                            <c:if test="${not empty news.rejectReason}">
                                                                                <br>
                                                                                <small class="text-danger d-block mt-1" style="max-width: 150px; font-size: 0.8rem; cursor: help;" title="${news.rejectReason}">
                                                                                    <i class="fas fa-info-circle me-1"></i>Lý do: ${news.rejectReason}
                                                                                </small>
                                                                            </c:if>
                                                                        </c:when>
                                                                        <c:when test="${news.status == 3}">
                                                                            <span class="badge bg-secondary">Bản nháp</span>
                                                                        </c:when>
                                                                        <c:otherwise>
                                                                            <span class="badge bg-warning text-dark">Chờ duyệt</span>
                                                                        </c:otherwise>
                                                                    </c:choose>
                                                                </td>

                                                                <td class="text-end">
                                                                    <div class="btn-group" role="group">
                                                                        <a href="${pageContext.request.contextPath}/news?action=detail&id=${news.id}" class="btn btn-sm btn-outline-info" title="Xem">
                                                                            <i class="fas fa-eye"></i>
                                                                        </a>

                                                                        <a href="${pageContext.request.contextPath}/reporter/news/edit?id=${news.id}" class="btn btn-sm btn-outline-primary" title="Sửa">
                                                                            <i class="fas fa-edit"></i>
                                                                        </a>

                                                                        <button type="button" class="btn btn-sm btn-outline-danger" onclick="deleteNews('${news.id}', '${news.title}')" title="Xóa">
                                                                            <i class="fas fa-trash"></i>
                                                                        </button>
                                                                    </div>
                                                                </td>
                                                            </tr>
                                                        </c:forEach>
                                                    </tbody>
                                                </table>
                                            </div>

                                            <c:if test="${totalPages > 1}">
                                                <%-- // FIX: Lưu trữ chuỗi các tham số lọc để truyền nối tiếp qua các liên kết phân trang --%>
                                                <c:set var="filterParams" value="&search=${search}&status=${status}&categoryId=${selectedCategoryId}&dateFrom=${dateFrom}&dateTo=${dateTo}" />
                                                <nav aria-label="Page navigation" class="mt-4 mb-5 d-flex justify-content-center">
                                                    <ul class="custom-pagination">
                                                        <c:set var="startPage" value="${currentPage - 2}" />
                                                        <c:if test="${startPage < 1}">
                                                            <c:set var="startPage" value="1" />
                                                        </c:if>
                                                        
                                                        <c:set var="endPage" value="${currentPage + 2}" />
                                                        <c:if test="${endPage > totalPages}">
                                                            <c:set var="endPage" value="${totalPages}" />
                                                        </c:if>

                                                        <li>
                                                            <a class="page-btn dark-btn ${currentPage == 1 ? 'disabled' : ''}" href="${pageContext.request.contextPath}/reporter/news?page=${currentPage - 1}${filterParams}">&lt; Trở về</a>
                                                        </li>
                                                        <li>
                                                            <a class="page-btn dark-btn ${currentPage == 1 ? 'disabled' : ''}" href="${pageContext.request.contextPath}/reporter/news?page=1${filterParams}">Đầu</a>
                                                        </li>

                                                        <c:if test="${startPage > 1}">
                                                            <li><span class="page-btn dots">...</span></li>
                                                        </c:if>

                                                        <c:forEach begin="${startPage}" end="${endPage}" var="i">
                                                            <li>
                                                                <a class="page-btn num-btn ${currentPage == i ? 'active' : ''}" href="${pageContext.request.contextPath}/reporter/news?page=${i}${filterParams}">${i}</a>
                                                            </li>
                                                        </c:forEach>

                                                        <c:if test="${endPage < totalPages}">
                                                            <li><span class="page-btn dots">...</span></li>
                                                        </c:if>

                                                        <li>
                                                            <a class="page-btn dark-btn ${currentPage == totalPages ? 'disabled' : ''}" href="${pageContext.request.contextPath}/reporter/news?page=${totalPages}${filterParams}">Cuối</a>
                                                        </li>
                                                        <li>
                                                            <a class="page-btn dark-btn ${currentPage == totalPages ? 'disabled' : ''}" href="${pageContext.request.contextPath}/reporter/news?page=${currentPage + 1}${filterParams}">Tiếp theo &gt;</a>
                                                        </li>
                                                    </ul>
                                                </nav>
                                            </c:if>
                                        </c:when>
                                        <c:otherwise>
                                            <div class="text-center py-5">
                                                <i class="fas fa-newspaper fa-4x text-light mb-3"></i>
                                                <h6 class="text-muted fw-normal">Chưa có tin tức nào</h6>
                                                <p class="text-muted">Hãy thêm tin tức đầu tiên của bạn</p>
                                                <a href="${pageContext.request.contextPath}/reporter/news/add" class="btn btn-primary mt-3">
                                                    <i class="fas fa-plus"></i> Thêm tin tức đầu tiên
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

    <div class="modal fade" id="deleteModal" tabindex="-1">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title"><i class="fas fa-exclamation-triangle me-2"></i> Xác nhận xóa</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body">
                    <p class="lead">Bạn có chắc chắn muốn xóa tin tức **"<span id="newsTitle" class="fw-bold"></span>**"?</p>
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
        function deleteNews(newsId, newsTitle) {
            document.getElementById('newsTitle').textContent = newsTitle;
            document.getElementById('confirmDelete').onclick = function () {
                const form = document.createElement('form');
                form.method = 'POST';
                form.action = '${pageContext.request.contextPath}/reporter/news/delete';

                const idInput = document.createElement('input');
                idInput.type = 'hidden';
                idInput.name = 'id';
                idInput.value = newsId;

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