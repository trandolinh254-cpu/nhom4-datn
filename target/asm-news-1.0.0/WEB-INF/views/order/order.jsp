<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Đặt báo - XYZ News</title>

    <link href="https://fonts.googleapis.com/css2?family=Merriweather:wght@400;700;900&family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:wght,FILL@100..700,0..1&display=swap" rel="stylesheet">
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
        /* Material Symbols config */
        .material-symbols-outlined {
            font-variation-settings: 'FILL' 0, 'wght' 400, 'GRAD' 0, 'opsz' 24;
        }
        .icon-fill {
            font-variation-settings: 'FILL' 1, 'wght' 400, 'GRAD' 0, 'opsz' 24;
        }
        /* Animation cho các section xuất hiện */
        @keyframes fadeInUp {
            from { opacity: 0; transform: translateY(20px); }
            to { opacity: 1; transform: translateY(0); }
        }
        .smooth-load { animation: fadeInUp 0.5s ease-out forwards; }
    </style>
</head>
<body class="bg-gray-50 text-gray-800 font-sans min-h-screen flex flex-col">

    <%-- Header chung project --%>
    <jsp:include page="../public/components/header.jsp" />

    <%-- Thông báo thành công / lỗi --%>
    <c:if test="${not empty sessionScope.successMessage}">
        <div id="alertSuccess" class="max-w-6xl mx-auto px-4 mt-4">
            <div class="bg-green-50 border border-green-200 text-green-800 px-6 py-4 rounded-xl flex items-center gap-3 shadow-sm">
                <span class="material-symbols-outlined icon-fill text-green-600">check_circle</span>
                <span class="font-medium">${sessionScope.successMessage}</span>
                <button onclick="this.parentElement.parentElement.remove()" class="ml-auto text-green-600 hover:text-green-800">
                    <span class="material-symbols-outlined">close</span>
                </button>
            </div>
        </div>
        <c:remove var="successMessage" scope="session"/>
    </c:if>
    <c:if test="${not empty sessionScope.errorMessage}">
        <div id="alertError" class="max-w-6xl mx-auto px-4 mt-4">
            <div class="bg-red-50 border border-red-200 text-red-800 px-6 py-4 rounded-xl flex items-center gap-3 shadow-sm">
                <span class="material-symbols-outlined icon-fill text-red-600">error</span>
                <span class="font-medium">${sessionScope.errorMessage}</span>
                <button onclick="this.parentElement.parentElement.remove()" class="ml-auto text-red-600 hover:text-red-800">
                    <span class="material-symbols-outlined">close</span>
                </button>
            </div>
        </div>
        <c:remove var="errorMessage" scope="session"/>
    </c:if>

    <main class="max-w-6xl mx-auto px-4 py-10 flex-grow w-full smooth-load">

        <%-- Header trang --%>
        <header class="mb-10 border-b border-gray-200 pb-4">
            <h1 class="text-4xl font-serif font-bold text-gray-900 mb-2">
                Đặt báo XYZ News
                <span class="text-primary font-light block md:inline text-2xl">— Kết nối tri thức</span>
            </h1>
            <p class="text-lg text-gray-600 max-w-3xl leading-relaxed">
                Lựa chọn hình thức đọc báo phù hợp với bạn. Trải nghiệm tin tức chuyên sâu,
                chính xác và nhanh chóng nhất từ đội ngũ phóng viên chuyên nghiệp.
            </p>
        </header>

        <%-- Form đặt báo: bao bọc toàn bộ dữ liệu (loại báo, gói, thông tin giao nhận) --%>
        <form action="${pageContext.request.contextPath}/order" method="POST"
              class="grid grid-cols-1 lg:grid-cols-12 gap-8 items-start">

            <%-- ==================== CỘT TRÁI: Chọn gói + Thông tin ==================== --%>
            <div class="lg:col-span-8 flex flex-col gap-10">

                <%-- SECTION 1: Loại báo --%>
                <section>
                    <h2 class="text-2xl font-serif font-bold text-gray-900 mb-4 flex items-center gap-2">
                        <span class="material-symbols-outlined text-primary icon-fill">category</span> Loại báo
                    </h2>

                    <div class="grid grid-cols-1 md:grid-cols-1 gap-4">
                        <%-- Báo Điện tử --%>
                        <label class="relative flex flex-col p-5 border border-gray-200 bg-white rounded-xl cursor-pointer hover:border-primary transition-all group overflow-hidden">
                            <input name="newspaper_type" type="radio" value="digital" class="peer sr-only" onchange="updateSummary()" checked/>
                            <div class="absolute inset-0 bg-blue-50/50 opacity-0 peer-checked:opacity-100 transition-opacity"></div>
                            <div class="absolute inset-0 border-2 border-transparent peer-checked:border-primary rounded-xl pointer-events-none"></div>
                            <div class="relative z-10 flex items-start gap-4">
                                <div class="bg-gray-100 p-3 rounded-full text-gray-500 group-hover:text-primary transition-colors">
                                    <span class="material-symbols-outlined icon-fill">devices</span>
                                </div>
                                <div>
                                    <h3 class="text-xl font-bold text-gray-900 mb-1">Báo Điện tử <span class="text-primary text-sm align-top">Premium</span></h3>
                                    <p class="text-sm text-gray-600">Truy cập không giới hạn bài viết chuyên sâu, không quảng cáo trên mọi thiết bị.</p>
                                </div>
                            </div>
                        </label>
                    </div>
                </section>

                <%-- SECTION 2: Gói đặt báo --%>
                <section>
                    <h2 class="text-2xl font-serif font-bold text-gray-900 mb-4 flex items-center gap-2">
                        <span class="material-symbols-outlined text-primary icon-fill">subscriptions</span> Gói đặt báo
                    </h2>
                    <div class="grid grid-cols-1 md:grid-cols-3 gap-4">

                        <%-- Gói 3 tháng --%>
                        <label class="cursor-pointer border border-gray-200 bg-white rounded-xl p-5 flex flex-col hover:shadow-md transition-all relative group">
                            <%-- FIX: Bắt tham số duration từ URL --%>
                            <input type="radio" name="package_duration" value="3_months" class="peer sr-only" required onchange="updateSummary()" ${param.duration == '3_months' ? 'checked' : ''}>
                            <div class="absolute inset-0 border-2 border-transparent peer-checked:border-primary rounded-xl pointer-events-none transition-colors"></div>
                            <div class="mb-auto">
                                <h3 class="text-xs font-bold uppercase tracking-wider text-gray-500 mb-2">Gói Ngắn Hạn</h3>
                                <div class="text-4xl font-bold text-gray-900">3 <span class="text-xl font-normal text-gray-500">tháng</span></div>
                                <div class="text-2xl font-bold text-primary mt-4">250.000đ</div>
                                <p class="text-sm text-gray-500 mt-2 italic">Phù hợp trải nghiệm thử.</p>
                            </div>
                            
                            <div class="relative z-10 mt-4 w-full border border-primary text-primary text-xs font-bold uppercase tracking-wider py-2.5 rounded-lg text-center peer-checked:bg-primary peer-checked:text-white transition-colors">
                                <span class="block peer-checked:hidden">Chọn gói</span>
                                <span class="hidden peer-checked:block">Đã chọn</span>
                            </div>
                        </label>

                        <%-- Gói 6 tháng (Phổ biến nhất) --%>
                        <label class="cursor-pointer border border-gray-200 bg-white rounded-xl p-5 flex flex-col hover:shadow-md transition-all relative overflow-hidden transform md:-translate-y-2 group">
                            <%-- FIX: Bắt tham số duration từ URL --%>
                            <input type="radio" name="package_duration" value="6_months" class="peer sr-only" onchange="updateSummary()" ${empty param.duration or param.duration == '6_months' ? 'checked' : ''}>
                            
                            <div class="absolute inset-0 border-2 border-transparent peer-checked:border-primary rounded-xl pointer-events-none transition-colors"></div>
                            <div class="absolute top-0 right-0 bg-primary text-white text-[10px] font-bold uppercase px-3 py-1 rounded-bl-lg z-10">Phổ biến nhất</div>
                            
                            <div class="mb-auto relative z-10">
                                <h3 class="text-xs font-bold uppercase tracking-wider text-primary mb-2">Gói Bán Niên</h3>
                                <div class="text-4xl font-bold text-gray-900">6 <span class="text-xl font-normal text-gray-500">tháng</span></div>
                                <div class="text-2xl font-bold text-primary mt-4">480.000đ</div>
                                <p class="text-sm text-gray-500 mt-2 italic">Tiết kiệm 20.000đ so với gói 3 tháng.</p>
                            </div>
                            
                            <div class="relative z-10 mt-4 w-full border border-primary text-primary text-xs font-bold uppercase tracking-wider py-2.5 rounded-lg text-center peer-checked:bg-primary peer-checked:text-white transition-colors">
                                <span class="block peer-checked:hidden">Chọn gói</span>
                                <span class="hidden peer-checked:block">Đã chọn</span>
                            </div>
                        </label>

                        <%-- Gói 12 tháng --%>
                        <label class="cursor-pointer border border-gray-200 bg-white rounded-xl p-5 flex flex-col hover:shadow-md transition-all relative group">
                            <%-- FIX: Bắt tham số duration từ URL --%>
                            <input type="radio" name="package_duration" value="12_months" class="peer sr-only" onchange="updateSummary()" ${param.duration == '12_months' ? 'checked' : ''}>
                            <div class="absolute inset-0 border-2 border-transparent peer-checked:border-primary rounded-xl pointer-events-none transition-colors"></div>
                            <div class="mb-auto">
                                <h3 class="text-xs font-bold uppercase tracking-wider text-gray-500 mb-2">Gói Thường Niên</h3>
                                <div class="text-4xl font-bold text-gray-900">12 <span class="text-xl font-normal text-gray-500">tháng</span></div>
                                <div class="text-2xl font-bold text-primary mt-4">900.000đ</div>
                                <p class="text-sm text-gray-500 mt-2 italic">Lựa chọn tiết kiệm nhất. Tặng kèm 1 tháng.</p>
                            </div>
                            
                            <div class="relative z-10 mt-4 w-full border border-primary text-primary text-xs font-bold uppercase tracking-wider py-2.5 rounded-lg text-center peer-checked:bg-primary peer-checked:text-white transition-colors">
                                <span class="block peer-checked:hidden">Chọn gói</span>
                                <span class="hidden peer-checked:block">Đã chọn</span>
                            </div>
                        </label>
                    </div>
                </section>

                <%-- SECTION 3: Thông tin giao nhận --%>
                <section>
                    <h2 class="text-2xl font-serif font-bold text-gray-900 mb-4 flex items-center gap-2">
                        <span class="material-symbols-outlined text-primary icon-fill">local_shipping</span> Thông tin giao nhận
                    </h2>
                    <div class="bg-white border border-gray-200 rounded-xl p-6 grid grid-cols-1 md:grid-cols-2 gap-4">
                        <div class="md:col-span-2">
                            <label class="block text-xs font-bold uppercase tracking-wider text-gray-500 mb-1.5">Họ và tên người nhận *</label>
                            <input name="fullName" value="${prefillName}"
                                   class="w-full border border-gray-300 rounded-lg p-3 text-base focus:border-primary focus:ring-1 focus:ring-primary outline-none transition-shadow bg-gray-50"
                                   placeholder="Nhập họ và tên..." type="text" required/>
                        </div>
                        <div>
                            <label class="block text-xs font-bold uppercase tracking-wider text-gray-500 mb-1.5">Số điện thoại *</label>
                            <input name="phone"
                                   class="w-full border border-gray-300 rounded-lg p-3 text-base focus:border-primary focus:ring-1 focus:ring-primary outline-none transition-shadow bg-gray-50"
                                   placeholder="09x xxx xxxx" type="tel" required/>
                        </div>
                        <div>
                            <label class="block text-xs font-bold uppercase tracking-wider text-gray-500 mb-1.5">Email</label>
                            <input name="email" value="${prefillEmail}"
                                   class="w-full border border-gray-300 rounded-lg p-3 text-base focus:border-primary focus:ring-1 focus:ring-primary outline-none transition-shadow bg-gray-50"
                                   placeholder="email@example.com" type="email"/>
                        </div>

                        <div class="md:col-span-2">
                            <label class="block text-xs font-bold uppercase tracking-wider text-gray-500 mb-1.5">Địa chỉ giao báo *</label>
                            <div class="flex flex-col gap-3">
                                <div class="grid grid-cols-1 md:grid-cols-3 gap-3">
                                    <select id="selectCity" name="city" required
                                            class="border border-gray-300 rounded-lg p-3 text-base focus:border-primary focus:ring-1 focus:ring-primary outline-none bg-gray-50"
                                            onchange="loadDistricts(this.value)">
                                        <option value="">Chọn Tỉnh/Thành phố</option>
                                    </select>
                                    <select id="selectDistrict" name="district" required
                                            class="border border-gray-300 rounded-lg p-3 text-base focus:border-primary focus:ring-1 focus:ring-primary outline-none bg-gray-50"
                                            onchange="loadWards(this.value)" disabled>
                                        <option value="">Chọn Quận/Huyện</option>
                                    </select>
                                    <select id="selectWard" name="ward" required
                                            class="border border-gray-300 rounded-lg p-3 text-base focus:border-primary focus:ring-1 focus:ring-primary outline-none bg-gray-50"
                                            disabled>
                                        <option value="">Chọn Phường/Xã</option>
                                    </select>
                                </div>
                                <input name="addressDetail"
                                       class="w-full border border-gray-300 rounded-lg p-3 text-base focus:border-primary focus:ring-1 focus:ring-primary outline-none transition-shadow bg-gray-50"
                                       placeholder="Số nhà, Tên đường, Tòa nhà..." type="text" required/>
                            </div>
                        </div>

                        <div class="md:col-span-2 mt-2">
                            <label class="block text-xs font-bold uppercase tracking-wider text-gray-500 mb-1.5">Ghi chú (Tùy chọn)</label>
                            <textarea name="note" rows="2"
                                      class="w-full border border-gray-300 rounded-lg p-3 text-base focus:border-primary focus:ring-1 focus:ring-primary outline-none transition-shadow bg-gray-50"
                                      placeholder="Hướng dẫn giao hàng chi tiết..."></textarea>
                        </div>
                    </div>
                </section>
            </div>

            <%-- ==================== CỘT PHẢI: Tóm tắt đơn hàng ==================== --%>
            <div class="lg:col-span-4 mt-10 lg:mt-0">
                <div class="bg-white border border-gray-200 rounded-xl p-6 sticky top-[140px] shadow-sm">
                    <h3 class="text-xl font-serif font-bold text-gray-900 border-b border-gray-200 pb-3 mb-4">Tóm tắt đơn hàng</h3>

                    <div class="flex justify-between items-center py-2">
                        <span class="text-gray-600">Loại báo:</span>
                        <span id="summaryType" class="font-bold text-gray-900">Báo Điện tử Premium</span>
                    </div>
                    <div class="flex justify-between items-center py-2">
                        <span class="text-gray-600">Gói thời gian:</span>
                        <span id="summaryDuration" class="font-bold text-gray-900">6 Tháng</span>
                    </div>
                    <div class="flex justify-between items-center py-2 border-b border-gray-200 mb-4 pb-4">
                        <span class="text-gray-600">Phí giao hàng:</span>
                        <span class="text-gray-500">Miễn phí</span>
                    </div>
                    <div class="flex justify-between items-end mb-5">
                        <span class="text-lg text-gray-900 font-bold">Tổng cộng:</span>
                        <span id="summaryTotal" class="text-2xl font-bold text-primary">480.000đ</span>
                    </div>

                    <p class="text-sm text-gray-500 italic mb-5 text-center">
                        Bằng việc đặt mua, bạn đồng ý với
                        <a class="text-primary hover:underline" href="#">Điều khoản sử dụng</a> của XYZ News.
                    </p>

                    <%-- Nút thanh toán submit form --%>
                    <button type="submit"
                            class="w-full bg-primary text-white text-xl font-bold py-4 rounded-xl hover:bg-[#004c6b] transition-colors shadow-sm flex items-center justify-center gap-2">
                        Thanh toán ngay <span class="material-symbols-outlined">arrow_forward</span>
                    </button>

                    <div class="mt-3 flex justify-center gap-4 text-gray-400">
                        <span class="material-symbols-outlined">payments</span>
                        <span class="material-symbols-outlined">credit_card</span>
                        <span class="material-symbols-outlined">account_balance</span>
                    </div>
                </div>
            </div>
        </form>
    </main>

    <%-- Footer chung project --%>
    <jsp:include page="../public/components/footer.jsp" />

    <%-- JavaScript: Cập nhật tóm tắt đơn hàng real-time khi user chọn gói --%>
    <script>
        // Bảng giá và tên hiển thị
        var priceMap = {
            '3_months': { price: '250.000đ', label: '3 Tháng' },
            '6_months': { price: '480.000đ', label: '6 Tháng' },
            '12_months': { price: '900.000đ', label: '12 Tháng' }
        };
        var typeMap = {

            'digital': 'Báo Điện tử Premium'
        };

        /**
         * Cập nhật phần tóm tắt đơn hàng khi user thay đổi lựa chọn
         */
        function updateSummary() {
            // Lấy loại báo đang chọn
            var typeRadio = document.querySelector('input[name="newspaper_type"]:checked');
            if (typeRadio) {
                document.getElementById('summaryType').textContent = typeMap[typeRadio.value] || 'Báo Điện tử Premium';
            }

            // Lấy gói thời gian đang chọn
            var durationRadio = document.querySelector('input[name="package_duration"]:checked');
            if (durationRadio) {
                var info = priceMap[durationRadio.value];
                if (info) {
                    document.getElementById('summaryDuration').textContent = info.label;
                    document.getElementById('summaryTotal').textContent = info.price;
                }
            }
        }

        // FIX: Tự động chạy tính năng cập nhật giỏ hàng ngay khi tải trang xong
        document.addEventListener('DOMContentLoaded', function() {
            updateSummary();
        });

        // Tự động ẩn thông báo sau 5 giây
        setTimeout(function() {
            var alerts = document.querySelectorAll('#alertSuccess, #alertError');
            alerts.forEach(function(el) {
                el.style.transition = 'opacity 0.5s';
                el.style.opacity = '0';
                setTimeout(function() { el.remove(); }, 500);
            });
        }, 5000);

        // === ĐỊA CHỈ CASCADE 3 CẤP (Tỉnh → Quận → Phường) ===
        // Sử dụng API miễn phí: provinces.open-api.vn
        var API_BASE = 'https://provinces.open-api.vn/api';

        // Load danh sách Tỉnh/Thành phố khi trang mở
        (function loadProvinces() {
            fetch(API_BASE + '/p/')
                .then(function(res) { return res.json(); })
                .then(function(data) {
                    var select = document.getElementById('selectCity');
                    data.forEach(function(province) {
                        var opt = document.createElement('option');
                        opt.value = province.code;
                        opt.textContent = province.name;
                        // Lưu tên để gửi về server (thay vì mã số)
                        opt.setAttribute('data-name', province.name);
                        select.appendChild(opt);
                    });
                })
                .catch(function() {
                    console.error('Không thể tải danh sách tỉnh/thành phố');
                });
        })();

        // Load Quận/Huyện khi chọn Tỉnh
        function loadDistricts(provinceCode) {
            var districtSelect = document.getElementById('selectDistrict');
            var wardSelect = document.getElementById('selectWard');

            // Reset
            districtSelect.innerHTML = '<option value="">Chọn Quận/Huyện</option>';
            wardSelect.innerHTML = '<option value="">Chọn Phường/Xã</option>';
            districtSelect.disabled = true;
            wardSelect.disabled = true;

            if (!provinceCode) return;

            fetch(API_BASE + '/p/' + provinceCode + '?depth=2')
                .then(function(res) { return res.json(); })
                .then(function(data) {
                    data.districts.forEach(function(district) {
                        var opt = document.createElement('option');
                        opt.value = district.code;
                        opt.textContent = district.name;
                        opt.setAttribute('data-name', district.name);
                        districtSelect.appendChild(opt);
                    });
                    districtSelect.disabled = false;
                })
                .catch(function() {
                    console.error('Không thể tải danh sách quận/huyện');
                });
        }

        // Load Phường/Xã khi chọn Quận
        function loadWards(districtCode) {
            var wardSelect = document.getElementById('selectWard');
            // Reset
            wardSelect.innerHTML = '<option value="">Chọn Phường/Xã</option>';
            wardSelect.disabled = true;

            if (!districtCode) return;

            fetch(API_BASE + '/d/' + districtCode + '?depth=2')
                .then(function(res) { return res.json(); })
                .then(function(data) {
                    data.wards.forEach(function(ward) {
                        var opt = document.createElement('option');
                        opt.value = ward.code;
                        opt.textContent = ward.name;
                        opt.setAttribute('data-name', ward.name);
                        wardSelect.appendChild(opt);
                    });
                    wardSelect.disabled = false;
                })
                .catch(function() {
                    console.error('Không thể tải danh sách phường/xã');
                });
        }
    </script>
</body>
</html>