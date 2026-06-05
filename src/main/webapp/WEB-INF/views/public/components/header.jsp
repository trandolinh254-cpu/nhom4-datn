<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<%-- ===== CSS cho Dark Mode toàn trang ===== --%>
<jsp:include page="/WEB-INF/views/components/dark-mode.jsp" />

<%-- FIX: CHỈ HIỂN THỊ SUPER MASTHEAD KHI ADMIN ĐÃ DUYỆT VÀ TRUYỀN DỮ LIỆU SANG --%>
<c:if test="${not empty superMastheadAd}">
    <div class="hidden md:block w-full relative">
        <span class="absolute top-0 right-0 text-[10px] text-gray-400 bg-white/80 px-1 border-b border-l border-gray-200 shadow-sm z-10">Tài trợ</span>
        <a href="${superMastheadAd.targetUrl}" target="_blank" class="block w-full">
            <img src="${superMastheadAd.imageUrl}" class="w-full h-auto max-h-[250px] object-cover" style="image-rendering: -webkit-optimize-contrast; image-rendering: crisp-edges;" loading="lazy" decoding="async" alt="${superMastheadAd.campaignName}">
        </a>
    </div>
</c:if>

<%-- ===== Wrapper sticky: toàn bộ header đi theo khi cuộn --%>
<div id="stickyHeaderWrapper" class="sticky top-0 z-50">

<%-- ===== Top Bar ===== --%>
<div class="top-bar-dark border-b border-gray-200 text-[12px] text-gray-500 font-semibold bg-white font-sans relative z-[60]">
    <div class="max-w-6xl mx-auto px-4 py-2.5 flex justify-between items-center">
        <div class="flex items-center gap-4">
            <span id="liveTime" class="flex items-center gap-1">
                <i class="far fa-clock"></i> <span id="clockText">--:--</span>
            </span>
            <span class="text-gray-300">|</span>
            <span id="weatherInfo" class="flex items-center gap-1">
                <i class="fas fa-spinner fa-spin text-yellow-500"></i> Đang tải...
            </span>
        </div>
        <div class="flex gap-5 items-center text-gray-600 tracking-wide uppercase">
            <a href="${pageContext.request.contextPath}/quang-cao/online" class="text-gray-500 hover:text-primary transition no-underline">Quảng cáo</a>
            <a href="${pageContext.request.contextPath}/premium" class="text-red-500 hover:text-red-600 font-bold transition no-underline flex items-center gap-1"><i class="fas fa-crown"></i> Premium</a>
            <c:choose>
                <c:when test="${sessionScope.currentUser != null}">
                    <div class="relative group">
                        <a href="#" class="hover:text-primary transition no-underline font-bold flex items-center gap-1 text-primary">
                            Xin chào, ${sessionScope.currentUser.fullname} <i class="fas fa-caret-down text-xs"></i>
                        </a>
                        <div class="dropdown-dark absolute right-0 top-full mt-2 w-52 bg-white shadow-lg rounded-md border border-gray-100 opacity-0 invisible group-hover:opacity-100 group-hover:visible transition-all duration-300 z-50 py-2">
                            <a href="${pageContext.request.contextPath}/profile" class="block px-4 py-2 text-gray-700 hover:bg-gray-50 hover:text-primary no-underline normal-case text-sm">
                                <i class="fas fa-user-circle w-5"></i> Thông tin cá nhân
                            </a>
                            <a href="${pageContext.request.contextPath}/profile/ads" class="block px-4 py-2 text-gray-700 hover:bg-gray-50 hover:text-primary no-underline normal-case text-sm">
                                <i class="fas fa-ad w-5"></i> Quảng cáo của tôi
                            </a>
                            <c:if test="${sessionScope.currentUser.admin}">
                                <a href="${pageContext.request.contextPath}/admin" class="block px-4 py-2 text-gray-700 hover:bg-gray-50 hover:text-primary no-underline normal-case text-sm">
                                    <i class="fas fa-tachometer-alt w-5"></i> Trang quản trị
                                </a>
                            </c:if>
                            <c:if test="${sessionScope.currentUser.reporter}">
                                <a href="${pageContext.request.contextPath}/reporter/news" class="block px-4 py-2 text-gray-700 hover:bg-gray-50 hover:text-primary no-underline normal-case text-sm">
                                    <i class="fas fa-edit w-5"></i> Trang quản trị
                                </a>
                            </c:if>
                            <div class="border-t border-gray-100 my-1"></div>
                            <a href="${pageContext.request.contextPath}/logout" class="block px-4 py-2 text-red-600 hover:bg-red-50 no-underline normal-case text-sm">
                                <i class="fas fa-sign-out-alt w-5"></i> Đăng xuất
                            </a>
                        </div>
                    </div>
                </c:when>
                <c:otherwise>
                    <a href="${pageContext.request.contextPath}/login" class="text-gray-500 hover:text-primary transition no-underline">Đăng nhập</a>
                </c:otherwise>
            </c:choose>
            <button id="darkToggleBtn" class="dark-toggle text-gray-500" title="Chế độ sáng/tối" onclick="toggleDarkMode()">
                <i id="darkIcon" class="fas fa-moon"></i>
            </button>
        </div>
    </div>
</div>

<%-- ===== Logo chính giữa ===== --%>
<header class="header-dark bg-white font-sans shadow-sm relative z-40">
    <div id="logoSection" class="header-dark bg-white border-b border-gray-100 flex items-center justify-center py-6 relative transition-all duration-300">
        <a href="${pageContext.request.contextPath}/" class="text-4xl font-serif font-black text-gray-900 tracking-tighter hover:text-primary transition no-underline flex items-center gap-2" style="color: #006389 !important;">
            <i class="fas fa-newspaper text-[32px]"></i> XYZ NEWS
        </a>
    </div>

    <div class="nav-bar-dark border-y border-gray-200 bg-white">
        <div class="max-w-6xl mx-auto px-4">
            <nav class="flex items-center justify-center gap-6 py-3 text-[14px] font-bold text-gray-700 w-full">
                <%-- Menu --%>
                <a href="${pageContext.request.contextPath}/" class="text-gray-700 hover:text-primary transition no-underline">Trang chủ</a>
                <c:forEach var="category" items="${categories}">
                    <c:set var="hasSub" value="${category.id == 'TECH' || category.id == 'SPORT' || category.id == 'ENT' || category.id == 'BUSINESS' || category.id == 'HEALTH' || category.name == 'Công nghệ' || category.name == 'Thể thao' || category.name == 'Giải trí' || category.name == 'Kinh doanh' || category.name == 'Sức khỏe'}" />
                    <div class="group relative">
                        <a href="${pageContext.request.contextPath}/news?action=category&id=${category.id}" 
                           class="text-gray-700 hover:text-primary transition nav-link px-0 block pb-1 no-underline ${category.id == param.id ? '!text-primary border-b-2 border-primary' : ''}">
                           ${category.name}
                           <c:if test="${hasSub}"><i class="fas fa-chevron-down text-[10px] ml-1"></i></c:if>
                        </a>
                        <c:if test="${hasSub}">
                            <div class="dropdown-dark absolute left-0 top-full hidden group-hover:block w-48 bg-white shadow-lg border-t-2 border-primary z-50 rounded-b-md overflow-hidden text-left font-normal mt-[1px]">
                                <c:if test="${category.id == 'TECH' || category.name == 'Công nghệ'}">
                                    <a href="${pageContext.request.contextPath}/news?action=category&id=${category.id}&subCategory=Thị trường" class="block px-4 py-2 text-gray-700 hover:bg-gray-50 hover:text-primary text-[13px] no-underline">Thị trường</a>
                                    <a href="${pageContext.request.contextPath}/news?action=category&id=${category.id}&subCategory=Chuyển đổi số" class="block px-4 py-2 text-gray-700 hover:bg-gray-50 hover:text-primary text-[13px] no-underline">Chuyển đổi số</a>
                                    <a href="${pageContext.request.contextPath}/news?action=category&id=${category.id}&subCategory=An ninh mạng" class="block px-4 py-2 text-gray-700 hover:bg-gray-50 hover:text-primary text-[13px] no-underline">An ninh mạng</a>
                                    <a href="${pageContext.request.contextPath}/news?action=category&id=${category.id}&subCategory=AI - Trí tuệ nhân tạo" class="block px-4 py-2 text-gray-700 hover:bg-gray-50 hover:text-primary text-[13px] no-underline">AI - Trí tuệ nhân tạo</a>
                                </c:if>
                                <c:if test="${category.id == 'SPORT' || category.name == 'Thể thao'}">
                                    <a href="${pageContext.request.contextPath}/news?action=category&id=${category.id}&subCategory=Bóng đá" class="block px-4 py-2 text-gray-700 hover:bg-gray-50 hover:text-primary text-[13px] no-underline">Bóng đá</a>
                                    <a href="${pageContext.request.contextPath}/news?action=category&id=${category.id}&subCategory=Tennis" class="block px-4 py-2 text-gray-700 hover:bg-gray-50 hover:text-primary text-[13px] no-underline">Tennis</a>
                                    <a href="${pageContext.request.contextPath}/news?action=category&id=${category.id}&subCategory=Esports" class="block px-4 py-2 text-gray-700 hover:bg-gray-50 hover:text-primary text-[13px] no-underline">Esports</a>
                                </c:if>
                                <c:if test="${category.id == 'ENT' || category.name == 'Giải trí'}">
                                    <a href="${pageContext.request.contextPath}/news?action=category&id=${category.id}&subCategory=Âm nhạc" class="block px-4 py-2 text-gray-700 hover:bg-gray-50 hover:text-primary text-[13px] no-underline">Âm nhạc</a>
                                    <a href="${pageContext.request.contextPath}/news?action=category&id=${category.id}&subCategory=Phim ảnh" class="block px-4 py-2 text-gray-700 hover:bg-gray-50 hover:text-primary text-[13px] no-underline">Phim ảnh</a>
                                    <a href="${pageContext.request.contextPath}/news?action=category&id=${category.id}&subCategory=ShowBUSINESS" class="block px-4 py-2 text-gray-700 hover:bg-gray-50 hover:text-primary text-[13px] no-underline">Showbiz</a>
                                </c:if>
                                <c:if test="${category.id == 'BUSINESS' || category.name == 'Kinh doanh'}">
                                    <a href="${pageContext.request.contextPath}/news?action=category&id=${category.id}&subCategory=Chứng khoán" class="block px-4 py-2 text-gray-700 hover:bg-gray-50 hover:text-primary text-[13px] no-underline">Chứng khoán</a>
                                    <a href="${pageContext.request.contextPath}/news?action=category&id=${category.id}&subCategory=Bất động sản" class="block px-4 py-2 text-gray-700 hover:bg-gray-50 hover:text-primary text-[13px] no-underline">Bất động sản</a>
                                    <a href="${pageContext.request.contextPath}/news?action=category&id=${category.id}&subCategory=Khởi nghiệp" class="block px-4 py-2 text-gray-700 hover:bg-gray-50 hover:text-primary text-[13px] no-underline">Khởi nghiệp</a>
                                </c:if>
                                <c:if test="${category.id == 'HEALTH' || category.name == 'Sức khỏe'}">
                                    <a href="${pageContext.request.contextPath}/news?action=category&id=${category.id}&subCategory=Dinh dưỡng" class="block px-4 py-2 text-gray-700 hover:bg-gray-50 hover:text-primary text-[13px] no-underline">Dinh dưỡng</a>
                                    <a href="${pageContext.request.contextPath}/news?action=category&id=${category.id}&subCategory=Y tế" class="block px-4 py-2 text-gray-700 hover:bg-gray-50 hover:text-primary text-[13px] no-underline">Y tế</a>
                                    <a href="${pageContext.request.contextPath}/news?action=category&id=${category.id}&subCategory=Làm đẹp" class="block px-4 py-2 text-gray-700 hover:bg-gray-50 hover:text-primary text-[13px] no-underline">Làm đẹp</a>
                                </c:if>
                            </div>
                        </c:if>
                    </div>
                </c:forEach>
                <form id="searchForm" action="${pageContext.request.contextPath}/news" method="GET" class="border-l pl-4 border-gray-300 flex items-center h-5 relative">
                    <input type="hidden" name="action" value="search">
                    <input type="text" id="searchInput" name="keyword" placeholder="Tìm kiếm..." class="text-[12px] px-2 py-1 border border-solid border-gray-200 rounded-md focus:outline-none focus:border-primary w-[130px] mr-2 transition-all duration-300 focus:w-[220px]" autocomplete="off">
                    <button type="submit" class="text-gray-500 hover:text-primary transition bg-transparent border-none">
                        <i class="fas fa-search text-sm"></i>
                    </button>
                    <%-- Auto-suggest box --%>
                    <div id="searchSuggestionBox" class="absolute hidden bg-white shadow-xl border border-gray-100 w-[350px] top-full right-0 mt-3 rounded-md z-[100] max-h-[400px] overflow-y-auto overflow-x-hidden flex-col">
                        <!-- Rendered via JS -->
                    </div>
                </form>
            </nav>
        </div>
    </div>
</header>

<%-- Script: Thu nhỏ Logo khi cuộn trang --%>
<script>
(function() {
    const logoSection = document.getElementById('logoSection');
    if (!logoSection) return;
    window.addEventListener('scroll', function() {
        if (window.scrollY > 80) {
            logoSection.classList.add('py-2');
            logoSection.classList.remove('py-6');
            logoSection.querySelector('a').classList.add('text-2xl');
            logoSection.querySelector('a').classList.remove('text-4xl');
            logoSection.querySelector('i').classList.add('text-[20px]');
            logoSection.querySelector('i').classList.remove('text-[32px]');
        } else {
            logoSection.classList.remove('py-2');
            logoSection.classList.add('py-6');
            logoSection.querySelector('a').classList.remove('text-2xl');
            logoSection.querySelector('a').classList.add('text-4xl');
            logoSection.querySelector('i').classList.remove('text-[20px]');
            logoSection.querySelector('i').classList.add('text-[32px]');
        }
    });
})();
</script>

</div> <%-- /stickyHeaderWrapper --%>

<script>
    function updateClock() {
        var now = new Date();
        var days = ['Chủ nhật', 'Thứ 2', 'Thứ 3', 'Thứ 4', 'Thứ 5', 'Thứ 6', 'Thứ 7'];
        var day = days[now.getDay()];
        var dd = String(now.getDate()).padStart(2, '0');
        var mm = String(now.getMonth() + 1).padStart(2, '0');
        var yyyy = now.getFullYear();
        var hh = String(now.getHours()).padStart(2, '0');
        var min = String(now.getMinutes()).padStart(2, '0');
        var ss = String(now.getSeconds()).padStart(2, '0');
        document.getElementById('clockText').textContent = day + ', ' + dd + '/' + mm + '/' + yyyy + ' - ' + hh + ':' + min + ':' + ss;
    }
    updateClock();
    setInterval(updateClock, 1000);

    (function loadWeather() {
        var weatherEl = document.getElementById('weatherInfo');
        fetch('https://wttr.in/Ho+Chi+Minh?format=%C+%t&lang=vi')
            .then(function(res) { return res.text(); })
            .then(function(data) {
                var parts = data.trim().split(/\s+/);
                var temp = parts[parts.length - 1]; 
                var condition = parts.slice(0, parts.length - 1).join(' ');
                
                var icon = 'fas fa-cloud-sun text-yellow-500';
                var condLower = condition.toLowerCase();
                if (condLower.includes('rain') || condLower.includes('mưa')) { icon = 'fas fa-cloud-rain text-blue-400'; } 
                else if (condLower.includes('clear') || condLower.includes('sunny') || condLower.includes('nắng')) { icon = 'fas fa-sun text-yellow-400'; } 
                else if (condLower.includes('cloud') || condLower.includes('mây')) { icon = 'fas fa-cloud text-gray-400'; } 
                else if (condLower.includes('thunder') || condLower.includes('sấm')) { icon = 'fas fa-bolt text-yellow-300'; }
                weatherEl.innerHTML = '<i class="' + icon + '"></i> TP.HCM ' + temp;
            })
            .catch(function() { weatherEl.innerHTML = '<i class="fas fa-cloud-sun text-yellow-500"></i> TP.HCM ~34°C'; });
    })();

    function toggleDarkMode() {
        var html = document.documentElement;
        var icon = document.getElementById('darkIcon');
        if (html.classList.contains('dark')) {
            html.classList.remove('dark');
            icon.className = 'fas fa-moon';
            localStorage.setItem('xyz_theme', 'light');
        } else {
            html.classList.add('dark');
            icon.className = 'fas fa-sun text-yellow-400';
            localStorage.setItem('xyz_theme', 'dark');
        }
    }

    (function() {
        var logoSection = document.getElementById('logoSection');
        if (!logoSection) return;
        var lastScroll = 0;
        window.addEventListener('scroll', function() {
            var currentScroll = window.pageYOffset || document.documentElement.scrollTop;
            if (currentScroll > 80) {
                logoSection.style.maxHeight = '0';
                logoSection.style.opacity = '0';
                logoSection.style.paddingTop = '0';
                logoSection.style.paddingBottom = '0';
            } else {
                logoSection.style.maxHeight = '200px';
                logoSection.style.opacity = '1';
                logoSection.style.paddingTop = '';
                logoSection.style.paddingBottom = '';
            }
            lastScroll = currentScroll;
        });
    })();
</script>

<%-- Script: Autocomplete Search --%>
<script>
document.addEventListener("DOMContentLoaded", function() {
    const searchInput = document.getElementById('searchInput');
    const suggestionBox = document.getElementById('searchSuggestionBox');
    let debounceTimer;

    if (!searchInput || !suggestionBox) return;

    searchInput.addEventListener('input', function() {
        clearTimeout(debounceTimer);
        const keyword = this.value.trim();
        
        if (keyword.length < 2) {
            suggestionBox.classList.add('hidden');
            suggestionBox.classList.remove('flex');
            return;
        }
        
        debounceTimer = setTimeout(() => {
            fetch('${pageContext.request.contextPath}/news?action=suggest&keyword=' + encodeURIComponent(keyword))
                .then(response => response.json())
                .then(data => {
                    suggestionBox.innerHTML = '';
                    if (data.length === 0) {
                        suggestionBox.innerHTML = '<div class="p-4 text-center text-gray-500 text-sm font-medium">Không tìm thấy bài viết phù hợp.</div>';
                    } else {
                        data.forEach(item => {
                            // Highlight keyword in title
                            const regex = new RegExp('(' + keyword.replace(/[.*+?^$()|{}\[\]\\]/g, '\\$&') + ')', 'gi');
                            const highlightedTitle = item.title.replace(regex, '<span class="text-primary font-black bg-yellow-100 px-0.5 rounded">$1</span>');
                            const imageUrl = item.image ? (item.image.startsWith('http') ? item.image : '${pageContext.request.contextPath}/' + item.image) : '${pageContext.request.contextPath}/assets/images/placeholder.jpg';
                            
                            const html = `
                                <a href="${pageContext.request.contextPath}/news?action=detail&id=`+item.id+`" class="flex gap-3 p-3 border-b border-gray-50 hover:bg-gray-50 transition no-underline items-start">
                                    <img src="`+imageUrl+`" class="w-16 h-16 object-cover rounded shadow-sm flex-shrink-0" alt="">
                                    <div class="flex flex-col gap-1 overflow-hidden">
                                        <div class="text-[13px] font-bold text-gray-800 leading-snug line-clamp-2" title="`+item.title.replace(/"/g, '&quot;')+`">`+highlightedTitle+`</div>
                                        <div class="text-[11px] text-gray-500 line-clamp-1">`+(item.shortContent || '')+`</div>
                                        <div class="text-[10px] text-gray-400 mt-auto"><i class="far fa-calendar-alt"></i> `+(item.postedDate || '')+`</div>
                                    </div>
                                </a>
                            `;
                            suggestionBox.insertAdjacentHTML('beforeend', html);
                        });
                    }
                    suggestionBox.classList.remove('hidden');
                    suggestionBox.classList.add('flex');
                })
                .catch(err => console.error("Error fetching suggestions:", err));
        }, 300);
    });

    // Ẩn box khi click ra ngoài
    document.addEventListener('click', function(e) {
        if (!searchInput.contains(e.target) && !suggestionBox.contains(e.target)) {
            suggestionBox.classList.add('hidden');
            suggestionBox.classList.remove('flex');
        }
    });
    
    // Hiện lại box khi focus vào ô tìm kiếm nếu đã có chữ
    searchInput.addEventListener('focus', function() {
        if (this.value.trim().length >= 2 && suggestionBox.innerHTML.trim() !== '') {
            suggestionBox.classList.remove('hidden');
            suggestionBox.classList.add('flex');
        }
    });
});
</script>