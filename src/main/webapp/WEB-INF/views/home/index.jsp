<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>THANH NIÊN - Tin tức mới nhất 24h</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <link href="https://fonts.googleapis.com/css2?family=Merriweather:wght@400;700;900&family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css" rel="stylesheet">
    <script>
        tailwind.config = {
            theme: {
                extend: {
                    colors: { 
                        primary: "#006389", 
                        danger: "#e11d48",
                    },
                    fontFamily: { 
                        serif: ['Merriweather', 'serif'], 
                        sans: ['Inter', 'sans-serif'] 
                    }
                }
            }
        }
    </script>
    <style>
        .line-clamp-2 {
            display: -webkit-box;
            -webkit-line-clamp: 2;
            -webkit-box-orient: vertical;
            overflow: hidden;
        }
        .line-clamp-3 {
            display: -webkit-box;
            -webkit-line-clamp: 3;
            -webkit-box-orient: vertical;
            overflow: hidden;
        }
        .nav-link {
            position: relative;
        }
        .nav-link.active::before {
            content: '';
            position: absolute;
            top: -14px; 
            left: 0;
            width: 100%;
            height: 3px;
            background-color: #0ea5e9;
        }
        .section-title {
            position: relative;
            display: inline-block;
            text-transform: uppercase;
            font-family: 'Merriweather', serif;
        }
        .section-title::after {
            content: '';
            position: absolute;
            bottom: -8px;
            left: 0;
            width: 100%;
            height: 2px;
            background-color: #006389;
        }
    </style>
</head>
<body class="bg-white text-gray-800 font-sans">

<jsp:include page="../public/components/header.jsp" />

<div class="w-full flex justify-center items-start relative xl:overflow-visible overflow-hidden">
    <!-- QUẢNG CÁO SIDEBAR TRÁI (Sticky) -->
    <c:if test="${not empty sidebarLeftAds and (empty sessionScope.currentUser or not sessionScope.currentUser.premium)}">
        <div class="hidden xl:block w-[160px] flex-shrink-0 pt-8 z-0 mr-6 relative">
            <div class="sticky top-24 flex flex-col gap-4">
                <c:forEach var="ad" items="${sidebarLeftAds}">
                    <div class="bg-gray-100 rounded flex flex-col items-center justify-center text-gray-400 border border-gray-200 overflow-hidden relative" style="width: 160px; height: 600px;">
                        <span class="absolute top-1 left-2 text-[10px] text-gray-400 bg-white/80 px-1 rounded shadow-sm z-10">Tài trợ</span>
                        <a href="${ad.targetUrl}" target="_blank" class="block w-full h-full">
                            <img src="${ad.imageUrl}" class="w-full h-full object-cover shadow-md rounded" style="image-rendering: -webkit-optimize-contrast; image-rendering: crisp-edges;" loading="lazy" decoding="async" alt="Ad">
                        </a>
                    </div>
                </c:forEach>
            </div>
        </div>
    </c:if>

<main class="w-full max-w-6xl px-4 py-8 relative z-10 bg-white">
    
    <c:if test="${not empty topBannerAd and (empty sessionScope.currentUser or not sessionScope.currentUser.premium)}">
        <div class="w-full aspect-[1120/90] mb-8 rounded shadow-sm relative overflow-hidden group">
            <span class="absolute top-1 right-2 text-[10px] bg-white/80 text-gray-400 px-1 rounded shadow-sm z-10">Tài trợ</span>
            <a href="${topBannerAd.targetUrl}" target="_blank" class="block w-full h-full">
                <img src="${topBannerAd.imageUrl}" class="w-full h-full object-cover" style="image-rendering: -webkit-optimize-contrast; image-rendering: crisp-edges;" loading="lazy" decoding="async" alt="Advertisement">
            </a>
        </div>
    </c:if>

    <%-- SECTION 1: Top News & Tin mới --%>
    <div class="grid grid-cols-12 gap-8 mb-10 border-b border-gray-200 pb-8">
        <%-- Left: Top News --%>
        <div class="col-span-12 lg:col-span-8">
            <c:if test="${not empty topNews}">
                <a href="${pageContext.request.contextPath}/news?action=detail&id=${topNews.id}" class="group block no-underline">
                    <div class="overflow-hidden mb-4 relative">
                        <c:choose>
                            <c:when test="${fn:startsWith(topNews.image, 'http')}">
                                <img src="${topNews.image}" alt="${topNews.title}" class="w-full aspect-[16/10] object-cover group-hover:scale-105 transition duration-500">
                            </c:when>
                            <c:otherwise>
                                <img src="${pageContext.request.contextPath}/images/${topNews.image}" alt="${topNews.title}" class="w-full aspect-[16/10] object-cover group-hover:scale-105 transition duration-500">
                            </c:otherwise>
                        </c:choose>
                    </div>
                    <span class="text-[11px] font-bold text-gray-500 uppercase tracking-widest">${topNews.categoryName}</span>
                    <h2 class="text-3xl font-serif font-bold text-gray-900 mt-2 mb-3 group-hover:text-primary transition line-clamp-2 leading-snug">
                        ${topNews.title}
                    </h2>
                    <p class="text-gray-600 text-[15px] leading-relaxed line-clamp-3">
                        ${topNews.getShortContent(200)}
                    </p>
                </a>
            </c:if>
        </div>

        <%-- Right: Tin mới / Đọc nhiều --%>
        <div class="col-span-12 lg:col-span-4">
            <div class="border border-gray-200 p-5 rounded h-full flex flex-col">
                


                <div class="flex gap-5 border-b border-gray-200 mb-4 pb-2">
                    <button class="font-bold text-[13px] text-primary border-b-2 border-primary pb-2 -mb-[10px] uppercase">Tin mới</button>
                    <button class="font-bold text-[13px] text-gray-500 hover:text-gray-800 pb-2 uppercase transition">Bạn quan tâm</button>
                </div>
                
                <div class="flex-1 flex flex-col gap-4">
                    <c:forEach items="${latestNews}" var="news" end="3">
                        <article class="border-b border-gray-100 pb-4 last:border-0 last:pb-0">
                            <a href="${pageContext.request.contextPath}/news?action=detail&id=${news.id}" 
                               class="font-bold text-[15px] leading-snug text-gray-900 hover:text-primary transition line-clamp-3 no-underline">
                                ${news.title}
                            </a>
                            <p class="text-[11px] text-gray-500 mt-2 italic font-serif text-gray-400">Cập nhật 10 phút trước</p>
                        </article>
                    </c:forEach>
                </div>
                
                <a href="${pageContext.request.contextPath}/news" class="block w-full text-center bg-gray-100 hover:bg-gray-200 text-gray-600 font-bold text-xs py-3 mt-5 transition rounded no-underline">
                    XEM THÊM
                </a>
            </div>
        </div>
    </div>

    <%-- FIX: CHỈ HIỆN CÁC KHỐI MEDIUM RECTANGLE KHI CÓ QUẢNG CÁO VÀ KHÔNG PHẢI TÀI KHOẢN PREMIUM --%>
    <c:if test="${(not empty mediumRectangle1Ad or not empty mediumRectangle2Ad or not empty mediumRectangle3Ad) and (empty sessionScope.currentUser or not sessionScope.currentUser.premium)}">
        <div class="grid grid-cols-1 md:grid-cols-3 gap-6 mb-12 border-b border-gray-200 pb-12">
            <c:if test="${not empty mediumRectangle1Ad}">
                <div class="w-full aspect-[300/250] rounded shadow-sm relative overflow-hidden group">
                    <span class="absolute top-1 right-2 text-[10px] bg-white/80 text-gray-400 px-1 rounded shadow-sm z-10">Tài trợ</span>
                    <a href="${mediumRectangle1Ad.targetUrl}" target="_blank" class="block w-full h-full">
                        <img src="${mediumRectangle1Ad.imageUrl}" class="w-full h-full object-cover" alt="Ad">
                    </a>
                </div>
            </c:if>
            <c:if test="${not empty mediumRectangle2Ad}">
                <div class="w-full aspect-[300/250] rounded shadow-sm relative overflow-hidden group">
                    <span class="absolute top-1 right-2 text-[10px] bg-white/80 text-gray-400 px-1 rounded shadow-sm z-10">Tài trợ</span>
                    <a href="${mediumRectangle2Ad.targetUrl}" target="_blank" class="block w-full h-full">
                        <img src="${mediumRectangle2Ad.imageUrl}" class="w-full h-full object-cover" alt="Ad">
                    </a>
                </div>
            </c:if>
            <c:if test="${not empty mediumRectangle3Ad}">
                <div class="w-full aspect-[300/250] rounded shadow-sm relative overflow-hidden group">
                    <span class="absolute top-1 right-2 text-[10px] bg-white/80 text-gray-400 px-1 rounded shadow-sm z-10">Tài trợ</span>
                    <a href="${mediumRectangle3Ad.targetUrl}" target="_blank" class="block w-full h-full">
                        <img src="${mediumRectangle3Ad.imageUrl}" class="w-full h-full object-cover" alt="Ad">
                    </a>
                </div>
            </c:if>
        </div>
    </c:if>

    <%-- SECTION 2: 3 Columns News (Giáo dục, Tài chính, Tin nóng) --%>
    <div class="grid grid-cols-1 md:grid-cols-3 gap-8 mb-12">
        <c:forEach items="${homeNews}" var="item" begin="1" end="2">
            <article>
                <a href="${pageContext.request.contextPath}/news?action=detail&id=${item.id}" class="group block no-underline">
                    <div class="overflow-hidden mb-3 aspect-[3/2]">
                        <c:choose>
                            <c:when test="${fn:startsWith(item.image, 'http')}">
                               <img src="${item.image}" class="w-full h-full object-cover group-hover:scale-105 transition duration-500">
                            </c:when>
                            <c:otherwise>
                                <img src="${pageContext.request.contextPath}/images/${item.image}" class="w-full h-full object-cover group-hover:scale-105 transition duration-500">
                            </c:otherwise>
                        </c:choose>
                    </div>
                    <span class="text-[11px] font-bold text-danger uppercase tracking-wider">${item.categoryName}</span>
                    <h3 class="font-serif font-bold text-xl leading-tight text-gray-900 mt-1 mb-2 group-hover:text-primary transition line-clamp-3">
                        ${item.title}
                    </h3>
                    <p class="text-[13px] text-gray-500 line-clamp-3 text-gray-600">${item.getShortContent(150)}</p>
                </a>
            </article>
        </c:forEach>
        
        <%-- Tin nóng (Column 3) --%>
        <article class="bg-red-50 p-6 border border-red-100 border-l-2 border-l-danger">
            <div class="flex items-center gap-2 text-danger font-bold text-xs tracking-widest uppercase mb-4">
                <i class="fas fa-bolt"></i> TIN NÓNG
            </div>
            <c:if test="${homeNews.size() > 3}">
                <a href="${pageContext.request.contextPath}/news?action=detail&id=${homeNews[3].id}" class="block group mb-4 pb-4 no-underline">
                    <h3 class="font-serif font-bold text-[22px] leading-tight text-gray-900 group-hover:text-danger transition line-clamp-4 mb-3">
                        ${homeNews[3].title}
                    </h3>
                    <p class="text-[13px] text-gray-600 line-clamp-4 leading-relaxed">${homeNews[3].getShortContent(180)}</p>
                </a>
            </c:if>
            <div class="mt-4 pt-4 border-t border-red-200">
                <a href="${pageContext.request.contextPath}/news" class="text-xs font-bold text-gray-900 hover:text-danger transition no-underline">Chi tiết <i class="fas fa-arrow-right ml-1"></i></a>
            </div>
        </article>
    </div>

    <%-- SECTION 3: GIẢI TRÍ (Dark background) --%>
    <div class="bg-[#2c2c2c] text-white p-8 rounded mb-12 shadow-inner">
        <div class="flex justify-between items-end border-b border-gray-600 pb-3 mb-6">
            <h2 class="text-3xl font-serif font-bold tracking-wide">GIẢI TRÍ</h2>
            <div class="flex gap-4 text-[10px] font-bold text-gray-400 tracking-wider">
                <a href="#" class="hover:text-white transition uppercase no-underline">Video</a>
                <a href="#" class="hover:text-white transition uppercase no-underline">Ảnh</a>
                <a href="#" class="hover:text-white transition uppercase no-underline">Magazine</a>
            </div>
        </div>
        
        <div class="grid grid-cols-12 gap-8">
            <c:if test="${homeNews.size() > 4}">
                <div class="col-span-12 lg:col-span-8 relative group">
                    <a href="${pageContext.request.contextPath}/news?action=detail&id=${homeNews[4].id}" class="block overflow-hidden rounded relative no-underline">
                        <div class="aspect-[16/9] bg-black">
                            <c:choose>
                                <c:when test="${fn:startsWith(homeNews[4].image, 'http')}"><img src="${homeNews[4].image}" class="w-full h-full object-cover group-hover:scale-105 transition duration-700 opacity-80 group-hover:opacity-100"></c:when>
                                <c:otherwise><img src="${pageContext.request.contextPath}/images/${homeNews[4].image}" class="w-full h-full object-cover group-hover:scale-105 transition duration-700 opacity-80 group-hover:opacity-100"></c:otherwise>
                            </c:choose>
                        </div>
                        <div class="absolute inset-0 bg-gradient-to-t from-black/90 via-black/20 to-transparent pointer-events-none"></div>
                        
                        <div class="absolute bottom-6 left-6 right-6">
                            <span class="bg-primary/90 text-white text-[10px] font-bold px-2 py-1 uppercase tracking-wider mb-3 inline-block">Phóng sự</span>
                            <h3 class="text-2xl font-serif font-bold leading-snug group-hover:text-blue-300 transition line-clamp-2 text-white">${homeNews[4].title}</h3>
                        </div>
                        
                        <div class="absolute top-1/2 left-1/2 transform -translate-x-1/2 -translate-y-1/2 w-14 h-14 bg-primary/90 rounded flex items-center justify-center text-white text-xl shadow-lg pointer-events-none group-hover:bg-primary transition">
                            <i class="fas fa-play ml-1"></i>
                        </div>
                    </a>
                </div>
            </c:if>
            
            <div class="col-span-12 lg:col-span-4 flex flex-col justify-between">
                <c:forEach items="${homeNews}" var="item" begin="5" end="6">
                    <article class="flex gap-4 group h-[calc(50%-1rem)]">
                        <a href="${pageContext.request.contextPath}/news?action=detail&id=${item.id}" class="flex gap-4 w-full h-full no-underline">
                            <div class="w-1/2 aspect-video overflow-hidden shrink-0 rounded bg-gray-800">
                                <c:choose>
                                    <c:when test="${fn:startsWith(item.image, 'http')}"><img src="${item.image}" class="w-full h-full object-cover group-hover:scale-105 transition duration-500 opacity-90"></c:when>
                                    <c:otherwise><img src="${pageContext.request.contextPath}/images/${item.image}" class="w-full h-full object-cover group-hover:scale-105 transition duration-500 opacity-90"></c:otherwise>
                                </c:choose>
                            </div>
                            <div class="w-1/2 pt-1 border-t border-gray-600">
                                <span class="text-[10px] text-gray-400 block mb-1 uppercase tracking-wider">${item.categoryName}</span>
                                <h3 class="font-bold text-[13px] leading-snug group-hover:text-blue-300 transition line-clamp-4 text-white">
                                    ${item.title}
                                </h3>
                            </div>
                        </a>
                    </article>
                </c:forEach>
            </div>
        </div>
    </div>

    <%-- SECTION 4: SỨC KHỎE --%>
    <c:if test="${not empty healthNews}">
        <div class="mb-10">
            <div class="flex justify-between items-end border-b border-gray-200 pb-2 mb-6">
                <h2 class="text-lg font-bold text-primary section-title tracking-wide">SỨC KHỎE</h2>
                <a href="${pageContext.request.contextPath}/news?action=category&id=HEALTH" class="text-[11px] text-gray-500 hover:text-primary transition uppercase tracking-wider font-semibold no-underline">Xem tất cả</a>
            </div>
            <div class="grid grid-cols-1 sm:grid-cols-2 md:grid-cols-4 gap-6">
                <c:forEach items="${healthNews}" var="item">
                    <article>
                        <a href="${pageContext.request.contextPath}/news?action=detail&id=${item.id}" class="group block no-underline">
                            <div class="aspect-[4/3] overflow-hidden mb-3">
                                <c:choose>
                                    <c:when test="${fn:startsWith(item.image, 'http')}"><img src="${item.image}" class="w-full h-full object-cover group-hover:scale-105 transition duration-500"></c:when>
                                    <c:otherwise><img src="${pageContext.request.contextPath}/images/${item.image}" class="w-full h-full object-cover group-hover:scale-105 transition duration-500"></c:otherwise>
                                </c:choose>
                            </div>
                            <h3 class="font-serif font-bold text-[16px] leading-snug text-gray-900 group-hover:text-primary transition line-clamp-3">${item.title}</h3>
                        </a>
                    </article>
                </c:forEach>
            </div>
        </div>
    </c:if>

    <%-- SECTION 5: CÔNG NGHỆ --%>
    <c:if test="${not empty techNews}">
        <div class="mb-12 border-t-2 border-gray-100 pt-8">
            <div class="flex justify-between items-end border-b border-gray-200 pb-2 mb-6">
                <h2 class="text-lg font-bold text-primary section-title tracking-wide">CÔNG NGHỆ</h2>
                <a href="${pageContext.request.contextPath}/news?action=category&id=TECH" class="text-[11px] text-gray-500 hover:text-primary transition uppercase tracking-wider font-semibold no-underline">Xem tất cả</a>
            </div>
            <div class="grid grid-cols-12 gap-8">
                <div class="col-span-12 md:col-span-8">
                    <c:set var="techTop" value="${techNews[0]}" />
                    <a href="${pageContext.request.contextPath}/news?action=detail&id=${techTop.id}" class="group block no-underline">
                        <div class="aspect-[16/9] overflow-hidden mb-4">
                            <c:choose>
                                <c:when test="${fn:startsWith(techTop.image, 'http')}"><img src="${techTop.image}" class="w-full h-full object-cover group-hover:scale-105 transition duration-500"></c:when>
                                <c:otherwise><img src="${pageContext.request.contextPath}/images/${techTop.image}" class="w-full h-full object-cover group-hover:scale-105 transition duration-500"></c:otherwise>
                            </c:choose>
                        </div>
                        <h3 class="text-[22px] font-serif font-bold text-gray-900 group-hover:text-primary transition mb-2 line-clamp-2">${techTop.title}</h3>
                        <p class="text-[14px] text-gray-600 line-clamp-2 leading-relaxed">${techTop.getShortContent(180)}</p>
                    </a>
                </div>
                <div class="col-span-12 md:col-span-4 flex flex-col gap-6">
                    <c:forEach items="${techNews}" var="item" begin="1">
                        <article class="flex gap-4 group">
                            <div class="w-28 aspect-square overflow-hidden shrink-0 bg-gray-100">
                                <c:choose>
                                    <c:when test="${fn:startsWith(item.image, 'http')}"><img src="${item.image}" class="w-full h-full object-cover group-hover:scale-105 transition duration-500"></c:when>
                                    <c:otherwise><img src="${pageContext.request.contextPath}/images/${item.image}" class="w-full h-full object-cover group-hover:scale-105 transition duration-500"></c:otherwise>
                                </c:choose>
                            </div>
                            <a href="${pageContext.request.contextPath}/news?action=detail&id=${item.id}" class="font-bold text-[14px] leading-snug text-gray-900 group-hover:text-primary transition line-clamp-4 no-underline">
                                ${item.title}
                            </a>
                        </article>
                    </c:forEach>
                    
                    <%-- FIX: CHỈ HIỆN FLOAT BANNER KHI CÓ DỮ LIỆU ĐÃ DUYỆT TỪ ADMIN VÀ KHÔNG PHẢI PREMIUM --%>
                    <c:if test="${not empty floatBannerAd and (empty sessionScope.currentUser or not sessionScope.currentUser.premium)}">
                        <div class="w-full aspect-[300/600] rounded shadow-sm relative overflow-hidden group mt-4">
                            <span class="absolute top-1 right-2 text-[10px] bg-white/80 text-gray-400 px-1 rounded shadow-sm z-10">Tài trợ</span>
                            <a href="${floatBannerAd.targetUrl}" target="_blank" class="block w-full h-full">
                                <img src="${floatBannerAd.imageUrl}" class="w-full h-full object-cover" alt="Ad">
                            </a>
                        </div>
                    </c:if>
                </div>
            </div>
        </div>
    </c:if>

    <%-- SECTION 6: TIN TỔNG HỢP --%>
    <div class="mb-12 border-t-2 border-gray-100 pt-8">
        <div class="flex justify-between items-end border-b border-gray-200 pb-2 mb-6">
            <h2 class="text-lg font-bold text-primary section-title tracking-wide">TIN TỔNG HỢP</h2>
            <a href="${pageContext.request.contextPath}/news" class="text-[11px] text-gray-500 hover:text-primary transition uppercase tracking-wider font-semibold no-underline">Xem tất cả</a>
        </div>
        <div class="grid grid-cols-1 md:grid-cols-3 gap-8">
            <c:forEach items="${homeNews}" var="item" begin="7" end="8">
                <article>
                    <a href="${pageContext.request.contextPath}/news?action=detail&id=${item.id}" class="group block no-underline">
                        <div class="aspect-[3/2] overflow-hidden mb-3 bg-gray-100">
                            <c:choose>
                                <c:when test="${fn:startsWith(item.image, 'http')}"><img src="${item.image}" class="w-full h-full object-cover group-hover:scale-105 transition duration-500"></c:when>
                                <c:otherwise><img src="${pageContext.request.contextPath}/images/${item.image}" class="w-full h-full object-cover group-hover:scale-105 transition duration-500"></c:otherwise>
                            </c:choose>
                        </div>
                        <h3 class="font-serif font-bold text-[18px] leading-snug text-gray-900 mt-2 mb-2 group-hover:text-primary transition line-clamp-3">
                            ${item.title}
                        </h3>
                        <p class="text-[13px] text-gray-600 line-clamp-2">${item.getShortContent(100)}</p>
                    </a>
                </article>
            </c:forEach>
            
            <div class="flex flex-col">
                <c:forEach items="${generalNews}" var="item" end="3">
                    <a href="${pageContext.request.contextPath}/news?action=detail&id=${item.id}" 
                       class="font-serif font-bold text-[16px] leading-relaxed text-gray-900 hover:text-primary transition border-b border-gray-200 pb-4 mb-4 first:pt-0 last:border-0 last:mb-0 line-clamp-3 no-underline">
                        ${item.title}
                    </a>
                </c:forEach>
            </div>
        </div>
    </div>

</main>

    <!-- QUẢNG CÁO SIDEBAR PHẢI (Sticky) -->
    <c:if test="${not empty sidebarRightAds and (empty sessionScope.currentUser or not sessionScope.currentUser.premium)}">
        <div class="hidden xl:block w-[160px] flex-shrink-0 pt-8 z-0 ml-6 relative">
            <div class="sticky top-24 flex flex-col gap-4">
                <c:forEach var="ad" items="${sidebarRightAds}">
                    <div class="bg-gray-100 rounded flex flex-col items-center justify-center text-gray-400 border border-gray-200 overflow-hidden relative" style="width: 160px; height: 600px;">
                        <span class="absolute top-1 left-2 text-[10px] text-gray-400 bg-white/80 px-1 rounded shadow-sm z-10">Tài trợ</span>
                        <a href="${ad.targetUrl}" target="_blank" class="block w-full h-full">
                            <img src="${ad.imageUrl}" class="w-full h-full object-cover shadow-md rounded" style="image-rendering: -webkit-optimize-contrast; image-rendering: crisp-edges;" loading="lazy" decoding="async" alt="Ad">
                        </a>
                    </div>
                </c:forEach>
            </div>
        </div>
    </c:if>
</div>

<jsp:include page="../public/components/footer.jsp" />

</body>
</html>