<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Thông tin cá nhân - XYZ News</title>
    
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
                Hồ sơ của bạn
            </h2>
            <p class="text-gray-500">Quản lý thông tin cá nhân và bảo mật tài khoản</p>
        </div>
    </div>

    <main class="max-w-3xl mx-auto px-4 py-12 flex-grow w-full smooth-load" style="animation-delay: 0.1s; opacity: 0;">
        <div class="bg-white rounded-2xl shadow-sm border border-gray-100 overflow-hidden relative">
            <!-- Decorative Header -->
            <div class="h-32 bg-primary w-full absolute top-0 left-0"></div>

            <div class="p-8 pt-16 relative z-10 flex flex-col items-center">
                <!-- Avatar -->
                <div class="relative inline-block mb-6">
                    <div class="w-32 h-32 rounded-full border-4 border-white shadow-md overflow-hidden bg-white flex items-center justify-center relative z-10">
                        <c:choose>
                            <c:when test="${not empty sessionScope.currentUser.avatar}">
                                <img src="${pageContext.request.contextPath}/images/${sessionScope.currentUser.avatar}" class="w-full h-full object-cover">
                            </c:when>
                            <c:otherwise>
                                <div class="w-full h-full bg-primary text-white flex items-center justify-center text-4xl font-bold">
                                    ${sessionScope.currentUser.fullname.substring(0, 1).toUpperCase()}
                                </div>
                            </c:otherwise>
                        </c:choose>
                    </div>

                    <form action="${pageContext.request.contextPath}/profile" method="post" enctype="multipart/form-data" id="avatarForm">
                        <label for="avatarInput" class="absolute bottom-0 right-0 z-20 bg-white rounded-full p-2.5 shadow-md border border-gray-100 cursor-pointer text-primary hover:bg-gray-50 transition transform hover:scale-110 flex items-center justify-center" style="transform: translate(20%, 20%);">
                            <i class="fas fa-camera text-sm"></i>
                        </label>
                        <input type="file" id="avatarInput" name="avatar" accept="image/*" class="hidden" onchange="document.getElementById('avatarForm').submit();">
                    </form>
                </div>

                <!-- Name and Role -->
                <h3 class="text-2xl font-serif font-bold text-gray-900 mb-2">${sessionScope.currentUser.fullname}</h3>
                <div class="mb-8">
                    <span class="inline-flex items-center gap-1.5 px-3 py-1 rounded-full text-sm font-semibold 
                        ${sessionScope.currentUser.admin ? 'bg-red-100 text-red-700' : (sessionScope.currentUser.reporter ? 'bg-blue-100 text-blue-700' : 'bg-gray-100 text-gray-700')}">
                        <i class="fas ${sessionScope.currentUser.admin ? 'fa-crown' : (sessionScope.currentUser.reporter ? 'fa-pen' : 'fa-book-open')}"></i>
                        ${sessionScope.currentUser.roleText}
                    </span>
                </div>

                <!-- Main Form for Profile Text Fields -->
                <form action="${pageContext.request.contextPath}/profile" method="post" enctype="multipart/form-data" class="w-full">
                    <input type="hidden" name="action" value="updateProfile" />

                    <!-- Info Grid -->
                    <div class="w-full grid grid-cols-1 md:grid-cols-2 gap-6 mb-8 text-left">
                        <div class="bg-gray-50 rounded-xl p-4 border border-gray-100">
                            <div class="text-xs font-bold text-gray-500 uppercase tracking-wider mb-1 flex items-center gap-2">
                                <i class="fas fa-id-card text-gray-400"></i> Tên đăng nhập (ID)
                            </div>
                            <input type="text" class="w-full bg-gray-100 border border-gray-200 rounded-lg px-3 py-2 mt-1 text-gray-500 font-semibold cursor-not-allowed" value="${sessionScope.currentUser.id}" disabled />
                        </div>
                        <div class="bg-gray-50 rounded-xl p-4 border border-gray-100">
                            <div class="text-xs font-bold text-gray-500 uppercase tracking-wider mb-1 flex items-center gap-2">
                                <i class="fas fa-user text-gray-400"></i> Họ và tên
                            </div>
                            <input type="text" name="fullname" value="${sessionScope.currentUser.fullname}" class="w-full bg-white border border-gray-200 rounded-lg px-3 py-2 mt-1 focus:outline-none focus:ring-1 focus:ring-primary text-gray-900 font-semibold" required />
                        </div>
                        <div class="bg-gray-50 rounded-xl p-4 border border-gray-100">
                            <div class="text-xs font-bold text-gray-500 uppercase tracking-wider mb-1 flex items-center gap-2">
                                <i class="fas fa-envelope text-gray-400"></i> Địa chỉ Email
                            </div>
                            <input type="email" name="email" value="${sessionScope.currentUser.email}" class="w-full bg-white border border-gray-200 rounded-lg px-3 py-2 mt-1 focus:outline-none focus:ring-1 focus:ring-primary text-gray-900 font-semibold" required />
                        </div>
                        <div class="bg-gray-50 rounded-xl p-4 border border-gray-100">
                            <div class="text-xs font-bold text-gray-500 uppercase tracking-wider mb-1 flex items-center gap-2">
                                <i class="fas fa-phone text-gray-400"></i> Số điện thoại
                            </div>
                            <input type="text" name="mobile" value="${sessionScope.currentUser.mobile}" class="w-full bg-white border border-gray-200 rounded-lg px-3 py-2 mt-1 focus:outline-none focus:ring-1 focus:ring-primary text-gray-900 font-semibold" placeholder="Chưa cập nhật" />
                        </div>
                        <div class="bg-gray-50 rounded-xl p-4 border border-gray-100">
                            <div class="text-xs font-bold text-gray-500 uppercase tracking-wider mb-1 flex items-center gap-2">
                                <i class="fas fa-venus-mars text-gray-400"></i> Giới tính
                            </div>
                            <select name="gender" class="w-full bg-white border border-gray-200 rounded-lg px-3 py-2 mt-1 focus:outline-none focus:ring-1 focus:ring-primary text-gray-900 font-semibold">
                                <option value="true" ${sessionScope.currentUser.gender ? 'selected' : ''}>Nam</option>
                                <option value="false" ${not sessionScope.currentUser.gender ? 'selected' : ''}>Nữ</option>
                            </select>
                        </div>
                        <div class="bg-gray-50 rounded-xl p-4 border border-gray-100">
                            <div class="text-xs font-bold text-gray-500 uppercase tracking-wider mb-1 flex items-center gap-2">
                                <i class="fas fa-birthday-cake text-gray-400"></i> Ngày sinh
                            </div>
                            <fmt:formatDate value="${sessionScope.currentUser.birthday}" pattern="yyyy-MM-dd" var="formattedBirthday" />
                            <input type="date" name="birthday" value="${formattedBirthday}" class="w-full bg-white border border-gray-200 rounded-lg px-3 py-2 mt-1 focus:outline-none focus:ring-1 focus:ring-primary text-gray-900 font-semibold" />
                        </div>

                        <!-- Các trường hiển thị thêm cho Nhà báo/Quản trị -->
                        <c:if test="${sessionScope.currentUser.reporter || sessionScope.currentUser.admin}">
                            <div class="bg-gray-50 rounded-xl p-4 border border-gray-100 md:col-span-2">
                                <div class="text-xs font-bold text-gray-500 uppercase tracking-wider mb-1 flex items-center gap-2">
                                    <i class="fas fa-signature text-gray-400"></i> Bút danh hiển thị
                                </div>
                                <input type="text" name="penName" value="${sessionScope.currentUser.penName}" class="w-full bg-white border border-gray-200 rounded-lg px-3 py-2 mt-1 focus:outline-none focus:ring-1 focus:ring-primary text-gray-900 font-semibold" placeholder="Nhập bút danh hiển thị trên bài viết..." />
                            </div>
                            <div class="bg-gray-50 rounded-xl p-4 border border-gray-100 md:col-span-2">
                                <div class="text-xs font-bold text-gray-500 uppercase tracking-wider mb-1 flex items-center gap-2">
                                    <i class="fas fa-address-card text-gray-400"></i> Tiểu sử ngắn (Bio)
                                </div>
                                <textarea name="bio" rows="3" class="w-full bg-white border border-gray-200 rounded-lg px-3 py-2 mt-1 focus:outline-none focus:ring-1 focus:ring-primary text-gray-900 font-semibold" placeholder="Giới thiệu một chút về bản thân bạn...">${sessionScope.currentUser.bio}</textarea>
                            </div>
                        </c:if>
                    </div>

                    <!-- Actions -->
                    <div class="flex flex-wrap justify-center gap-4 w-full pt-6 border-t border-gray-100">
                        <button type="submit" class="flex items-center gap-2 px-6 py-2.5 rounded-lg bg-emerald-600 text-white font-bold hover:bg-emerald-700 shadow-md hover:shadow-lg transition-all transform hover:-translate-y-0.5 border-none cursor-pointer">
                            <i class="fas fa-save"></i> Lưu thay đổi
                        </button>
                        <a href="${pageContext.request.contextPath}/change-password" class="flex items-center gap-2 px-6 py-2.5 rounded-lg border-2 border-primary text-primary font-bold hover:bg-primary hover:text-white transition-colors no-underline">
                            <i class="fas fa-key"></i> Đổi mật khẩu
                        </a>
                        <c:if test="${sessionScope.currentUser.reporter || sessionScope.currentUser.admin}">
                            <c:set var="myNewsUrl" value="${sessionScope.currentUser.admin ? '/admin/news' : '/reporter/news'}" />
                            <a href="${pageContext.request.contextPath}${myNewsUrl}" class="flex items-center gap-2 px-6 py-2.5 rounded-lg bg-primary text-white font-bold shadow-md hover:bg-[#004c6b] hover:shadow-lg transition-all transform hover:-translate-y-0.5 no-underline">
                                <i class="fas fa-list-alt"></i> ${sessionScope.currentUser.admin ? 'Quản trị trang' : 'Bài viết của tôi'}
                            </a>
                        </c:if>
                        <a href="${pageContext.request.contextPath}/" class="flex items-center gap-2 px-6 py-2.5 rounded-lg bg-gray-100 text-gray-700 font-bold hover:bg-gray-200 transition-colors no-underline">
                            <i class="fas fa-newspaper"></i> Đọc tin tức
                        </a>
                    </div>
                </form>
            </div>
        </div>
    </main>

    <jsp:include page="../public/components/footer.jsp" />
</body>
</html>