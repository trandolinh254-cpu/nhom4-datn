<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>



<div class="nav flex-column">


    <!-- Requests -->
    <a class="nav-link ${fn:startsWith(param.activeMenu, 'ads_req') ? 'active' : ''}"
       href="${pageContext.request.contextPath}/admin/ads/requests">
        <i class="fas fa-inbox me-2"></i>
        Yêu cầu quảng cáo
    </a>

    <!-- Báo Online -->
    <a class="nav-link ${fn:startsWith(param.activeMenu, 'ads_online') ? 'active' : ''}"
       href="#adsOnlineMenu"
       data-bs-toggle="collapse"
       aria-expanded="${fn:startsWith(param.activeMenu, 'ads_online') ? 'true' : 'false'}">

        <i class="fas fa-globe me-2"></i>
        Báo Online

        <i class="fas fa-chevron-down arrow-icon ms-auto"></i>
    </a>

    <div class="collapse collapse-level-2 ${fn:startsWith(param.activeMenu, 'ads_online') ? 'show' : ''}"
         id="adsOnlineMenu">

        <div class="nav flex-column">

            <a class="nav-link ${param.activeMenu == 'ads_online_positions' ? 'active' : ''}"
               href="${pageContext.request.contextPath}/admin/ads/online/positions">
                Vị trí quảng cáo
            </a>

            <a class="nav-link ${param.activeMenu == 'ads_online_pricing' ? 'active' : ''}"
               href="${pageContext.request.contextPath}/admin/ads/online/pricing">
                Bảng giá
            </a>

        </div>
    </div>


    <!-- Khách hàng -->
    <a class="nav-link ${fn:startsWith(param.activeMenu, 'ads_client') ? 'active' : ''}"
       href="#adsClientMenu"
       data-bs-toggle="collapse"
       aria-expanded="${fn:startsWith(param.activeMenu, 'ads_client') ? 'true' : 'false'}">

        <i class="fas fa-building me-2"></i>
        Khách hàng

        <i class="fas fa-chevron-down arrow-icon ms-auto"></i>
    </a>

    <div class="collapse collapse-level-2 ${fn:startsWith(param.activeMenu, 'ads_client') ? 'show' : ''}"
         id="adsClientMenu">

        <div class="nav flex-column">

            <a class="nav-link ${param.activeMenu == 'ads_client_list' ? 'active' : ''}"
               href="${pageContext.request.contextPath}/admin/ads/customers">
                DS khách hàng đã đăng ký QC
            </a>

        </div>
    </div>

</div>