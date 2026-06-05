<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>${pageTitle} - XYZ News</title>
    
    <link href="https://fonts.googleapis.com/css2?family=Merriweather:wght@400;700;900&family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css" rel="stylesheet">
    
    <script src="https://cdn.tailwindcss.com"></script>
    <script>
        tailwind.config = {
            theme: {
                extend: {
                    colors: { primary: "#006389", danger: "#e11d48" },
                    fontFamily: { serif: ['Merriweather', 'serif'], sans: ['Inter', 'sans-serif'] }
                }
            }
        }
    </script>
    <style>
        .line-clamp-2 { display: -webkit-box; -webkit-line-clamp: 2; -webkit-box-orient: vertical; overflow: hidden; }
        .line-clamp-3 { display: -webkit-box; -webkit-line-clamp: 3; -webkit-box-orient: vertical; overflow: hidden; }
        @keyframes fadeInUp { from { opacity: 0; transform: translateY(20px); } to { opacity: 1; transform: translateY(0); } }
        .smooth-load { animation: fadeInUp 0.6s cubic-bezier(0.16, 1, 0.3, 1) forwards; }
    </style>
</head>
<body class="bg-gray-50 text-gray-800 font-sans min-h-screen flex flex-col">
    <jsp:include page="../public/components/header.jsp" />

<div class="w-full flex justify-center items-start relative xl:overflow-visible overflow-hidden">
    <!-- QUẢNG CÁO SIDEBAR TRÁI (Sticky) -->
    <c:if test="${not empty sidebarLeftAds}">
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

    <main class="max-w-6xl px-4 py-8 w-full smooth-load bg-white z-10 relative">
        <c:if test="${not empty topBannerAd}">
            <div class="w-full aspect-[1120/90] mb-8 rounded shadow-sm relative overflow-hidden group">
                <span class="absolute top-1 right-2 text-[10px] bg-white/80 text-gray-400 px-1 rounded shadow-sm z-10">Tài trợ</span>
                <a href="${topBannerAd.targetUrl}" target="_blank" class="block w-full h-full">
                    <img src="${topBannerAd.imageUrl}" class="w-full h-full object-cover" style="image-rendering: -webkit-optimize-contrast; image-rendering: crisp-edges;" loading="lazy" decoding="async" alt="Advertisement">
                </a>
            </div>
        </c:if>

        <div class="mb-8 border-b border-gray-200 pb-4">
            <h1 class="text-3xl font-serif font-bold text-gray-900 flex items-center gap-3">
                <c:if test="${not empty category}">
                    <i class="fas fa-tag text-primary"></i> ${pageTitle}
                </c:if>
                <c:if test="${empty category}">
                    <i class="fas fa-newspaper text-primary"></i> ${pageTitle}
                </c:if>
            </h1>
        </div>

        <div class="grid grid-cols-1 md:grid-cols-2 gap-8">
            <c:choose>
                <c:when test="${not empty newsList}">
                    <c:forEach var="news" items="${newsList}">
                        <div class="bg-white rounded-xl shadow-sm border border-gray-100 overflow-hidden hover:shadow-md hover:-translate-y-1 transition-all duration-300 flex flex-col h-full group">
                            <div class="relative overflow-hidden h-60 w-full">
                                <c:choose>
                                    <c:when test="${not empty news.image && news.image.startsWith('http')}">
                                        <img src="${news.image}" class="w-full h-full object-cover group-hover:scale-105 transition-transform duration-500" alt="${news.title}">
                                    </c:when>
                                    <c:otherwise>
                                        <img src="${pageContext.request.contextPath}/images/${news.image}" class="w-full h-full object-cover group-hover:scale-105 transition-transform duration-500" alt="${news.title}">
                                    </c:otherwise>
                                </c:choose>
                            </div>
                            <div class="p-5 flex flex-col flex-grow">
                                <h3 class="text-xl font-serif font-bold text-gray-900 mb-3 line-clamp-2 group-hover:text-primary transition-colors">
                                    <a href="${pageContext.request.contextPath}/news?action=detail&id=${news.id}" class="no-underline text-inherit hover:text-primary">
                                        ${news.title}
                                    </a>
                                </h3>
                                <p class="text-gray-600 text-sm mb-4 line-clamp-3 flex-grow">${news.getShortContent(150)}</p>
                                <div class="flex items-center flex-wrap gap-x-4 gap-y-2 text-xs font-medium text-gray-500 mt-auto pt-4 border-t border-gray-100">
                                    <span class="flex items-center gap-1.5"><i class="fas fa-user"></i> ${news.authorName}</span>
                                    <span class="flex items-center gap-1.5"><i class="fas fa-calendar"></i> <fmt:formatDate value="${news.postedDate}" pattern="dd/MM/yyyy" /></span>
                                    <span class="flex items-center gap-1.5"><i class="fas fa-eye"></i> ${news.viewCount} lượt xem</span>
                                    <span class="flex items-center gap-1.5"><i class="fas fa-tag"></i> ${news.categoryName}</span>
                                </div>
                            </div>
                        </div>
                    </c:forEach>
                </c:when>
                <c:otherwise>
                    <div class="col-span-full text-center py-16 bg-white rounded-xl shadow-sm border border-gray-100">
                        <i class="fas fa-newspaper text-5xl text-gray-300 mb-4"></i>
                        <h3 class="text-xl font-semibold text-gray-600 mb-2">Chưa có tin tức nào</h3>
                        <p class="text-gray-500">
                            <c:if test="${not empty category}">Chưa có tin tức nào trong chuyên mục ${category.name}</c:if>
                            <c:if test="${empty category}">Chưa có tin tức nào được đăng</c:if>
                        </p>
                    </div>
                </c:otherwise>
            </c:choose>
        </div>
    </main>

    <!-- QUẢNG CÁO SIDEBAR PHẢI (Sticky) -->
    <c:if test="${not empty sidebarRightAds}">
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