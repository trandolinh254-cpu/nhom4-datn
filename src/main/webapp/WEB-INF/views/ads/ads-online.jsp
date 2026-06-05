<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Báo giá Quảng cáo Online - XYZ News</title>
    <link href="https://fonts.googleapis.com/css2?family=Merriweather:wght@400;700;900&family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css" rel="stylesheet">
    <script src="https://cdn.tailwindcss.com"></script>
    <script>
        tailwind.config = {
            theme: {
                extend: {
                    colors: { primary: "#006389", danger: "#ff4d4f", brandBlue: "#0098D1" },
                    fontFamily: { serif: ['Merriweather', 'serif'], sans: ['Inter', 'sans-serif'] }
                }
            }
        }
    </script>
    <style>
        .form-input { @apply w-full bg-white border border-gray-300 rounded-md p-3 text-sm focus:ring-2 focus:ring-primary focus:border-primary outline-none transition-shadow; }
        .table-header-red { background-color: #ff5656; } /* Màu đỏ cam chuẩn bảng giá */
        .ad-block.active { @apply bg-primary text-white border-primary shadow-xl scale-[1.03]; z-index: 10; transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1); }
        .custom-scrollbar::-webkit-scrollbar { height: 8px; }
        .custom-scrollbar::-webkit-scrollbar-thumb { background-color: #cbd5e1; border-radius: 4px; }
        html { scroll-behavior: smooth; }
        @keyframes fadeInUp { from { opacity: 0; transform: translateY(20px); } to { opacity: 1; transform: translateY(0); } }
    </style>
</head>
<body class="bg-gray-50 text-gray-800 font-sans min-h-screen flex flex-col">

    <jsp:include page="../public/components/header.jsp" />

    <main class="flex-grow w-full max-w-[1200px] mx-auto px-4 py-10">
        
        <%-- FIX: KHU VỰC HIỂN THỊ THÔNG BÁO THÀNH CÔNG --%>
        <c:if test="${not empty sessionScope.successMessage}">
            <div class="bg-green-50 border-l-4 border-green-500 text-green-800 p-4 rounded shadow-sm mb-8 flex items-center justify-between animate-[fadeInUp_0.5s_ease-out]">
                <div class="flex items-center gap-3">
                    <i class="fas fa-check-circle text-2xl text-green-500"></i>
                    <div>
                        <h4 class="font-bold text-base">Thành công!</h4>
                        <p class="text-sm m-0">${sessionScope.successMessage}</p>
                    </div>
                </div>
                <button type="button" onclick="this.parentElement.style.display='none'" class="text-green-600 hover:text-green-800"><i class="fas fa-times"></i></button>
            </div>
            <c:remove var="successMessage" scope="session" />
        </c:if>

        <header class="mb-10 flex justify-between items-end border-b border-gray-200 pb-4">
            <div>
                <h1 class="text-3xl font-bold text-gray-900 mb-2">Quảng cáo hiển thị</h1>
                <h2 class="text-lg text-gray-600">Bảng giá hiển thị trên PC</h2>
            </div>
            <a href="#" class="text-primary font-bold hover:underline flex items-center gap-1">
                <i class="fas fa-download"></i> Download
            </a>
        </header>

        <%-- BƯỚC 1: BẢNG GIÁ HIỂN THỊ CHUẨN --%>
        <section class="bg-white rounded-t-lg shadow-sm border border-gray-200 overflow-hidden mb-12">
            <div class="text-right px-4 py-2 text-xs text-gray-600 font-bold bg-white">
                ĐVT: VNĐ
            </div>
            <div class="overflow-x-auto custom-scrollbar">
                <table class="w-full text-[13px] border-collapse min-w-[1000px]">
                    <thead class="table-header-red text-white text-center font-bold">
                        <tr>
                            <th rowspan="2" class="px-3 py-3 border border-white/20 align-middle w-[15%]">Vị trí</th>
                            <th colspan="2" class="px-3 py-2 border border-white/20">Mô tả</th>
                            <th colspan="3" class="px-3 py-2 border border-white/20">Đơn giá (VNĐ/Tuần)</th>
                            <th colspan="2" class="px-3 py-2 border border-white/20">CPM - CPC</th>
                            <th rowspan="2" class="px-3 py-3 border border-white/20 align-middle w-[12%]">Hành động</th>
                        </tr>
                        <tr>
                            <th class="px-2 py-2 border border-white/20 font-medium">Kích thước<br>(pixels)</th>
                            <th class="px-2 py-2 border border-white/20 font-medium">Số chia sẻ</th>
                            <th class="px-2 py-2 border border-white/20 font-medium">Xuyên trang</th>
                            <th class="px-2 py-2 border border-white/20 font-medium">Trang chủ</th>
                            <th class="px-2 py-2 border border-white/20 font-medium">Chuyên mục</th>
                            <th class="px-2 py-2 border border-white/20 font-medium">CPM</th>
                            <th class="px-2 py-2 border border-white/20 font-medium">CPC</th>
                        </tr>
                    </thead>
                    <tbody class="text-center divide-y divide-gray-200">
                        <c:forEach var="pos" items="${positions}">
                            <tr class="hover:bg-red-50 transition-colors ${pos.id == 1 ? 'bg-yellow-50/50' : ''}">
                                <td class="px-3 py-4 text-left text-gray-900 border-r border-gray-200 font-semibold">
                                    <c:choose>
                                        <c:when test="${pos.name.toLowerCase().contains('masthead')}"><i class="fas fa-star text-yellow-500 mr-1"></i></c:when>
                                        <c:when test="${pos.name.toLowerCase().contains('top')}"><i class="fas fa-arrow-up text-primary mr-1"></i></c:when>
                                        <c:when test="${pos.name.toLowerCase().contains('left') || pos.name.toLowerCase().contains('trái')}"><i class="fas fa-arrow-left text-primary mr-1"></i></c:when>
                                        <c:when test="${pos.name.toLowerCase().contains('right') || pos.name.toLowerCase().contains('phải')}"><i class="fas fa-arrow-right text-primary mr-1"></i></c:when>
                                        <c:otherwise><i class="fas fa-bullhorn text-primary mr-1"></i></c:otherwise>
                                    </c:choose>
                                    ${pos.name}
                                    <c:if test="${pos.name.toLowerCase().contains('masthead')}">
                                        <span class="block text-[10px] text-yellow-600 font-normal mt-0.5">★ Vị trí VIP nhất</span>
                                    </c:if>
                                </td>
                                <td class="px-2 py-4 border-r border-gray-200">${pos.sizeDesc}</td>
                                <td class="px-2 py-4 border-r border-gray-200">3</td>
                                <td class="px-2 py-4 border-r border-gray-200">
                                    <fmt:formatNumber value="${pos.basePrice * 1.5}" pattern="#,###" />
                                </td>
                                <td class="px-2 py-4 border-r border-gray-200 font-bold text-primary">
                                    <fmt:formatNumber value="${pos.basePrice}" pattern="#,###" />
                                </td>
                                <td class="px-2 py-4 border-r border-gray-200">
                                    <fmt:formatNumber value="${pos.basePrice * 0.5}" pattern="#,###" />
                                </td>
                                <td class="px-2 py-4 border-r border-gray-200">16.000</td>
                                <td class="px-2 py-4 border-r border-gray-200">-</td>
                                <td class="px-2 py-4">
                                    <div class="flex flex-col gap-1.5 items-center">
                                        <fmt:formatNumber var="formattedPrice" value="${pos.basePrice}" pattern="#,###" />
                                        <button type="button" onclick="showDemoByPosId('${pos.id}', '${pos.name}')" class="w-[85px] py-1 border border-danger text-danger rounded-full hover:bg-danger hover:text-white transition-colors text-[11px] font-medium">Xem demo</button>
                                        <button type="button" data-name="${pos.name}" data-size="${pos.sizeDesc}" data-price="Trang chủ: ${formattedPrice}đ" data-id="${pos.id}" data-baseprice="${pos.basePrice}" onclick="selectAdFromButton(this)" class="w-[85px] py-1 bg-primary text-white rounded-full hover:bg-[#004c6b] transition-colors text-[11px] font-bold">Chọn mua</button>
                                    </div>
                                </td>
                            </tr>
                        </c:forEach>
                    </tbody>
                </table>
            </div>
        </section>

        <%-- BƯỚC 2: FORM ĐĂNG KÝ (Mở ra khi Click Chọn mua) --%>
        <section id="registrationForm" class="bg-white rounded-xl shadow-md border border-gray-200 p-6 md:p-8 opacity-40 pointer-events-none transition-all duration-500">
            <h2 class="text-2xl font-serif font-bold text-gray-900 mb-6 flex items-center gap-2 border-b border-gray-100 pb-3">
                <i class="fas fa-file-contract text-primary"></i> Đơn Đăng Ký Đặt Chỗ
            </h2>
            
            <form action="${pageContext.request.contextPath}/ads/register" method="POST" enctype="multipart/form-data">
                <input type="hidden" name="platform" value="online">
                <input type="hidden" id="position_id" name="position_id" value="1">
                
                <%-- Trạng thái Vị trí đã chọn --%>
                <div class="bg-red-50 border border-red-200 rounded-lg p-5 flex flex-col md:flex-row justify-between mb-8 gap-4">
                    <div class="flex-grow">
                        <span class="text-xs text-danger uppercase font-bold block mb-1">Vị trí đã chọn</span>
                        <input type="text" id="selected_position" name="selected_position" class="bg-transparent border-none text-2xl font-black text-gray-900 p-0 outline-none w-full pointer-events-none" value="Chưa chọn vị trí..." readonly>
                    </div>
                    <div class="md:text-right md:border-l border-red-200 md:pl-6 pt-3 md:pt-0 border-t md:border-t-0">
                        <span class="text-xs text-danger uppercase font-bold block mb-1">Kích thước & Giá tham khảo</span>
                        <div class="flex flex-col md:items-end">
                            <input type="text" id="selected_size" class="bg-transparent border-none font-bold text-gray-700 p-0 outline-none pointer-events-none text-sm" value="--" readonly>
                            <input type="text" id="selected_price" class="bg-transparent border-none font-bold text-primary p-0 outline-none pointer-events-none text-sm mt-1" value="--" readonly>
                        </div>
                    </div>
                </div>

                <div class="grid grid-cols-1 md:grid-cols-2 gap-6 mb-8">
                    <div>
                        <label class="block text-xs font-bold uppercase text-gray-600 mb-1.5">Tên chiến dịch *</label>
                        <input type="text" name="campaign_name" class="form-input" required placeholder="Khuyến mãi Hè 2026...">
                    </div>
                    <div>
                        <label class="block text-xs font-bold uppercase text-gray-600 mb-1.5">Link Landing Page *</label>
                        <input type="url" name="landing_url" class="form-input" required placeholder="https://...">
                    </div>
                    <div>
                        <label class="block text-xs font-bold uppercase text-gray-600 mb-1.5">Ngày bắt đầu chạy *</label>
                        <input type="date" name="start_date" class="form-input" required>
                    </div>
                    <div>
                        <label class="block text-xs font-bold uppercase text-gray-600 mb-1.5">Thời gian chạy *</label>
                        <select name="duration" class="form-input" required onchange="updateAdsQR()">
                            <option value="1w">1 Tuần</option>
                            <option value="2w">2 Tuần</option>
                            <option value="1m">1 Tháng (Giảm 10%)</option>
                        </select>
                    </div>
                    <div class="md:col-span-2">
                        <label class="block text-xs font-bold uppercase text-gray-600 mb-1.5">Tải lên Banner (Thiết kế đúng kích thước) *</label>
                        <input type="file" name="client_ad_image" accept="image/*" class="form-input" required>
                    </div>
                </div>

                <h3 class="text-lg font-bold text-gray-900 mb-4 border-t border-gray-100 pt-6">Thông tin Doanh Nghiệp (Xuất hóa đơn)</h3>
                <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6 mb-8">
                    <div>
                        <label class="block text-xs font-bold uppercase text-gray-600 mb-1.5">Tên doanh nghiệp / Công ty</label>
                        <input type="text" name="company_name" class="form-input" placeholder="Tên công ty (Tùy chọn)">
                    </div>
                    <div class="lg:col-span-2">
                        <label class="block text-xs font-bold uppercase text-gray-600 mb-1.5">Địa chỉ xuất hóa đơn</label>
                        <input type="text" name="address" class="form-input" placeholder="Địa chỉ công ty (Tùy chọn)">
                    </div>
                    <div>
                        <label class="block text-xs font-bold uppercase text-gray-600 mb-1.5">Người liên hệ *</label>
                        <input type="text" name="contact_name" value="${sessionScope.currentUser.fullname}" class="form-input" required oninput="updateAdsQR()">
                    </div>
                    <div>
                        <label class="block text-xs font-bold uppercase text-gray-600 mb-1.5">Điện thoại *</label>
                        <input type="tel" name="phone" class="form-input" required oninput="updateAdsQR()">
                    </div>
                    <div>
                        <label class="block text-xs font-bold uppercase text-gray-600 mb-1.5">Email *</label>
                        <input type="email" name="email" value="${sessionScope.currentUser.email}" class="form-input" required oninput="updateAdsQR()">
                    </div>
                </div>

                <h3 class="text-lg font-bold text-gray-900 mb-4 border-t border-gray-100 pt-6">Phương thức thanh toán</h3>
                <div class="grid grid-cols-1 md:grid-cols-2 gap-6 mb-8">
                    <%-- Thanh toán sau --%>
                    <label class="relative flex items-center gap-3 p-4 border border-gray-200 bg-white rounded-xl cursor-pointer hover:border-primary transition-all">
                        <input type="radio" name="payment_method_option" value="cod" class="peer h-4 w-4 text-primary focus:ring-primary" checked onchange="toggleAdsPaymentDetail()"/>
                        <div class="flex items-center gap-3">
                            <span class="fas fa-file-invoice-dollar text-gray-500 text-lg"></span>
                            <div>
                                <h4 class="font-bold text-gray-900 text-sm">Thanh toán sau (Duyệt offline)</h4>
                                <p class="text-[11px] text-gray-500">Chuyển khoản sau khi liên hệ ký hợp đồng</p>
                            </div>
                        </div>
                    </label>

                    <%-- Chuyển khoản VietQR --%>
                    <label class="relative flex items-center gap-3 p-4 border border-gray-200 bg-white rounded-xl cursor-pointer hover:border-primary transition-all">
                        <input type="radio" name="payment_method_option" value="bank_transfer" class="peer h-4 w-4 text-primary focus:ring-primary" onchange="toggleAdsPaymentDetail()"/>
                        <div class="flex items-center gap-3">
                            <span class="fas fa-qrcode text-primary text-lg"></span>
                            <div>
                                <h4 class="font-bold text-gray-900 text-sm">Chuyển khoản VietQR (Xác nhận nhanh)</h4>
                                <p class="text-[11px] text-gray-500">Quét mã QR để tự động kích hoạt chiến dịch</p>
                            </div>
                        </div>
                    </label>
                </div>

                <%-- Chi tiết chuyển khoản VietQR cho Ads --%>
                <div id="vietqrAdsDetail" class="hidden border border-gray-200 bg-white rounded-xl p-6 mb-8">
                    <div class="grid grid-cols-1 md:grid-cols-12 gap-6 items-center">
                        <%-- QR Code --%>
                        <div class="md:col-span-5 flex flex-col items-center justify-center bg-gray-50 p-4 rounded-xl border border-gray-200 shadow-sm">
                            <img id="qrAdsImage" src="" alt="Mã QR thanh toán quảng cáo" class="w-44 h-44 object-contain mb-2" />
                            <span class="text-[10px] font-bold text-gray-400 uppercase tracking-widest flex items-center gap-1">
                                <i class="fa-solid fa-qrcode text-xs"></i> Quét để thanh toán
                            </span>
                        </div>

                        <%-- Thông tin chuyển khoản --%>
                        <div class="md:col-span-7 space-y-3">
                            <div class="inline-flex items-center gap-2 bg-blue-50 text-primary text-[11px] font-bold px-3 py-1 rounded-full">
                                <span class="relative flex h-2 w-2">
                                  <span class="animate-ping absolute inline-flex h-full w-full rounded-full bg-blue-400 opacity-75"></span>
                                  <span class="relative inline-flex rounded-full h-2 w-2 bg-blue-500"></span>
                                </span>
                                Tự động điền số tiền & nội dung quảng cáo
                            </div>
                            
                            <div class="grid grid-cols-3 gap-y-2 text-xs">
                                <span class="text-gray-500">Ngân hàng:</span>
                                <span class="col-span-2 font-bold text-gray-950">MB Bank (Ngân hàng Quân Đội)</span>

                                <span class="text-gray-500">Chủ tài khoản:</span>
                                <span class="col-span-2 font-bold text-gray-950">CONG TY XYZ NEWS</span>

                                <span class="text-gray-500">Số tài khoản:</span>
                                <span class="col-span-2 font-mono font-bold text-gray-950 flex items-center gap-2">
                                    <span id="bankAccountAds">190356789012</span>
                                    <button type="button" onclick="copyAdsText('bankAccountAds')" class="text-primary hover:text-blue-800 text-[10px] flex items-center gap-0.5 font-sans font-normal">
                                        <i class="fa-regular fa-copy"></i> Sao chép
                                    </button>
                                </span>

                                <span class="text-gray-500">Tổng số tiền:</span>
                                <span id="bankAmountAds" class="col-span-2 font-bold text-primary text-base">0đ</span>

                                <span class="text-gray-500">Nội dung CK:</span>
                                <span class="col-span-2 font-mono font-bold text-gray-950 flex items-center gap-2">
                                    <span id="bankMemoAds">XYZADS</span>
                                    <button type="button" onclick="copyAdsText('bankMemoAds')" class="text-primary hover:text-blue-800 text-[10px] flex items-center gap-0.5 font-sans font-normal">
                                        <i class="fa-regular fa-copy"></i> Sao chép
                                    </button>
                                </span>
                            </div>
                            <p class="text-[11px] text-danger font-medium flex items-start gap-1 bg-red-50 p-2.5 rounded-lg leading-normal">
                                <span class="fas fa-exclamation-triangle text-xs mt-0.5"></span>
                                <span>Lưu ý: Hãy ghi đúng nội dung để chúng tôi đối soát và duyệt vị trí quảng cáo ngay lập tức.</span>
                            </p>
                        </div>
                    </div>
                </div>
                <input type="hidden" id="adsPaymentMethodInput" name="payment_method" value="cod" />

                <div class="bg-gray-100 p-5 rounded-lg flex flex-col sm:flex-row items-center justify-between gap-4 border border-gray-200">
                    <label class="flex items-center gap-2 cursor-pointer">
                        <input type="checkbox" required class="w-4 h-4 text-primary bg-white border-gray-300 rounded focus:ring-primary focus:ring-2">
                        <span class="text-sm text-gray-600">Tôi xác nhận nội dung quảng cáo hợp lệ và tuân thủ <a href="#" class="text-primary hover:underline font-medium">Quy định báo chí</a>.</span>
                    </label>
                    <button type="submit" class="w-full sm:w-auto bg-danger hover:bg-[#e63946] text-white font-bold py-2.5 px-8 rounded-md transition-colors shadow flex items-center justify-center gap-2 tracking-wide">
                        GỬI YÊU CẦU <i class="fas fa-paper-plane"></i>
                    </button>
                </div>
            </form>
        </section>
    </main>

    <%-- MODAL DEMO WIREFRAME - Chỉ 2 vị trí: Top Banner và Sidebar --%>
    <div id="demoModal" class="fixed inset-0 z-[100] flex items-center justify-center hidden bg-black/70 backdrop-blur-sm transition-opacity p-4">
        <div class="bg-gray-100 rounded-xl w-full max-w-5xl shadow-2xl overflow-hidden flex flex-col max-h-[95vh]">
            <div class="flex justify-between items-center px-6 py-4 border-b border-gray-200 bg-white">
                <div>
                    <h3 class="font-serif font-bold text-xl text-gray-900" id="demoTitle">Mô phỏng vị trí hiển thị</h3>
                    <p class="text-xs text-gray-500 mt-1" id="demoSubtitle">Khối màu xanh là vị trí quảng cáo bạn đang xem.</p>
                </div>
                <button onclick="closeDemo()" class="text-gray-400 hover:text-danger text-2xl transition"><i class="fas fa-times"></i></button>
            </div>
            
            <div class="p-6 overflow-y-auto bg-[#eef2f5]">
                <%-- Layout Web mô phỏng với 2 vị trí thực tế --%>
                <div class="relative" style="max-width: 900px; margin: 0 auto;">
                    
                    <%-- Sidebar trái --%>
                    <div id="demo_sidebar_left" class="ad-block hidden absolute left-[-80px] top-[60px] w-[70px] h-[260px] bg-gray-100 border border-dashed border-gray-300 flex-col items-center justify-center text-gray-400 transition-all duration-300 text-center" style="writing-mode: vertical-rl;">
                        <span class="font-bold text-[10px] tracking-wider">SIDEBAR TRÁI</span>
                    </div>
                    
                    <%-- Sidebar phải --%>
                    <div id="demo_sidebar_right" class="ad-block hidden absolute right-[-80px] top-[60px] w-[70px] h-[260px] bg-gray-100 border border-dashed border-gray-300 flex-col items-center justify-center text-gray-400 transition-all duration-300 text-center" style="writing-mode: vertical-rl;">
                        <span class="font-bold text-[10px] tracking-wider">SIDEBAR PHẢI</span>
                    </div>

                    <%-- Khung web chính --%>
                    <div class="bg-white border border-gray-300 shadow-sm p-4 relative">
                        <%-- Super Masthead --%>
                        <div id="demo_super_masthead" class="ad-block w-full h-[80px] bg-gray-100 border border-dashed border-gray-300 flex flex-col items-center justify-center text-gray-500 mb-2 transition-all duration-300">
                            <span class="font-black text-lg tracking-widest">SUPER MASTHEAD</span>
                            <span class="text-xs font-medium">1920 × 250</span>
                        </div>

                        <%-- Header giả lập (Logo chính giữa + Menu) --%>
                        <div class="flex items-center justify-center py-3 border-b border-gray-200 mb-1">
                            <div class="text-3xl font-serif font-black text-gray-300 tracking-tighter">XYZ NEWS</div>
                        </div>
                        <div class="h-8 border-b-2 border-gray-200 flex items-center justify-center gap-4 px-2 mb-4">
                            <div class="w-10 h-2 bg-gray-200 rounded"></div><div class="w-10 h-2 bg-gray-200 rounded"></div><div class="w-10 h-2 bg-gray-200 rounded"></div>
                        </div>

                        <%-- Top Banner (Nằm dưới Header, trước nội dung tin tức) --%>
                        <div id="demo_top_banner" class="ad-block w-full h-[60px] bg-gray-100 border border-dashed border-gray-300 flex flex-col items-center justify-center text-gray-500 mb-6 transition-all duration-300">
                            <span class="font-black text-lg tracking-widest">TOP BANNER</span>
                            <span class="text-xs font-medium">1120 × 90</span>
                        </div>

                        <%-- Nội dung bài viết giả lập --%>
                        <div class="flex gap-6">
                            <div class="flex-grow">
                                <div class="grid grid-cols-2 gap-4">
                                    <div>
                                        <div class="w-full h-32 bg-gray-100 rounded mb-2"></div>
                                        <div class="w-full h-3 bg-gray-200 rounded mb-1.5"></div>
                                        <div class="w-4/5 h-3 bg-gray-200 rounded"></div>
                                    </div>
                                    <div>
                                        <div class="w-full h-32 bg-gray-100 rounded mb-2"></div>
                                        <div class="w-full h-3 bg-gray-200 rounded mb-1.5"></div>
                                        <div class="w-3/4 h-3 bg-gray-200 rounded"></div>
                                    </div>
                                </div>
                                <div class="mt-4 grid grid-cols-3 gap-3">
                                    <div><div class="w-full h-20 bg-gray-100 rounded mb-2"></div><div class="w-full h-2 bg-gray-200 rounded"></div></div>
                                    <div><div class="w-full h-20 bg-gray-100 rounded mb-2"></div><div class="w-full h-2 bg-gray-200 rounded"></div></div>
                                    <div><div class="w-full h-20 bg-gray-100 rounded mb-2"></div><div class="w-full h-2 bg-gray-200 rounded"></div></div>
                                </div>
                            </div>
                            <div class="w-[200px] shrink-0">
                                <div class="w-full h-8 bg-gray-100 flex items-center justify-center font-bold text-gray-300 text-[10px] border border-gray-200 mb-3">TIN NỔI BẬT</div>
                                <div class="space-y-2">
                                    <div class="w-full h-3 bg-gray-200 rounded"></div>
                                    <div class="w-full h-3 bg-gray-200 rounded"></div>
                                    <div class="w-full h-3 bg-gray-200 rounded"></div>
                                    <div class="w-full h-3 bg-gray-200 rounded"></div>
                                    <div class="w-4/5 h-3 bg-gray-200 rounded"></div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <jsp:include page="../public/components/footer.jsp" />

    <script>
        var selectedBasePrice = 0;

        function selectAdFromButton(btn) {
            var name = btn.getAttribute('data-name');
            var size = btn.getAttribute('data-size');
            var priceInfo = btn.getAttribute('data-price');
            var posId = btn.getAttribute('data-id');
            var basePrice = parseFloat(btn.getAttribute('data-baseprice')) || 0;
            selectAd(name, size, priceInfo, posId, basePrice);
        }

        // Xử lý mapping Name sang demo block thay vì ID để luôn chuẩn
        function showDemoByPosId(posId, name) {
            let demoId = '';
            let n = name.toLowerCase();
            if (n.includes('masthead')) demoId = 'super_masthead';
            else if (n.includes('top')) demoId = 'top_banner';
            else if (n.includes('left') || n.includes('trái')) demoId = 'sidebar_left';
            else if (n.includes('right') || n.includes('phải')) demoId = 'sidebar_right';
            
            if (!demoId) {
                alert('Vị trí [' + name + '] hiện chưa có wireframe mô phỏng trên hệ thống.');
                return;
            }
            showDemo(demoId, name);
        }

        // Xử lý nút Xem Demo
        function showDemo(id, name) {
            document.getElementById('demoTitle').innerText = "Vị trí mô phỏng: " + name;
            
            // Reset tất cả ad-block về trạng thái mặc định
            const blocks = document.querySelectorAll('.ad-block');
            blocks.forEach(block => {
                block.classList.remove('active');
                // Ẩn sidebar nếu đang hiện
                if (block.id === 'demo_sidebar_left' || block.id === 'demo_sidebar_right') {
                    block.classList.add('hidden');
                    block.classList.remove('flex');
                }
            });
            
            if (id === 'sidebar_left') {
                // Chỉ hiện sidebar trái
                const el = document.getElementById('demo_sidebar_left');
                el.classList.remove('hidden');
                el.classList.add('flex', 'active');
            } else if (id === 'sidebar_right') {
                // Chỉ hiện sidebar phải
                const el = document.getElementById('demo_sidebar_right');
                el.classList.remove('hidden');
                el.classList.add('flex', 'active');
            } else {
                // Highlight block khác (Top Banner, Super Masthead)
                const targetBlock = document.getElementById('demo_' + id);
                if (targetBlock) {
                    targetBlock.classList.add('active');
                    setTimeout(() => targetBlock.scrollIntoView({ behavior: 'smooth', block: 'center' }), 100);
                }
            }
            
            // Bật Modal
            document.getElementById('demoModal').classList.remove('hidden');
        }

        function closeDemo() {
            document.getElementById('demoModal').classList.add('hidden');
        }

        // Xử lý nút Chọn mua
        function selectAd(name, size, priceInfo, posId = 1, basePrice = 0) {
            // Mở khóa Form đăng ký
            const form = document.getElementById('registrationForm');
            form.classList.remove('opacity-40', 'pointer-events-none');
            form.classList.add('shadow-xl', 'border-primary');
            
            // Chèn tham số vào Form
            document.getElementById('selected_position').value = name;
            document.getElementById('selected_size').value = size;
            document.getElementById('selected_price').value = priceInfo;
            document.getElementById('position_id').value = posId;
            
            selectedBasePrice = basePrice;
            updateAdsQR();
            
            // Cuộn mượt xuống Form
            form.scrollIntoView({ behavior: 'smooth', block: 'start' });
        }

        /**
         * Ẩn/hiện chi tiết chuyển khoản VietQR cho Ads
         */
        function toggleAdsPaymentDetail() {
            var selectedMethod = document.querySelector('input[name="payment_method_option"]:checked').value;
            document.getElementById('adsPaymentMethodInput').value = selectedMethod;
            
            var detailBox = document.getElementById('vietqrAdsDetail');
            if (selectedMethod === 'bank_transfer') {
                detailBox.classList.remove('hidden');
                updateAdsQR();
            } else {
                detailBox.classList.add('hidden');
            }
        }

        /**
         * Tính toán chi phí quảng cáo động và sinh mã VietQR
         */
        function updateAdsQR() {
            if (!selectedBasePrice) return;
            
            var duration = document.querySelector('select[name="duration"]').value;
            var amount = 0;
            if (duration === '1w') {
                amount = selectedBasePrice * 1;
            } else if (duration === '2w') {
                amount = selectedBasePrice * 2;
            } else if (duration === '1m') {
                amount = Math.round(selectedBasePrice * 4 * 0.9); // Giảm 10%
            }
            
            var phone = document.querySelector('input[name="phone"]').value.trim();
            var email = document.querySelector('input[name="email"]').value.trim();
            var contactName = document.querySelector('input[name="contact_name"]').value.trim();
            var identifier = phone || email || contactName || 'USER';
            // Chỉ giữ lại chữ và số, chuyển thành chữ hoa
            identifier = identifier.replace(/[^a-zA-Z0-9]/g, '').toUpperCase();
            
            var memo = 'XYZADS' + identifier;
            if (memo.length > 25) {
                memo = memo.substring(0, 25);
            }
            
            document.getElementById('bankMemoAds').textContent = memo;
            document.getElementById('bankAmountAds').textContent = amount.toLocaleString('vi-VN') + 'đ';
            
            // Sinh QR Code động
            var qrUrl = 'https://img.vietqr.io/image/MB-190356789012-compact.png?amount=' + amount + '&addInfo=' + encodeURIComponent(memo) + '&accountName=CONG%20TY%20XYZ%20NEWS';
            document.getElementById('qrAdsImage').src = qrUrl;
        }

        /**
         * Sao chép thông tin tài khoản quảng cáo
         */
        function copyAdsText(elementId) {
            var text = document.getElementById(elementId).textContent;
            navigator.clipboard.writeText(text).then(function() {
                var btn = document.querySelector('#' + elementId).nextElementSibling;
                var originalHTML = btn.innerHTML;
                btn.innerHTML = '<i class="fa-solid fa-circle-check text-green-500"></i> Đã chép';
                setTimeout(function() { btn.innerHTML = originalHTML; }, 2000);
            }).catch(function(err) {
                console.error('Không thể sao chép: ', err);
            });
        }
    </script>
</body>
</html>