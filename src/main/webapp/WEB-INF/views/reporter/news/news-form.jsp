<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
            <!DOCTYPE html>
            <html lang="vi">

            <head>
                <meta charset="UTF-8">
                <meta name="viewport" content="width=device-width, initial-scale=1.0">
                <title>${news != null ? 'Sửa tin tức' : 'Thêm tin tức'} - XYZ Reporter</title>

                <link rel="preconnect" href="https://fonts.googleapis.com">
                <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
                <link
                    href="https://fonts.googleapis.com/css2?family=Be+Vietnam+Pro:wght@300;400;500;600;700;800&display=swap"
                    rel="stylesheet">
                <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
                <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
                <script src="https://cdn.ckeditor.com/4.16.2/standard/ckeditor.js"></script>


                <style>
                    /* // : SỬ DỤNG LẠI CHÍNH XÁC BỘ CSS CŨ BẠN ĐÃ CUNG CẤP */
                    :root {
                        --primary: #006389;
                        --text-color: #333333;
                        --text-muted: #6c757d;
                    }

                    * {
                        font-family: 'Inter', 'Be Vietnam Pro', sans-serif;
                        transition: all 0.3s ease;
                    }

                    body {
                        background: #f8f9fa;
                        color: var(--text-color);
                        overflow-x: hidden;
                        min-height: 100vh;
                    }

                    .sidebar {
                        height: 100vh;
                        background: #ffffff;
                        border-right: 1px solid #eaeaea;
                        box-shadow: 2px 0 10px rgba(0,0,0,0.05);
                        z-index: 1000;
                        color: var(--text-color);
                    }

                    .sidebar h5 {
                        font-weight: 700;
                        letter-spacing: 0.5px;
                        color: var(--text-color);
                        padding-bottom: 20px;
                        border-bottom: 1px solid #eaeaea;
                        margin-bottom: 20px;
                        text-align: center;
                    }

                    .sidebar .nav-link {
                        color: var(--text-color);
                        padding: 14px 20px;
                        margin-bottom: 8px;
                        border-radius: 8px;
                        font-size: 0.95rem;
                        font-weight: 500;
                        display: flex;
                        align-items: center;
                        gap: 12px;
                    }

                    .sidebar .nav-link i {
                        width: 24px;
                        text-align: center;
                        font-size: 1.1rem;
                    }

                    .sidebar .nav-link:hover {
                        background: #f8f9fa;
                        color: var(--primary);
                        transform: translateX(5px);
                    }

                    .sidebar .nav-link.active {
                        background: var(--primary);
                        color: #ffffff !important;
                        font-weight: 600;
                        transform: none;
                    }

                    .sidebar hr {
                        background-color: #eaeaea;
                        opacity: 1;
                    }

                    .main-content {
                        background-color: transparent;
                        padding-left: 0;
                    }

                    .navbar-admin {
                        background: #ffffff;
                        padding: 1rem 2rem;
                        box-shadow: 0 2px 10px rgba(0,0,0,0.05);
                        margin-bottom: 2rem;
                        border-bottom: 1px solid #eaeaea;
                        z-index: 900;
                    }

                    .navbar-admin h4 {
                        color: var(--text-color);
                        font-weight: 700;
                        font-size: 1.5rem;
                    }

                    .card {
                        border: 1px solid #eaeaea;
                        border-radius: 12px;
                        background: #ffffff;
                        box-shadow: 0 2px 10px rgba(0,0,0,0.05);
                        margin-bottom: 2rem;
                        overflow: hidden;
                        color: var(--text-color);
                    }

                    .card-header {
                        background: #ffffff;
                        color: var(--text-color);
                        font-weight: 600;
                        font-size: 16px;
                        padding: 1.2rem 1.5rem;
                        border-bottom: 1px solid #eaeaea;
                        border-radius: 12px 12px 0 0 !important;
                    }
                    
                    .card-header h5 i { color: var(--primary); }

                    .form-control,
                    .form-select {
                        border-radius: 8px !important;
                        border: 1px solid #eaeaea;
                        background-color: #ffffff;
                        padding: 10px 14px;
                        color: var(--text-color);
                    }

                    .form-control:focus,
                    .form-select:focus {
                        background-color: #ffffff;
                        border-color: var(--primary);
                        box-shadow: 0 0 0 0.2rem rgba(0,99,137,0.25);
                        color: var(--text-color);
                    }

                    .btn {
                        border-radius: 8px !important;
                        font-weight: 600;
                        padding: 10px 18px;
                    }

                    .btn-primary {
                        background-color: var(--primary) !important;
                        border-color: var(--primary) !important;
                        color: #ffffff !important;
                    }

                    .btn-primary:hover {
                        background-color: #004c6b !important;
                        border-color: #004c6b !important;
                        color: #ffffff !important;
                    }

                    .upload-area {
                        border: 2px dashed #eaeaea !important;
                        background-color: #f8f9fa !important;
                        padding: 20px;
                        text-align: center;
                        cursor: pointer;
                        border-radius: 12px;
                        color: var(--text-color);
                    }

                    .upload-area:hover,
                    .upload-area.dragover {
                        border-color: var(--primary) !important;
                        background-color: #ffffff !important;
                    }

                    .upload-area i {
                        color: var(--primary);
                    }

                    .news-image-preview {
                        max-width: 100%;
                        height: auto;
                        max-height: 200px;
                        border-radius: 12px;
                        box-shadow: var(--shadow-soft);
                        object-fit: cover;
                    }
                </style>
                <jsp:include page="/WEB-INF/views/components/dark-mode.jsp" />
            </head>

            <body>
                <div class="container-fluid">
                    <div class="row">
                        <jsp:include page="/WEB-INF/views/reporter/components/reporter-sidebar.jsp">
                <jsp:param name="activeMenu" value="news" />
            </jsp:include>

            <div class="col-md-9 col-lg-10 ms-auto main-content">
                            <nav class="navbar navbar-expand-lg navbar-admin sticky-top">
                                <div class="container-fluid">
                                    <h4 class="mb-0">${news != null ? 'Sửa tin tức' : 'Thêm tin tức mới'}</h4>
                                    <div class="navbar-nav ms-auto">
                                        <a href="${pageContext.request.contextPath}/reporter/news"
                                            class="btn btn-outline-secondary"><i class="fas fa-arrow-left"></i> Quay
                                            lại</a>
                                    </div>
                                </div>
                            </nav>

                             <div class="container-fluid p-4">
                                <c:if test="${sessionScope.successMessage != null}">
                                    <div class="alert alert-success alert-dismissible fade show d-flex align-items-center" role="alert">
                                        <i class="fas fa-check-circle me-2 fs-5"></i> ${sessionScope.successMessage}
                                        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                                    </div>
                                    <c:remove var="successMessage" scope="session" />
                                </c:if>

                                <c:if test="${sessionScope.errorMessage != null}">
                                    <div class="alert alert-danger alert-dismissible fade show d-flex align-items-center" role="alert">
                                        <i class="fas fa-exclamation-circle me-2 fs-5"></i> ${sessionScope.errorMessage}
                                        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                                    </div>
                                    <c:remove var="errorMessage" scope="session" />
                                </c:if>

                                <form id="newsForm" action="${pageContext.request.contextPath}/reporter/news/save"
                                    method="post" enctype="multipart/form-data">
                                    <div class="row">
                                        <div class="col-lg-8">
                                            <div class="card">
                                                <div class="card-header">
                                                    <h5 class="mb-0"><i class="fas fa-edit"></i> Nội dung</h5>
                                                </div>
                                                <div class="card-body">
                                                    <c:if test="${news != null}"><input type="hidden" name="id"
                                                            value="${news.id}"></c:if>
                                                    <div class="mb-3">
                                                        <label class="form-label">Tiêu đề <span class="text-danger">*</span></label>
                                                        <input type="text" class="form-control" name="title"
                                                            value="${news.title}" required placeholder="Nhập tiêu đề tin tức...">
                                                    </div>
                                                    <div class="mb-3">
                                                        <label class="form-label">Mô tả ngắn (Summary) <span class="text-danger">*</span></label>
                                                        <textarea class="form-control" name="summary" rows="3" required placeholder="Nhập mô tả tóm tắt ngắn của tin tức...">${news.summary}</textarea>
                                                    </div>
                                                    <div class="mb-3">
                                                        <label class="form-label">Chuyên mục chính <span class="text-danger">*</span></label>
                                                        <select class="form-select" id="categoryId" name="categoryId" required>
                                                            <option value="">-- Chọn chuyên mục --</option>
                                                            <c:forEach var="cat" items="${categories}">
                                                                <option value="${cat.id}" ${news.categoryId == cat.id ? 'selected' : ''}>${cat.name}</option>
                                                            </c:forEach>
                                                        </select>
                                                    </div>

                                                    <div class="mb-3">
                                                        <label class="form-label">Danh mục con (Tùy chọn)</label>
                                                        <select class="form-select" id="subCategoryId" name="subCategoryId">
                                                            <option value="">-- Vui lòng chọn chuyên mục chính trước --</option>
                                                        </select>
                                                    </div>
                                                    <div class="mb-3">
                                                        <label class="form-label">Lên lịch xuất bản (Tùy chọn)</label>
                                                        <fmt:formatDate value="${news.scheduledDate}" pattern="yyyy-MM-dd'T'HH:mm" var="formattedScheduledDate" />
                                                        <input type="datetime-local" class="form-control" name="scheduledDate" value="${formattedScheduledDate}">
                                                        <small class="text-muted d-block mt-1">Lưu ý: Để trống nếu muốn tin tức xuất bản ngay khi được duyệt.</small>
                                                    </div>
                                                    <div class="mb-3">
                                                        <label class="form-label">Nội dung bài viết <span class="text-danger">*</span></label>
                                                        <textarea class="form-control" id="content" name="content" rows="12"
                                                            required>${news.content}</textarea>
                                                    </div>
                                                </div>
                                            </div>

                                            <!-- Card Cấu hình SEO -->
                                            <div class="card mt-4">
                                                <div class="card-header bg-light">
                                                    <h5 class="mb-0 text-dark"><i class="fas fa-search"></i> Cấu hình SEO (Tùy chọn)</h5>
                                                </div>
                                                <div class="card-body">
                                                    <div class="mb-3">
                                                        <label class="form-label">URL Slug tùy chỉnh</label>
                                                        <input type="text" class="form-control" name="slug" value="${news.slug}" placeholder="Ví dụ: tieu-de-bai-viet (Tự động tạo nếu để trống)">
                                                    </div>
                                                    <div class="mb-3">
                                                        <label class="form-label">SEO Meta Title</label>
                                                        <input type="text" class="form-control" name="metaTitle" id="metaTitle" value="${news.metaTitle}" maxlength="65" placeholder="Tiêu đề hiển thị trên Google (Tự động điền nếu để trống)">
                                                        <div class="progress mt-1" style="height: 5px;">
                                                            <div id="titleProgress" class="progress-bar" role="progressbar" style="width: 0%"></div>
                                                        </div>
                                                        <small class="text-muted d-block mt-1"><span id="titleCount">0</span>/65 ký tự (Khuyên dùng: 50-60 ký tự)</small>
                                                    </div>
                                                    <div class="mb-3">
                                                        <label class="form-label">SEO Meta Description</label>
                                                        <textarea class="form-control" name="metaDescription" id="metaDescription" rows="2" maxlength="160" placeholder="Mô tả hiển thị trên kết quả tìm kiếm (Tự động điền nếu để trống)">${news.metaDescription}</textarea>
                                                        <div class="progress mt-1" style="height: 5px;">
                                                            <div id="descProgress" class="progress-bar" role="progressbar" style="width: 0%"></div>
                                                        </div>
                                                        <small class="text-muted d-block mt-1"><span id="descCount">0</span>/160 ký tự (Khuyên dùng: 120-150 ký tự)</small>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>

                                        <div class="col-lg-4">
                                            <div class="card">
                                                <div class="card-header">
                                                    <h5 class="mb-0"><i class="fas fa-image"></i> Hình ảnh</h5>
                                                </div>
                                                <div class="card-body">
                                                    <c:if test="${not empty news.image}">
                                                        <div class="mb-3" id="currentImageArea">
                                                            <label class="form-label">Ảnh hiện tại:</label>
                                                            <div class="text-center">
                                                                <img src="${pageContext.request.contextPath}/images/${news.image}"
                                                                    class="news-image-preview img-thumbnail">
                                                            </div>
                                                        </div>
                                                    </c:if>

                                                    <div class="upload-area" id="dropZone">
                                                        <i class="fas fa-cloud-upload-alt fa-3x mb-3"></i>
                                                        <h6>Kéo thả ảnh hoặc click để chọn</h6>
                                                        <input type="file" id="dropInput" name="image" accept="image/*"
                                                            style="display: none;">
                                                    </div>

                                                    <div id="imagePreview" class="mt-3 text-center"
                                                        style="display: none;">
                                                        <label class="form-label d-block text-start">Xem trước ảnh
                                                            mới:</label>
                                                        <img id="previewImg" class="news-image-preview img-thumbnail">
                                                        <button type="button"
                                                            class="btn btn-sm btn-outline-danger mt-2 w-100"
                                                            onclick="removeImage()">
                                                            <i class="fas fa-trash"></i> Hủy chọn ảnh này
                                                        </button>
                                                    </div>
                                                </div>
                                            </div>
                                            <input type="hidden" name="status" id="formStatus" value="0">
                                            <button type="submit" class="btn btn-primary w-100 py-3 fw-bold">
                                                <i class="fas fa-save me-2"></i> ${news != null ? 'CẬP NHẬT' : 'ĐĂNG BÀI'}
                                            </button>
                                            <button type="button" id="btnSaveDraft" class="btn btn-outline-secondary w-100 py-2 fw-bold mt-2">
                                                <i class="fas fa-file-alt me-2"></i> LƯU BẢN NHÁP
                                            </button>
                                        </div>
                                    </div>
                                </form>
                            </div>
                        </div>
                    </div>
                </div>

                <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
                <script>
                    const dropZone = document.getElementById('dropZone');
                    const dropInput = document.getElementById('dropInput');
                    const imagePreview = document.getElementById('imagePreview');
                    const previewImg = document.getElementById('previewImg');
                    const currentImageArea = document.getElementById('currentImageArea');

                    // 1. Click vào vùng dashed để chọn file
                    dropZone.addEventListener('click', () => dropInput.click());

                    // 2. Khi chọn file từ cửa sổ Explorer
                    dropInput.addEventListener('change', function () {
                        if (this.files && this.files[0]) {
                            handleFile(this.files[0]);
                        }
                    });

                    // 3. Xử lý Kéo thả (Drag & Drop)
                    ['dragenter', 'dragover', 'dragleave', 'drop'].forEach(evt => {
                        dropZone.addEventListener(evt, e => {
                            e.preventDefault();
                            e.stopPropagation();
                        }, false);
                    });

                    dropZone.addEventListener('dragover', () => dropZone.classList.add('dragover'), false);
                    dropZone.addEventListener('dragleave', () => dropZone.classList.remove('dragover'), false);

                    dropZone.addEventListener('drop', (e) => {
                        dropZone.classList.remove('dragover');
                        const file = e.dataTransfer.files[0];
                        if (file) {
                            // // : Gán file từ sự kiện drop vào input file để submit form
                            const dataTransfer = new DataTransfer();
                            dataTransfer.items.add(file);
                            dropInput.files = dataTransfer.files;
                            handleFile(file);
                        }
                    });

                    // 4. Hiển thị ảnh xem trước ngay lập tức
                    function handleFile(file) {
                        if (!file.type.startsWith('image/')) {
                            alert('Vui lòng chỉ chọn file ảnh!');
                            return;
                        }
                        const reader = new FileReader();
                        reader.onload = (e) => {
                            previewImg.src = e.target.result;
                            imagePreview.style.display = 'block';
                            dropZone.style.display = 'none';
                            if (currentImageArea) currentImageArea.style.display = 'none'; // Ẩn ảnh cũ khi đã chọn ảnh mới
                        };
                        reader.readAsDataURL(file);
                    }

                    // 5. Hủy chọn ảnh mới
                    function removeImage() {
                        dropInput.value = "";
                        imagePreview.style.display = 'none';
                        dropZone.style.display = 'block';
                        if (currentImageArea) currentImageArea.style.display = 'block'; // Hiện lại ảnh cũ
                    }

              const subCategoryData = {
            "TECH": ["Thị trường", "Chuyển đổi số", "An ninh mạng", "AI - Trí tuệ nhân tạo"],
            "Công nghệ": ["Thị trường", "Chuyển đổi số", "An ninh mạng", "AI - Trí tuệ nhân tạo"],
            "SPORT": ["Bóng đá", "Tennis", "Esports", "Bóng rổ"],
            "Thể thao": ["Bóng đá", "Tennis", "Esports", "Bóng rổ"],
            
            // : Đổi ENT thành ENTERTAINMENT
            "ENTERTAINMENT": ["Âm nhạc", "Phim ảnh", "Showbiz", "Thời trang"],
            "Giải trí": ["Âm nhạc", "Phim ảnh", "Showbiz", "Thời trang"],
            
            // : Đổi BIZ thành BUSINESS
            "BUSINESS": ["Chứng khoán", "Bất động sản", "Khởi nghiệp"],
            "Kinh doanh": ["Chứng khoán", "Bất động sản", "Khởi nghiệp"],
            
            "HEALTH": ["Dinh dưỡng", "Y tế", "Làm đẹp"],
            "Sức khỏe": ["Dinh dưỡng", "Y tế", "Làm đẹp"]
        };

                    const categorySelect = document.getElementById('categoryId');
                    const subCategorySelect = document.getElementById('subCategoryId');

                    function loadSubCategories() {
                        // Lấy ID (VD: TECH) hoặc Tên (đã cắt khoảng trắng 2 đầu)
                        const selectedValue = categorySelect.value;
                        const selectedText = categorySelect.options[categorySelect.selectedIndex].text.trim();
                        
                        // Xóa dữ liệu cũ
                        subCategorySelect.innerHTML = '<option value="">-- Chọn danh mục con --</option>';
                        
                        // Tìm mảng danh mục con (Ưu tiên tìm theo ID trước, không có thì tìm theo Tên)
                        const subCats = subCategoryData[selectedValue] || subCategoryData[selectedText];

                        if (subCats) {
                            subCats.forEach(subCat => {
                                // Tạo thẻ option chuẩn DOM để không bị lỗi tàng hình chữ
                                let opt = document.createElement('option');
                                opt.value = subCat;
                                opt.text = subCat;
                                
                                // (Tùy chọn) Nếu đang sửa bài, tự động chọn lại mục cũ
                                if ("${news.subCategory}" === subCat) {
                                    opt.selected = true;
                                }
                                
                                subCategorySelect.appendChild(opt);
                            });
                        } else {
                            subCategorySelect.innerHTML = '<option value="">Không có danh mục con</option>';
                        }
                    }

                    // Lắng nghe sự kiện khi đổi chuyên mục
                    categorySelect.addEventListener('change', loadSubCategories);

                    // Kích hoạt ngay khi vừa mở trang (để load sẵn nếu đang ở trang Sửa bài)
                    if (categorySelect.value !== "") {
                        loadSubCategories();
                    }

                    // Khởi tạo CKEditor 4 cho textarea content
                    CKEDITOR.replace('content');

                    // Bộ đếm ký tự SEO Meta Title & Meta Description
                    function updateSEOIndicator() {
                        const titleInput = document.getElementById('metaTitle');
                        const descInput = document.getElementById('metaDescription');
                        
                        const titleCount = document.getElementById('titleCount');
                        const titleProgress = document.getElementById('titleProgress');
                        
                        const descCount = document.getElementById('descCount');
                        const descProgress = document.getElementById('descProgress');
                        
                        if (titleInput) {
                            const val = titleInput.value.length;
                            titleCount.innerText = val;
                            const percentage = Math.min((val / 65) * 100, 100);
                            titleProgress.style.width = percentage + '%';
                            
                            if (val >= 50 && val <= 60) {
                                titleProgress.className = "progress-bar bg-success";
                            } else if (val > 60) {
                                titleProgress.className = "progress-bar bg-danger";
                            } else {
                                titleProgress.className = "progress-bar bg-warning";
                            }
                        }
                        
                        if (descInput) {
                            const val = descInput.value.length;
                            descCount.innerText = val;
                            const percentage = Math.min((val / 160) * 100, 100);
                            descProgress.style.width = percentage + '%';
                            
                            if (val >= 120 && val <= 150) {
                                descProgress.className = "progress-bar bg-success";
                            } else if (val > 150) {
                                descProgress.className = "progress-bar bg-danger";
                            } else {
                                descProgress.className = "progress-bar bg-warning";
                            }
                        }
                    }
                    
                    document.getElementById('metaTitle').addEventListener('input', updateSEOIndicator);
                    document.getElementById('metaDescription').addEventListener('input', updateSEOIndicator);
                    
                    // Chạy ngay khi mở trang để hiển thị thanh đo
                    updateSEOIndicator();

                    // // FIX: Xử lý khi click nút Lưu nháp thủ công
                    var btnSaveDraft = document.getElementById("btnSaveDraft");
                    if (btnSaveDraft) {
                        btnSaveDraft.addEventListener("click", function() {
                            document.getElementById("formStatus").value = "3"; // Đặt trạng thái là Bản nháp
                            // // FIX: Cập nhật dữ liệu từ CKEditor vào textarea trước khi submit
                            if (window.CKEDITOR && CKEDITOR.instances.content) {
                                CKEDITOR.instances.content.updateElement();
                            }
                            // Loại bỏ thuộc tính required tạm thời để cho phép lưu nháp khi chưa nhập đủ
                            document.querySelectorAll("#newsForm [required]").forEach(function(el) {
                                el.removeAttribute("required");
                            });
                            document.getElementById("newsForm").submit();
                        });
                    }

                    // // FIX: Auto-save bài viết tự động mỗi 60 giây qua Ajax
                    setInterval(function() {
                        autoSaveDraft();
                    }, 60000); // 60 giây

                    function autoSaveDraft() {
                        // Lấy tiêu đề, nếu tiêu đề rỗng thì không tự động lưu để tránh rác DB
                        var titleInput = document.querySelector('input[name="title"]');
                        var title = titleInput ? titleInput.value.trim() : "";
                        if (!title) {
                            console.log("Tiêu đề trống, bỏ qua auto-save.");
                            return;
                        }

                        // Cập nhật dữ liệu từ CKEditor vào textarea trước khi lấy giá trị
                        if (window.CKEDITOR && CKEDITOR.instances.content) {
                            CKEDITOR.instances.content.updateElement();
                        }

                        var idInput = document.querySelector('input[name="id"]');
                        var id = idInput ? idInput.value : "";
                        var content = CKEDITOR.instances.content ? CKEDITOR.instances.content.getData() : "";
                        var summaryInput = document.querySelector('textarea[name="summary"]');
                        var summary = summaryInput ? summaryInput.value : "";
                        var catInput = document.querySelector('select[name="categoryId"]');
                        var categoryId = catInput ? catInput.value : "";
                        var subCatInput = document.querySelector('select[name="subCategoryId"]');
                        var subCategoryId = subCatInput ? subCatInput.value : "";
                        var slugInput = document.querySelector('input[name="slug"]');
                        var slug = slugInput ? slugInput.value : "";
                        var metaTitleInput = document.querySelector('input[name="metaTitle"]');
                        var metaTitle = metaTitleInput ? metaTitleInput.value : "";
                        var metaDescInput = document.querySelector('textarea[name="metaDescription"]');
                        var metaDescription = metaDescInput ? metaDescInput.value : "";
                        var dateInput = document.querySelector('input[name="scheduledDate"]');
                        var scheduledDate = dateInput ? dateInput.value : "";

                        // Hiển thị trạng thái đang lưu
                        showAutoSaveStatus("Đang tự động lưu nháp...");

                        // Gửi Ajax qua Fetch API
                        var params = new URLSearchParams();
                        params.append("id", id);
                        params.append("title", title);
                        params.append("content", content);
                        params.append("summary", summary);
                        params.append("categoryId", categoryId);
                        params.append("subCategoryId", subCategoryId);
                        params.append("slug", slug);
                        params.append("metaTitle", metaTitle);
                        params.append("metaDescription", metaDescription);
                        params.append("scheduledDate", scheduledDate);

                        fetch("${pageContext.request.contextPath}/reporter/news/autosave", {
                            method: "POST",
                            headers: {
                                "Content-Type": "application/x-www-form-urlencoded"
                            },
                            body: params.toString()
                        })
                        .then(function(res) { return res.json(); })
                        .then(function(data) {
                            if (data.success) {
                                // Nếu là bài viết mới và chưa có hidden input ID, tạo mới
                                if (!id && data.id) {
                                    var form = document.getElementById("newsForm");
                                    var input = document.createElement("input");
                                    input.type = "hidden";
                                    input.name = "id";
                                    input.value = data.id;
                                    form.appendChild(input);
                                }
                                showAutoSaveStatus("Đã tự động lưu nháp lúc " + new Date().toLocaleTimeString(), "success");
                            } else {
                                showAutoSaveStatus("Lỗi tự động lưu nháp", "danger");
                            }
                        })
                        .catch(function(err) {
                            console.error("Lỗi Auto-save:", err);
                            showAutoSaveStatus("Lỗi kết nối khi tự động lưu", "danger");
                        });
                    }

                    function showAutoSaveStatus(msg, type) {
                        var statusDiv = document.getElementById("autoSaveStatus");
                        if (!statusDiv) {
                            statusDiv = document.createElement("div");
                            statusDiv.id = "autoSaveStatus";
                            statusDiv.style.position = "fixed";
                            statusDiv.style.bottom = "20px";
                            statusDiv.style.right = "20px";
                            statusDiv.style.zIndex = "9999";
                            statusDiv.style.padding = "10px 15px";
                            statusDiv.style.borderRadius = "8px";
                            statusDiv.style.fontSize = "0.9rem";
                            statusDiv.style.fontWeight = "600";
                            statusDiv.style.boxShadow = "0 4px 12px rgba(0,0,0,0.15)";
                            document.body.appendChild(statusDiv);
                        }
                        statusDiv.innerText = msg;
                        statusDiv.style.display = "block";
                        if (type === "success") {
                            statusDiv.style.backgroundColor = "#10b981";
                            statusDiv.style.color = "#ffffff";
                            setTimeout(function() {
                                statusDiv.style.display = "none";
                            }, 3000);
                        } else if (type === "danger") {
                            statusDiv.style.backgroundColor = "#ef4444";
                            statusDiv.style.color = "#ffffff";
                        } else {
                            statusDiv.style.backgroundColor = "#006389";
                            statusDiv.style.color = "#ffffff";
                        }
                    }
                </script>
            </body>

            </html>