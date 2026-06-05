<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<style>
    /* CSS Áp dụng Giao diện Dark Theme */
    .sidebar-dark {
        background-color: #1c2434 !important;
        color: #8a99af !important;
        min-height: 100vh;
        box-shadow: 2px 0 10px rgba(0,0,0,0.1);
        padding-bottom: 50px;
    }
    
    .sidebar-dark .admin-brand {
        color: #ffffff;
        font-weight: 800;
        font-size: 1.25rem;
        padding: 20px 15px;
        text-align: center;
        border-bottom: 1px solid #313d4a;
        margin-bottom: 15px;
    }

    .sidebar-dark hr {
        border-color: #313d4a;
        margin: 15px 0;
    }

    .sidebar-dark .nav-link {
        color: #8a99af !important;
        padding: 12px 20px;
        font-size: 0.95rem;
        display: flex;
        align-items: center;
        border-radius: 0;
        transition: all 0.3s ease;
        text-decoration: none;
    }

    .sidebar-dark .nav-link:hover,
    .sidebar-dark .nav-link[aria-expanded="true"] {
        background-color: #333a48 !important;
        color: #ffffff !important;
    }

    .sidebar-dark .nav-link.active {
        background-color: #333a48 !important;
        color: #38bdf8 !important;
        border-left: 4px solid #38bdf8;
    }

    .sidebar-dark .nav-link i.main-icon {
        width: 25px;
        text-align: center;
        margin-right: 12px;
        font-size: 1.1rem;
    }
</style>

<div class="col-md-3 col-lg-2 px-0 sidebar-dark position-fixed h-100 overflow-auto custom-scrollbar">
    <div class="admin-brand">
        <i class="fas fa-pen-nib text-primary me-2"></i> XYZ REPORTER
    </div>

    <nav class="nav flex-column mt-2">
        <a class="nav-link ${param.activeMenu == 'news' ? 'active' : ''}" href="${pageContext.request.contextPath}/reporter/news">
            <i class="fas fa-file-alt main-icon text-info"></i> Quản lý bài viết cá nhân
        </a>
        <a class="nav-link ${param.activeMenu == 'comments' ? 'active' : ''}" href="${pageContext.request.contextPath}/reporter/comments">
            <i class="fas fa-comments main-icon text-warning"></i> Quản lý bình luận
        </a>
        <a class="nav-link ${param.activeMenu == 'analytics' ? 'active' : ''}" href="${pageContext.request.contextPath}/reporter/analytics">
            <i class="fas fa-chart-bar main-icon text-success"></i> Thống kê bài viết
        </a>
        <hr>
        
        <a class="nav-link" href="${pageContext.request.contextPath}/profile">
            <i class="fas fa-user-circle main-icon text-muted"></i> Hồ sơ cá nhân
        </a>
        <a class="nav-link mt-3" href="${pageContext.request.contextPath}/" style="color: #38bdf8 !important;">
            <i class="fas fa-external-link-alt main-icon"></i> XEM TRANG CHỦ
        </a>
        <a class="nav-link" href="${pageContext.request.contextPath}/logout" style="color: #ef4444 !important;">
            <i class="fas fa-sign-out-alt main-icon"></i> ĐĂNG XUẤT
        </a>
    </nav>
</div>
