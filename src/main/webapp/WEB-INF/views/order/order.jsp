<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Đăng ký Premium AI - XYZ News</title>

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
                Đăng ký Premium AI XYZ News <!-- // FIX -->
                <span class="text-primary font-light block md:inline text-2xl">— Trải nghiệm dịch vụ AI</span> <!-- // FIX -->
            </h1>
            <p class="text-lg text-gray-600 max-w-3xl leading-relaxed">
                Lựa chọn gói dịch vụ phù hợp với bạn. Trải nghiệm không giới hạn trợ lý ảo AI Chat, dịch thuật đa ngôn ngữ và tóm tắt bài viết tự động. <!-- // FIX -->
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
                        <span class="material-symbols-outlined text-primary icon-fill">smart_toy</span> Chọn dịch vụ Premium <!-- // FIX -->
                    </h2>

                    <div class="grid grid-cols-1 md:grid-cols-1 gap-4">
                        <%-- Báo Điện tử --%>
                        <label class="relative flex flex-col p-5 border border-gray-200 bg-white rounded-xl cursor-pointer hover:border-primary transition-all group overflow-hidden">
                            <input name="newspaper_type" type="radio" value="digital" class="peer sr-only" onchange="updateSummary()" checked/>
                            <div class="absolute inset-0 bg-blue-50/50 opacity-0 peer-checked:opacity-100 transition-opacity"></div>
                            <div class="absolute inset-0 border-2 border-transparent peer-checked:border-primary rounded-xl pointer-events-none"></div>
                            <div class="relative z-10 flex items-start gap-4">
                                <div class="bg-gray-100 p-3 rounded-full text-gray-500 group-hover:text-primary transition-colors">
                                    <span class="material-symbols-outlined icon-fill">smart_toy</span> <!-- // FIX -->
                                </div>
                                <div>
                                    <h3 class="text-xl font-bold text-gray-900 mb-1">XYZ Premium AI</h3> <!-- // FIX -->
                                    <p class="text-sm text-gray-600">Trợ lý ảo AI Chat thông minh, dịch thuật đa ngôn ngữ chuẩn xác, tóm tắt tự động không giới hạn.</p> <!-- // FIX -->
                                </div>
                            </div>
                        </label>
                    </div>
                </section>

                <%-- SECTION 2: Gói Premium --%>
                <section>
                    <h2 class="text-2xl font-serif font-bold text-gray-900 mb-4 flex items-center gap-2">
                        <span class="material-symbols-outlined text-primary icon-fill">subscriptions</span> Gói Premium
                    </h2>
                    <div class="grid grid-cols-1 gap-4"> <!-- // FIX -->
                        <%-- Gói Premium Trọn Đời duy nhất --%>
                        <label class="relative flex flex-col p-5 border border-primary bg-blue-50/50 rounded-xl cursor-default overflow-hidden"> <!-- // FIX -->
                            <input type="radio" name="package_duration" value="lifetime" class="peer sr-only" checked required onchange="updateSummary()"/> <!-- // FIX -->
                            <div class="absolute inset-0 border-2 border-primary rounded-xl pointer-events-none"></div> <!-- // FIX -->
                            <div class="absolute top-0 right-0 bg-primary text-white text-[10px] font-bold uppercase px-3 py-1 rounded-bl-lg z-10">Ưu đãi trọn đời</div> <!-- // FIX -->
                            <div class="relative z-10 flex flex-col md:flex-row md:items-center justify-between gap-4 w-full"> <!-- // FIX -->
                                <div> <!-- // FIX -->
                                    <h3 class="text-lg font-bold text-gray-900 mb-1">Gói Premium Trọn Đời</h3> <!-- // FIX -->
                                    <p class="text-sm text-gray-600">Sở hữu vĩnh viễn và không giới hạn dịch vụ AI Chat trợ lý ảo, dịch thuật đa ngôn ngữ và tóm tắt tự động.</p> <!-- // FIX -->
                                </div> <!-- // FIX -->
                                <div class="text-left md:text-right flex-shrink-0"> <!-- // FIX -->
                                    <div class="text-3xl font-bold text-primary">990.000đ</div> <!-- // FIX -->
                                    <div class="text-[11px] text-gray-500 italic mt-0.5">Thanh toán một lần duy nhất</div> <!-- // FIX -->
                                </div> <!-- // FIX -->
                            </div> <!-- // FIX -->
                        </label> <!-- // FIX -->
                    </div> <!-- // FIX -->
                </section>

                <%-- SECTION 3: Thông tin tài khoản đăng ký --%>
                <section>
                    <h2 class="text-2xl font-serif font-bold text-gray-900 mb-4 flex items-center gap-2">
                        <span class="material-symbols-outlined text-primary icon-fill">person</span> Thông tin tài khoản đăng ký
                    </h2>
                    <div class="bg-white border border-gray-200 rounded-xl p-6 grid grid-cols-1 md:grid-cols-2 gap-4">
                        <div class="md:col-span-2">
                            <label class="block text-xs font-bold uppercase tracking-wider text-gray-500 mb-1.5">Họ và tên *</label>
                            <input name="fullName" value="${prefillName}"
                                   class="w-full border border-gray-300 rounded-lg p-3 text-base focus:border-primary focus:ring-1 focus:ring-primary outline-none transition-shadow bg-gray-50"
                                   placeholder="Nhập họ và tên..." type="text" required/>
                        </div>
                        <div>
                            <label class="block text-xs font-bold uppercase tracking-wider text-gray-500 mb-1.5">Số điện thoại *</label>
                            <input name="phone" oninput="updateQR()"
                                   class="w-full border border-gray-300 rounded-lg p-3 text-base focus:border-primary focus:ring-1 focus:ring-primary outline-none transition-shadow bg-gray-50"
                                   placeholder="09x xxx xxxx" type="tel" required/>
                        </div>
                        <div>
                            <label class="block text-xs font-bold uppercase tracking-wider text-gray-500 mb-1.5">Email *</label>
                            <input name="email" value="${prefillEmail}" oninput="updateQR()"
                                   class="w-full border border-gray-300 rounded-lg p-3 text-base focus:border-primary focus:ring-1 focus:ring-primary outline-none transition-shadow bg-gray-50"
                                   placeholder="email@example.com" type="email" required/>
                        </div>

                        <%-- Hidden inputs to satisfy OrderServlet validation and database requirements for physical address --%>
                        <input type="hidden" name="city" value="Online" />
                        <input type="hidden" name="district" value="Online" />
                        <input type="hidden" name="ward" value="Online" />
                        <input type="hidden" name="addressDetail" value="Premium Online" />
                        <input type="hidden" name="note" value="Đăng ký tài khoản Premium trực tuyến" />
                    </div>
                </section>

                <%-- SECTION 4: Phương thức thanh toán (VietQR) --%>
                <section>
                    <h2 class="text-2xl font-serif font-bold text-gray-900 mb-4 flex items-center gap-2">
                        <span class="material-symbols-outlined text-primary icon-fill">payments</span> Phương thức thanh toán
                    </h2>
                    <div class="bg-white border border-gray-200 rounded-xl p-6 flex flex-col gap-6">
                        <div class="grid grid-cols-1 md:grid-cols-2 gap-4">
                            <%-- Thanh toán khi nhận hàng --%>
                            <label class="relative flex items-center gap-3 p-4 border border-gray-200 rounded-xl cursor-pointer hover:border-primary transition-all">
                                <input type="radio" name="payment_method_option" value="cod" class="peer h-4 w-4 text-primary focus:ring-primary" checked onchange="togglePaymentDetail()"/>
                                <div class="flex items-center gap-3">
                                    <span class="material-symbols-outlined text-gray-500">local_shipping</span>
                                    <div>
                                        <h4 class="font-bold text-gray-900 text-sm">Thanh toán sau (COD / Offline)</h4>
                                        <p class="text-[11px] text-gray-500">Kích hoạt offline bởi nhân viên</p>
                                    </div>
                                </div>
                            </label>

                            <%-- Chuyển khoản ngân hàng VietQR --%>
                            <label class="relative flex items-center gap-3 p-4 border border-gray-200 rounded-xl cursor-pointer hover:border-primary transition-all">
                                <input type="radio" name="payment_method_option" value="bank_transfer" class="peer h-4 w-4 text-primary focus:ring-primary" onchange="togglePaymentDetail()"/>
                                <div class="flex items-center gap-3">
                                    <span class="material-symbols-outlined text-primary icon-fill">qr_code_2</span>
                                    <div>
                                        <h4 class="font-bold text-gray-900 text-sm">Chuyển khoản VietQR (Kích hoạt nhanh)</h4>
                                        <p class="text-[11px] text-gray-500">Quét mã kích hoạt tự động</p>
                                    </div>
                                </div>
                            </label>
                        </div>

                        <%-- Chi tiết chuyển khoản (VietQR Code block) --%>
                        <div id="vietqrDetail" class="hidden border-t border-gray-100 pt-6">
                            <div class="bg-gray-50 rounded-2xl p-6 border border-gray-100 grid grid-cols-1 md:grid-cols-12 gap-6 items-center">
                                <%-- Cột trái: QR Code --%>
                                <div class="md:col-span-5 flex flex-col items-center justify-center bg-white p-4 rounded-xl border border-gray-200 shadow-sm">
                                    <img id="qrImage" src="" alt="Mã QR thanh toán" class="w-44 h-44 object-contain mb-2" />
                                    <span class="text-[10px] font-bold text-gray-400 uppercase tracking-widest flex items-center gap-1">
                                        <i class="fa-solid fa-qrcode text-xs"></i> Quét để thanh toán
                                    </span>
                                </div>

                                <%-- Cột phải: Thông tin chi tiết --%>
                                <div class="md:col-span-7 space-y-3">
                                    <div class="inline-flex items-center gap-2 bg-blue-50 text-primary text-[11px] font-bold px-3 py-1 rounded-full">
                                        <span class="relative flex h-2 w-2">
                                          <span class="animate-ping absolute inline-flex h-full w-full rounded-full bg-blue-400 opacity-75"></span>
                                          <span class="relative inline-flex rounded-full h-2 w-2 bg-blue-500"></span>
                                        </span>
                                        Tự động điền số tiền & nội dung
                                    </div>
                                    
                                    <div class="grid grid-cols-3 gap-y-2 text-xs">
                                        <span class="text-gray-500">Ngân hàng:</span>
                                        <span class="col-span-2 font-bold text-gray-950">MB Bank (Ngân hàng Quân Đội)</span>

                                        <span class="text-gray-500">Chủ tài khoản:</span>
                                        <span class="col-span-2 font-bold text-gray-950">CONG TY XYZ NEWS</span>

                                        <span class="text-gray-500">Số tài khoản:</span>
                                        <span class="col-span-2 font-mono font-bold text-gray-950 flex items-center gap-2">
                                            <span id="bankAccount">190356789012</span>
                                            <button type="button" onclick="copyText('bankAccount')" class="text-primary hover:text-blue-800 text-[10px] flex items-center gap-0.5 font-sans font-normal">
                                                <i class="fa-regular fa-copy"></i> Sao chép
                                            </button>
                                        </span>

                                        <span class="text-gray-500">Số tiền:</span>
                                        <span id="bankAmount" class="col-span-2 font-bold text-primary text-base">480.000đ</span>

                                        <span class="text-gray-500">Nội dung CK:</span>
                                        <span class="col-span-2 font-mono font-bold text-gray-950 flex items-center gap-2">
                                            <span id="bankMemo">XYZPREMIUM</span>
                                            <button type="button" onclick="copyText('bankMemo')" class="text-primary hover:text-blue-800 text-[10px] flex items-center gap-0.5 font-sans font-normal">
                                                <i class="fa-regular fa-copy"></i> Sao chép
                                            </button>
                                        </span>
                                    </div>
                                    <p class="text-[11px] text-danger font-medium flex items-start gap-1 bg-red-50 p-2.5 rounded-lg leading-normal">
                                        <span class="material-symbols-outlined text-xs mt-0.5">warning</span>
                                        <span>Lưu ý: Hãy ghi đúng nội dung để hệ thống tự động duyệt nhanh nhất.</span>
                                    </p>
                                </div>
                            </div>
                        </div>
                    </div>
                </section>
                <input type="hidden" id="paymentMethodInput" name="payment_method" value="cod" />
            </div>

            <%-- ==================== CỘT PHẢI: Tóm tắt đơn hàng ==================== --%>
            <div class="lg:col-span-4 mt-10 lg:mt-0">
                <div class="bg-white border border-gray-200 rounded-xl p-6 sticky top-[140px] shadow-sm">
                    <h3 class="text-xl font-serif font-bold text-gray-900 border-b border-gray-200 pb-3 mb-4">Tóm tắt đơn hàng</h3>

                    <div class="flex justify-between items-center py-2">
                        <span class="text-gray-600">Dịch vụ:</span>
                        <span id="summaryType" class="font-bold text-gray-900">Dịch vụ Premium AI</span> <!-- // FIX -->
                    </div>
                    <div class="flex justify-between items-center py-2 border-b border-gray-200 mb-4 pb-4">
                        <span class="text-gray-600">Gói thời gian:</span>
                        <span id="summaryDuration" class="font-bold text-gray-900">6 Tháng</span>
                    </div>
                    <div class="flex justify-between items-end mb-5">
                        <span class="text-lg text-gray-900 font-bold">Tổng cộng:</span>
                        <span id="summaryTotal" class="text-2xl font-bold text-primary">480.000đ</span>
                    </div>

                    <p class="text-sm text-gray-500 italic mb-5 text-center">
                        Bằng việc đăng ký, bạn đồng ý với
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
            'lifetime': { price: '990.000đ', label: 'Trọn Đời' } // // FIX
        };
        var typeMap = { // FIX
            'digital': 'Dịch vụ Premium AI' // FIX
        }; // FIX

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

            // Tự động cập nhật QR nếu phương thức thanh toán là chuyển khoản
            var selectedMethod = document.querySelector('input[name="payment_method_option"]:checked');
            if (selectedMethod && selectedMethod.value === 'bank_transfer') {
                updateQR();
            }
        }

        /**
         * Ẩn/hiện khối thông tin chuyển khoản VietQR
         */
        function togglePaymentDetail() {
            var selectedMethod = document.querySelector('input[name="payment_method_option"]:checked').value;
            document.getElementById('paymentMethodInput').value = selectedMethod;
            
            var detailBox = document.getElementById('vietqrDetail');
            if (selectedMethod === 'bank_transfer') {
                detailBox.classList.remove('hidden');
                updateQR();
            } else {
                detailBox.classList.add('hidden');
            }
        }

        /**
         * Sinh mã QR động từ img.vietqr.io và cập nhật nội dung chuyển khoản
         */
        function updateQR() {
            var phoneInput = document.querySelector('input[name="phone"]');
            var emailInput = document.querySelector('input[name="email"]');
            var phone = phoneInput ? phoneInput.value.trim() : '';
            var email = emailInput ? emailInput.value.trim() : '';
            
            // Lấy định danh từ SĐT hoặc email
            var identifier = phone || email || 'USER';
            // Chuẩn hóa chuỗi định danh chỉ giữ chữ và số, viết hoa
            identifier = identifier.replace(/[^a-zA-Z0-9]/g, '').toUpperCase();
            
            var durationRadio = document.querySelector('input[name="package_duration"]:checked');
            var amount = 990000; // // FIX
            if (durationRadio && durationRadio.value === 'lifetime') { // // FIX
                amount = 990000; // // FIX
            } // // FIX
            
            // Nội dung chuyển khoản chuẩn hóa: XYZPREMIUM + Định danh (SĐT hoặc Email)
            var memo = 'XYZPREMIUM' + identifier;
            if (memo.length > 25) {
                memo = memo.substring(0, 25); // Giới hạn độ dài tối đa của VietQR addInfo
            }
            
            document.getElementById('bankMemo').textContent = memo;
            document.getElementById('bankAmount').textContent = amount.toLocaleString('vi-VN') + 'đ';
            
            // Tạo link QR động từ VietQR API
            var qrUrl = 'https://img.vietqr.io/image/MB-190356789012-compact.png?amount=' + amount + '&addInfo=' + encodeURIComponent(memo) + '&accountName=CONG%20TY%20XYZ%20NEWS';
            document.getElementById('qrImage').src = qrUrl;
        }

        /**
         * Sao chép văn bản vào bộ nhớ tạm
         */
        function copyText(elementId) {
            var text = document.getElementById(elementId).textContent;
            navigator.clipboard.writeText(text).then(function() {
                // Hiển thị thông báo nhẹ nhàng thay vì alert thô kệch
                var btn = document.querySelector('#' + elementId).nextElementSibling;
                var originalHTML = btn.innerHTML;
                btn.innerHTML = '<i class="fa-solid fa-circle-check text-green-500"></i> Đã chép';
                setTimeout(function() { btn.innerHTML = originalHTML; }, 2000);
            }).catch(function(err) {
                console.error('Không thể sao chép: ', err);
            });
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
    </script>
</body>
</html>