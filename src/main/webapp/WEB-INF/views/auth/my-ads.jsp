<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Quảng cáo của tôi - Dòng Chảy Tin Tức</title>
    
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
        @keyframes fadeInUp { from { opacity: 0; transform: translateY(20px); } to { opacity: 1; transform: translateY(0); } }
        .smooth-load { animation: fadeInUp 0.5s ease-out forwards; }
    </style>
</head>
<body class="bg-gray-50 text-gray-800 font-sans min-h-screen flex flex-col">
    <jsp:include page="../public/components/header.jsp" />

    <div class="bg-white border-b border-gray-200 py-10 text-center relative smooth-load">
        <div class="max-w-6xl mx-auto px-4 relative flex flex-col items-center">
            <a href="${pageContext.request.contextPath}/" class="absolute left-4 top-0 lg:top-1/2 lg:-translate-y-1/2 flex items-center gap-2 px-4 py-2 bg-white border border-gray-200 rounded-lg text-gray-700 hover:text-primary hover:border-primary transition font-semibold text-sm no-underline">
                <i class="fas fa-arrow-left"></i> Trang chủ
            </a>
            <h2 class="text-3xl font-serif font-bold text-gray-900 mb-2 mt-8 lg:mt-0">
                Lịch sử quảng cáo
            </h2>
            <p class="text-gray-500">Quản lý các chiến dịch quảng cáo đã đăng ký</p>
        </div>
    </div>

    <main class="max-w-6xl mx-auto px-4 py-12 flex-grow w-full smooth-load" style="animation-delay: 0.1s; opacity: 0;">
        <div class="bg-white rounded-2xl shadow-sm border border-gray-100 overflow-hidden">
            <div class="p-6">
                <c:choose>
                    <c:when test="${empty myAds}">
                        <div class="text-center py-10 text-gray-500">
                            <i class="fas fa-ad text-4xl mb-3 text-gray-300"></i>
                            <p>Bạn chưa có yêu cầu đặt quảng cáo nào.</p>
                            <a href="${pageContext.request.contextPath}/quang-cao/online" class="inline-block mt-4 px-6 py-2 bg-primary text-white font-bold rounded hover:bg-blue-700 transition">Xem báo giá quảng cáo</a>
                        </div>
                    </c:when>
                    <c:otherwise>
                        <div class="overflow-x-auto">
                            <table class="w-full text-left border-collapse">
                                <thead>
                                    <tr class="bg-gray-50 text-gray-600 text-sm uppercase">
                                        <th class="p-4 border-b font-semibold">Tên chiến dịch</th>
                                        <th class="p-4 border-b font-semibold">Ngày gửi</th>
                                        <th class="p-4 border-b font-semibold">Giá (VNĐ)</th>
                                        <th class="p-4 border-b font-semibold">Trạng thái</th>
                                        <th class="p-4 border-b font-semibold">Xem Banner</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:forEach var="ad" items="${myAds}">
                                        <tr class="border-b hover:bg-gray-50 transition">
                                            <td class="p-4">
                                                <div class="font-bold text-gray-800">${ad.campaignName}</div>
                                                <div class="text-xs text-gray-500 mt-1">
                                                    Vị trí: 
                                                    <c:choose>
                                                        <c:when test="${ad.positionId == 1}">Super Masthead</c:when>
                                                        <c:when test="${ad.positionId == 2}">Top Banner</c:when>
                                                        <c:when test="${ad.positionId == 3}">Medium Rectangle</c:when>
                                                        <c:when test="${ad.positionId == 4}">Sidebar Left</c:when>
                                                        <c:when test="${ad.positionId == 5}">Sidebar Right</c:when>
                                                        <c:otherwise>#${ad.positionId}</c:otherwise>
                                                    </c:choose>
                                                </div>
                                            </td>
                                            <td class="p-4 text-sm text-gray-600">
                                                <fmt:formatDate value="${ad.contract.createdAt}" pattern="dd/MM/yyyy HH:mm"/>
                                            </td>
                                            <td class="p-4 text-sm font-semibold text-primary">
                                                <fmt:formatNumber value="${ad.contract.totalPrice}" pattern="#,###"/> đ
                                            </td>
                                            <td class="p-4">
                                                <c:choose>
                                                    <c:when test="${ad.status == 'PENDING'}">
                                                        <span class="px-3 py-1 rounded-full text-xs font-bold bg-yellow-100 text-yellow-800">Chờ duyệt</span>
                                                    </c:when>
                                                    <c:when test="${ad.status == 'APPROVED'}">
                                                        <span class="px-3 py-1 rounded-full text-xs font-bold bg-blue-100 text-blue-800">Đã duyệt</span>
                                                    </c:when>
                                                    <c:when test="${ad.status == 'RUNNING'}">
                                                        <span class="px-3 py-1 rounded-full text-xs font-bold bg-green-100 text-green-800">Đang chạy</span>
                                                    </c:when>
                                                    <c:when test="${ad.status == 'REJECTED'}">
                                                        <span class="px-3 py-1 rounded-full text-xs font-bold bg-red-100 text-red-800">Từ chối</span>
                                                    </c:when>
                                                    <c:when test="${ad.status == 'STOPPED'}">
                                                        <span class="px-3 py-1 rounded-full text-xs font-bold bg-gray-200 text-gray-700">Đã dừng</span>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <span class="px-3 py-1 rounded-full text-xs font-bold bg-gray-100 text-gray-800">${ad.status}</span>
                                                    </c:otherwise>
                                                </c:choose>
                                            </td>
                                            <td class="p-4">
                                                <c:if test="${not empty ad.imageUrl}">
                                                    <a href="${ad.imageUrl}" target="_blank" class="text-primary hover:underline text-sm font-semibold"><i class="fas fa-image"></i> Xem</a>
                                                </c:if>
                                                <c:if test="${empty ad.imageUrl}">
                                                    <span class="text-gray-400 text-sm">N/A</span>
                                                </c:if>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                </tbody>
                            </table>
                        </div>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>
    </main>

    <jsp:include page="../public/components/footer.jsp" />
</body>
</html>
