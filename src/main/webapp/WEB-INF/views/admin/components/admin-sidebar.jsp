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

    .sidebar-dark .nav-link i.arrow-icon {
        margin-left: auto;
        font-size: 0.75rem;
        transition: transform 0.3s;
    }

    .sidebar-dark .nav-link[aria-expanded="true"] i.arrow-icon {
        transform: rotate(180deg);
    }

    .sidebar-dark .collapse-level-1 {
        background-color: #161d2b;
    }
    .sidebar-dark .collapse-level-1 > .nav > .nav-link {
        padding-left: 50px;
        font-size: 0.9rem;
        border-left: none;
    }

    .sidebar-dark .collapse-level-2 .nav-link {
        padding-left: 70px;
        font-size: 0.85rem;
    }
    .sidebar-dark .collapse-level-2 .nav-link::before {
        content: "├─";
        margin-right: 8px;
        opacity: 0.5;
    }
</style>

<div class="col-md-3 col-lg-2 px-0 sidebar-dark position-fixed h-100 overflow-auto custom-scrollbar">
    <div class="admin-brand">
        <i class="fas fa-layer-group text-primary me-2"></i> XYZ ADMIN
    </div>

    <nav class="nav flex-column mt-2">
        <a class="nav-link ${param.activeMenu == 'dashboard' ? 'active' : ''}" href="${pageContext.request.contextPath}/admin">
            <i class="fas fa-home main-icon text-white"></i> Tổng quan
        </a>
        <a class="nav-link ${param.activeMenu == 'news' ? 'active' : ''}" href="${pageContext.request.contextPath}/admin/news">
            <i class="fas fa-file-alt main-icon text-info"></i> Quản lý tin tức
        </a>
        
        <%-- PHẦN DÀNH CHO ADMIN --%>
        <c:if test="${sessionScope.currentUser.admin}">
            <a class="nav-link ${param.activeMenu == 'categories' ? 'active' : ''}" href="${pageContext.request.contextPath}/admin/categories">
                <i class="fas fa-folder-open main-icon text-warning"></i> Quản lý chuyên mục
            </a>
            <a class="nav-link ${param.activeMenu == 'users' ? 'active' : ''}" href="${pageContext.request.contextPath}/admin/users">
                <i class="fas fa-users-cog main-icon text-danger"></i> Quản lý người dùng
            </a>
            <a class="nav-link ${param.activeMenu == 'comments' ? 'active' : ''}" href="${pageContext.request.contextPath}/admin/comments">
                <i class="fas fa-comments main-icon text-success"></i> Quản lý bình luận
            </a>
            <a class="nav-link ${param.activeMenu == 'newsletters' ? 'active' : ''}" href="${pageContext.request.contextPath}/admin/newsletters">
                <i class="fas fa-envelope-open-text main-icon text-secondary"></i> Đăng ký nhận tin
            </a>
            
            <a class="nav-link ${param.activeMenu == 'orders_premium' ? 'active' : ''}" 
               href="${pageContext.request.contextPath}/admin/orders/premium">
                <i class="fas fa-shopping-cart main-icon text-warning"></i> Quản lý đăng ký
            </a>

            <a class="nav-link ${fn:contains(param.activeMenu, 'ads_') ? 'active' : ''}" 
               href="#adsMainDropdown" data-bs-toggle="collapse" role="button" aria-expanded="${fn:contains(param.activeMenu, 'ads_') ? 'true' : 'false'}">
                <i class="fas fa-bullhorn main-icon text-primary"></i> Quản lý quảng cáo
                <i class="fas fa-chevron-down arrow-icon"></i>
            </a>
            
            <div class="collapse collapse-level-1 ${fn:contains(param.activeMenu, 'ads_') ? 'show' : ''}" id="adsMainDropdown">
                <jsp:include page="/WEB-INF/views/admin/ads/ads-submenu.jsp" />
            </div>
        </c:if>
        <%-- ĐÓNG CẤU HÌNH ADMIN TẠI ĐÂY --%>
        
        <hr>
        
        <%-- PHẦN DÀNH CHO MỌI USER --%>
        <a class="nav-link" href="#">
            <i class="fas fa-cog main-icon text-muted"></i> CÀI ĐẶT HỆ THỐNG
        </a>
        <a class="nav-link mt-3" href="${pageContext.request.contextPath}/" style="color: #38bdf8 !important;">
            <i class="fas fa-external-link-alt main-icon"></i> XEM TRANG CHỦ
        </a>
        <a class="nav-link" href="${pageContext.request.contextPath}/logout" style="color: #ef4444 !important;">
            <i class="fas fa-sign-out-alt main-icon"></i> ĐĂNG XUẤT
        </a>
    </nav>
</div>
