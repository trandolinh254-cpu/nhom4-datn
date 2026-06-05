<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<%-- Footer --%>
<footer class="bg-gray-100 border-t border-gray-200 mt-12 py-10 font-sans">
    <div class="max-w-6xl mx-auto px-4">
        <div class="grid grid-cols-1 md:grid-cols-4 gap-8">
            <div class="col-span-1 md:col-span-2">
                <a href="${pageContext.request.contextPath}/" class="text-[32px] font-serif font-bold text-primary uppercase tracking-wider no-underline inline-block mb-4" style="color: #006389;">
                    XYZ NEWS
                </a>
                <p class="text-sm text-gray-600 mb-2">Giấy phép hoạt động báo điện tử tiếng Việt, tiếng Anh Số 01/GP-BTTTT do Bộ Thông tin và Truyền thông cấp ngày 01/01/2026.</p>
                <p class="text-sm text-gray-600 mb-2"><strong>Tổng biên tập:</strong> FPT Polytechnic</p>
                <p class="text-sm text-gray-600"><strong>Địa chỉ:</strong> Tòa nhà FPT Polytechnic, TP.HCM</p>
            </div>
            
            <div>
                <h4 class="font-bold text-gray-800 mb-4 border-b pb-2">CHUYÊN MỤC</h4>
                <ul class="text-sm text-gray-600 space-y-2">
                    <li><a href="${pageContext.request.contextPath}/news?action=category&id=TECH" class="hover:text-primary transition no-underline">Công nghệ</a></li>
                    <li><a href="${pageContext.request.contextPath}/news?action=category&id=BUSINESS" class="hover:text-primary transition no-underline">Kinh doanh</a></li>
                    <li><a href="${pageContext.request.contextPath}/news?action=category&id=HEALTH" class="hover:text-primary transition no-underline">Sức khỏe</a></li>
                    <li><a href="${pageContext.request.contextPath}/news?action=category&id=SPORT" class="hover:text-primary transition no-underline">Thể thao</a></li>
                </ul>
            </div>
            
            <div>
                <h4 class="font-bold text-gray-800 mb-4 border-b pb-2">LIÊN HỆ</h4>
                <div class="text-2xl font-bold text-primary mb-2">1900 1234</div>
                <p class="text-sm text-gray-600 mb-2"><strong>Email:</strong> toasoan@xyznews.vn</p>
                <p class="text-sm text-gray-600"><strong>Quảng cáo:</strong> quangcao@xyznews.vn</p>
                
                <div class="mt-4">
                    <h5 class="text-sm font-bold text-gray-800 mb-2">Theo dõi chúng tôi</h5>
                    <div class="flex gap-3">
                        <a href="#" class="w-8 h-8 rounded-full bg-blue-600 text-white flex items-center justify-center hover:bg-blue-700 transition no-underline"><i class="fab fa-facebook-f"></i></a>
                        <a href="#" class="w-8 h-8 rounded-full bg-red-600 text-white flex items-center justify-center hover:bg-red-700 transition no-underline"><i class="fab fa-youtube"></i></a>
                        <a href="#" class="w-8 h-8 rounded-full bg-black text-white flex items-center justify-center hover:bg-gray-800 transition no-underline"><i class="fab fa-tiktok"></i></a>
                    </div>
                </div>
            </div>
        </div>
        
        <div class="border-t border-gray-300 mt-8 pt-6 flex flex-col md:flex-row justify-between items-center text-[12px] text-gray-500">
            <p>&copy; 2026 XYZ News. Toàn bộ bản quyền thuộc FPT Polytechnic.</p>
            <div class="flex gap-4 mt-4 md:mt-0">
                <a href="#" class="hover:text-gray-800 transition no-underline">Điều khoản sử dụng</a>
                <a href="#" class="hover:text-gray-800 transition no-underline">Chính sách bảo mật</a>
                <a href="${pageContext.request.contextPath}/admin/login" class="hover:text-gray-800 transition no-underline opacity-50 hover:opacity-100" title="Khu vực dành cho nhân viên">Cổng nội bộ</a>
            </div>
        </div>
    </div>
</footer>
