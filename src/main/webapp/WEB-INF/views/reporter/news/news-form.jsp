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
                                                        <label class="form-label">Tiêu đề</label>
                                                        <input type="text" class="form-control" name="title"
                                                            value="${news.title}" required>
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
                                                        <label class="form-label">Nội dung bài viết</label>
                                                        <textarea class="form-control" name="content" rows="12"
                                                            required>${news.content}</textarea>
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
                                            <button type="submit" class="btn btn-primary w-100 py-3 fw-bold">
                                                <i class="fas fa-save me-2"></i> ${news != null ? 'CẬP NHẬT' : 'ĐĂNG
                                                BÀI'}
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
                </script>
            </body>

            </html>