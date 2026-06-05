<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="vi">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Quản lý bình luận - XYZ Reporter</title>

    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Be+Vietnam+Pro:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">

    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">

    <style>
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

        .main-content {
            background-color: transparent;
            padding-left: 0;
            padding-top: 0;
        }

        .navbar-admin {
            background: #ffffff;
            padding: 1rem 2rem;
            box-shadow: 0 2px 10px rgba(0,0,0,0.05);
            margin-bottom: 2rem;
            border-bottom: 1px solid #eaeaea;
            z-index: 900;
            display: flex;
            align-items: center;
        }

        .navbar-admin h4 {
            color: var(--text-color);
            font-weight: 700;
            font-size: 1.5rem;
        }

        .navbar-text {
            background: #f8f9fa;
            padding: 8px 16px;
            border-radius: 50px;
            display: flex;
            align-items: center;
            gap: 10px;
            color: var(--text-color);
            font-weight: 600;
            border: 1px solid #eaeaea;
        }

        .navbar-text i {
            color: var(--primary);
            font-size: 1.2rem;
        }

        .page-title {
            font-size: 26px;
            font-weight: 700;
            margin-bottom: 12px;
            position: relative;
            padding-bottom: 12px;
            color: var(--text-color);
        }

        .page-title::after {
            content: "";
            position: absolute;
            bottom: 0;
            left: 0;
            width: 60px;
            height: 3px;
            background: var(--primary);
            border-radius: 2px;
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
            font-weight: 700;
            font-size: 1.1rem;
            padding: 1.2rem 1.5rem;
            border-bottom: 1px solid #eaeaea;
            border-radius: 12px 12px 0 0 !important;
            display: flex;
            align-items: center;
            gap: 10px;
        }

        .card-header i {
            color: var(--primary);
        }

        .comment-item {
            border-bottom: 1px solid #f1f3f5;
            padding: 1.5rem;
        }

        .comment-item:last-child {
            border-bottom: none;
        }

        .comment-item.pinned-comment {
            background-color: #f0f7ff;
            border-left: 4px solid #0d6efd;
        }

        .comment-item.hidden-comment {
            background-color: #fafafa;
            opacity: 0.8;
        }

        .meta-info {
            font-size: 0.85rem;
            color: var(--text-muted);
        }

        .badge-author {
            background-color: #e0f2fe;
            color: #0369a1;
            font-size: 0.75rem;
            font-weight: 700;
            padding: 0.25rem 0.5rem;
            border-radius: 4px;
        }

        .btn-comment-action {
            padding: 0.25rem 0.6rem;
            font-size: 0.85rem;
            font-weight: 600;
            border-radius: 6px;
        }

        /* Float toast notification */
        .toast-container {
            position: fixed;
            top: 20px;
            right: 20px;
            z-index: 1060;
        }
    </style>
    <jsp:include page="/WEB-INF/views/components/dark-mode.jsp" />
</head>

<body>
    <div class="container-fluid">
        <div class="row">
            <jsp:include page="/WEB-INF/views/reporter/components/reporter-sidebar.jsp">
                <jsp:param name="activeMenu" value="comments" />
            </jsp:include>

            <div class="col-md-9 col-lg-10 ms-auto main-content">
                <nav class="navbar navbar-expand-lg navbar-admin sticky-top">
                    <div class="container-fluid">
                        <h4 class="mb-0">Quản lý bình luận</h4>
                        <div class="navbar-nav ms-auto">
                            <span class="navbar-text">
                                <i class="fas fa-user-circle"></i> Xin chào, ${sessionScope.currentUser.fullname}
                            </span>
                        </div>
                    </div>
                </nav>

                <div class="container-fluid px-4">
                    <h2 class="page-title">Ý kiến độc giả</h2>

                    <div class="card mt-4">
                        <div class="card-header">
                            <i class="fas fa-comments"></i> Danh sách bình luận trên bài viết của bạn
                        </div>
                        <div class="card-body p-0">
                            <c:choose>
                                <c:when test="${empty commentList}">
                                    <div class="text-center py-5 text-muted">
                                        <i class="fas fa-comment-slash fa-3x mb-3"></i>
                                        <p>Chưa có bình luận nào cho các bài viết của bạn.</p>
                                    </div>
                                </c:when>
                                <c:otherwise>
                                    <c:forEach var="cmt" items="${commentList}">
                                        <%-- Chỉ xử lý comment gốc ở danh sách chính để ghim/phản hồi, các reply con có thể được quản lý gián tiếp hoặc hiển thị dưới dạng luồng --%>
                                        <c:if test="${cmt.parentId == 0}">
                                            <div class="comment-item ${cmt.isPinned ? 'pinned-comment' : ''} ${cmt.isHidden ? 'hidden-comment' : ''}" id="comment-container-${cmt.id}">
                                                <div class="d-flex justify-content-between align-items-start">
                                                    <div>
                                                        <h6 class="fw-bold mb-1">
                                                            ${cmt.userFullName}
                                                            <c:if test="${cmt.userId == sessionScope.currentUser.id}">
                                                                <span class="badge-author ms-2"><i class="fas fa-pen-nib"></i> Tác giả</span>
                                                            </c:if>
                                                        </h6>
                                                        <div class="meta-info mb-2">
                                                            <i class="far fa-clock"></i> 
                                                            <fmt:formatDate value="${cmt.createdDate}" pattern="HH:mm dd/MM/yyyy" />
                                                            <span class="mx-2">|</span>
                                                            <i class="fas fa-book-open"></i> Bài viết: <span class="fw-semibold text-primary">${cmt.newsTitle}</span>
                                                        </div>
                                                        <p class="mb-3 comment-text" id="comment-text-${cmt.id}">${cmt.content}</p>
                                                        
                                                        <%-- Hiển thị danh sách câu trả lời hiện tại --%>
                                                        <div class="reply-section ms-4 ps-3 border-start" id="replies-container-${cmt.id}">
                                                            <c:forEach var="reply" items="${commentList}">
                                                                <c:if test="${reply.parentId == cmt.id}">
                                                                    <div class="reply-item py-2 border-bottom border-light">
                                                                        <div class="d-flex justify-content-between align-items-center">
                                                                            <span class="fw-bold text-secondary" style="font-size: 0.9rem;">
                                                                                ${reply.userFullName}
                                                                                <c:if test="${reply.userId == sessionScope.currentUser.id}">
                                                                                    <span class="badge-author ms-1" style="font-size: 0.7rem;"><i class="fas fa-pen-nib"></i> Tác giả</span>
                                                                                </c:if>
                                                                            </span>
                                                                            <span class="text-muted" style="font-size: 0.8rem;">
                                                                                <fmt:formatDate value="${reply.createdDate}" pattern="HH:mm dd/MM/yyyy" />
                                                                            </span>
                                                                        </div>
                                                                        <p class="mb-0 text-muted" style="font-size: 0.9rem;">${reply.content}</p>
                                                                    </div>
                                                                </c:if>
                                                            </c:forEach>
                                                        </div>
                                                    </div>

                                                    <div class="d-flex gap-2">
                                                        <%-- Nút Ghim --%>
                                                        <button class="btn btn-sm ${cmt.isPinned ? 'btn-primary' : 'btn-outline-primary'} btn-comment-action" 
                                                                onclick="togglePin(this)" 
                                                                data-id="${cmt.id}" 
                                                                data-pinned="${cmt.isPinned}" 
                                                                id="btn-pin-${cmt.id}">
                                                            <i class="fas fa-thumbtack me-1"></i> ${cmt.isPinned ? 'Bỏ Ghim' : 'Ghim'}
                                                        </button>
                                                        
                                                        <%-- Nút Ẩn --%>
                                                        <button class="btn btn-sm ${cmt.isHidden ? 'btn-danger' : 'btn-outline-danger'} btn-comment-action" 
                                                                onclick="toggleHide(this)" 
                                                                data-id="${cmt.id}" 
                                                                data-hidden="${cmt.isHidden}" 
                                                                id="btn-hide-${cmt.id}">
                                                            <i class="fas ${cmt.isHidden ? 'fa-eye' : 'fa-eye-slash'} me-1"></i> ${cmt.isHidden ? 'Hiện' : 'Ẩn'}
                                                        </button>

                                                        <%-- Nút Trả Lời --%>
                                                        <button class="btn btn-sm btn-outline-secondary btn-comment-action" 
                                                                onclick="showReplyForm(this)" 
                                                                data-id="${cmt.id}">
                                                            <i class="fas fa-reply me-1"></i> Phản hồi
                                                        </button>
                                                    </div>
                                                </div>

                                                <%-- Form phản hồi ẩn --%>
                                                <div class="mt-3 ms-4 d-none" id="reply-form-container-${cmt.id}">
                                                    <div class="input-group">
                                                        <input type="text" class="form-control" placeholder="Nhập câu trả lời của bạn..." id="reply-input-${cmt.id}">
                                                        <button class="btn btn-primary" type="button" 
                                                                onclick="submitReply(this)" 
                                                                data-parent-id="${cmt.id}" 
                                                                data-news-id="${cmt.newsId}">
                                                            <i class="fas fa-paper-plane me-1"></i> Gửi
                                                        </button>
                                                        <button class="btn btn-outline-secondary" type="button" 
                                                                onclick="hideReplyForm(this)" 
                                                                data-id="${cmt.id}">
                                                            Hủy
                                                        </button>
                                                    </div>
                                                </div>
                                            </div>
                                        </c:if>
                                    </c:forEach>
                                </c:otherwise>
                            </c:choose>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- Toast container cho thông báo trôi nổi -->
    <div class="toast-container">
        <div id="action-toast" class="toast align-items-center text-white border-0" role="alert" aria-live="assertive" aria-atomic="true">
            <div class="d-flex">
                <div class="toast-body" id="toast-message"></div>
                <button type="button" class="btn-close btn-close-white me-2 m-auto" data-bs-dismiss="toast" aria-label="Close"></button>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        // Hiển thị thông báo Toast
        function showToast(message, isSuccess = true) {
            const toastEl = document.getElementById('action-toast');
            const toastMessage = document.getElementById('toast-message');
            toastMessage.textContent = message;
            
            toastEl.classList.remove('bg-success', 'bg-danger');
            toastEl.classList.add(isSuccess ? 'bg-success' : 'bg-danger');
            
            const toast = new bootstrap.Toast(toastEl);
            toast.show();
        }

        // Bật/tắt ghim bình luận bằng Ajax
        function togglePin(element) {
            const commentId = element.getAttribute('data-id');
            const isPin = element.getAttribute('data-pinned') === 'false';
            
            fetch('${pageContext.request.contextPath}/reporter/comments/pin', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/x-www-form-urlencoded',
                },
                body: new URLSearchParams({
                    'commentId': commentId,
                    'pin': isPin
                })
            })
            .then(res => res.json())
            .then(data => {
                if (data.success) {
                    showToast(isPin ? 'Đã ghim bình luận thành công!' : 'Đã bỏ ghim bình luận!');
                    const btn = document.getElementById('btn-pin-' + commentId);
                    const container = document.getElementById('comment-container-' + commentId);
                    
                    if (isPin) {
                        btn.classList.remove('btn-outline-primary');
                        btn.classList.add('btn-primary');
                        btn.innerHTML = '<i class="fas fa-thumbtack me-1"></i> Bỏ Ghim';
                        btn.setAttribute('data-pinned', 'true');
                        container.classList.add('pinned-comment');
                    } else {
                        btn.classList.remove('btn-primary');
                        btn.classList.add('btn-outline-primary');
                        btn.innerHTML = '<i class="fas fa-thumbtack me-1"></i> Ghim';
                        btn.setAttribute('data-pinned', 'false');
                        container.classList.remove('pinned-comment');
                    }
                } else {
                    showToast('Có lỗi xảy ra, không thể thay đổi trạng thái ghim.', false);
                }
            })
            .catch(err => {
                console.error(err);
                showToast('Không thể kết nối đến máy chủ.', false);
            });
        }

        // Bật/tắt ẩn bình luận bằng Ajax
        function toggleHide(element) {
            const commentId = element.getAttribute('data-id');
            const isHide = element.getAttribute('data-hidden') === 'false';
            
            fetch('${pageContext.request.contextPath}/reporter/comments/hide', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/x-www-form-urlencoded',
                },
                body: new URLSearchParams({
                    'commentId': commentId,
                    'hide': isHide
                })
            })
            .then(res => res.json())
            .then(data => {
                if (data.success) {
                    showToast(isHide ? 'Đã ẩn bình luận thành công!' : 'Đã hiển thị bình luận!');
                    const btn = document.getElementById('btn-hide-' + commentId);
                    const container = document.getElementById('comment-container-' + commentId);
                    
                    if (isHide) {
                        btn.classList.remove('btn-outline-danger');
                        btn.classList.add('btn-danger');
                        btn.innerHTML = '<i class="fas fa-eye me-1"></i> Hiện';
                        btn.setAttribute('data-hidden', 'true');
                        container.classList.add('hidden-comment');
                    } else {
                        btn.classList.remove('btn-danger');
                        btn.classList.add('btn-outline-danger');
                        btn.innerHTML = '<i class="fas fa-eye-slash me-1"></i> Ẩn';
                        btn.setAttribute('data-hidden', 'false');
                        container.classList.remove('hidden-comment');
                    }
                } else {
                    showToast('Có lỗi xảy ra, không thể ẩn bình luận.', false);
                }
            })
            .catch(err => {
                console.error(err);
                showToast('Không thể kết nối đến máy chủ.', false);
            });
        }

        // Hiển thị/ẩn form phản hồi
        function showReplyForm(element) {
            const commentId = element.getAttribute('data-id');
            const formContainer = document.getElementById('reply-form-container-' + commentId);
            formContainer.classList.remove('d-none');
            document.getElementById('reply-input-' + commentId).focus();
        }

        function hideReplyForm(param) {
            const commentId = (param && typeof param === 'object') ? param.getAttribute('data-id') : param;
            const formContainer = document.getElementById('reply-form-container-' + commentId);
            formContainer.classList.add('d-none');
            document.getElementById('reply-input-' + commentId).value = '';
        }

        // Gửi bình luận phản hồi bằng Ajax
        function submitReply(element) {
            const parentId = element.getAttribute('data-parent-id');
            const newsId = element.getAttribute('data-news-id');
            const input = document.getElementById('reply-input-' + parentId);
            const content = input.value.trim();
            if (!content) {
                showToast('Nội dung phản hồi không được để trống.', false);
                return;
            }

            fetch('${pageContext.request.contextPath}/reporter/comments/reply', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/x-www-form-urlencoded',
                },
                body: new URLSearchParams({
                    'parentId': parentId,
                    'newsId': newsId,
                    'content': content
                })
            })
            .then(res => res.json())
            .then(data => {
                if (data.success) {
                    showToast('Gửi phản hồi thành công!');
                    hideReplyForm(parentId);
                    
                    // Thêm trực tiếp reply mới vào giao diện
                    const repliesContainer = document.getElementById('replies-container-' + parentId);
                    const now = new Date();
                    const timeStr = now.getHours().toString().padStart(2, '0') + ':' + 
                                  now.getMinutes().toString().padStart(2, '0') + ' ' + 
                                  now.getDate().toString().padStart(2, '0') + '/' + 
                                  (now.getMonth() + 1).toString().padStart(2, '0') + '/' + 
                                  now.getFullYear();

                    const newReplyHtml = `
                        <div class="reply-item py-2 border-bottom border-light">
                            <div class="d-flex justify-content-between align-items-center">
                                <span class="fw-bold text-secondary" style="font-size: 0.9rem;">
                                    ${sessionScope.currentUser.fullname}
                                    <span class="badge-author ms-1" style="font-size: 0.7rem;"><i class="fas fa-pen-nib"></i> Tác giả</span>
                                </span>
                                <span class="text-muted" style="font-size: 0.8rem;">
                                    ${timeStr}
                                </span>
                            </div>
                            <p class="mb-0 text-muted" style="font-size: 0.9rem;">${content}</p>
                        </div>
                    `;
                    repliesContainer.insertAdjacentHTML('beforeend', newReplyHtml);
                } else {
                    showToast(data.message || 'Không thể gửi phản hồi.', false);
                }
            })
            .catch(err => {
                console.error(err);
                showToast('Không thể kết nối đến máy chủ.', false);
            });
        }
    </script>
</body>

</html>
