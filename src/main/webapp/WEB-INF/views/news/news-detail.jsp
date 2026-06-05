<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
            <!DOCTYPE html>
            <html lang="vi">

            <head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>${not empty news.metaTitle ? news.metaTitle : news.title} - XYZ News</title>
    <c:if test="${not empty news.metaDescription}">
        <meta name="description" content="<c:out value="${news.metaDescription}" />">
    </c:if>
    

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
        .news-content img { max-width: 100%; height: auto; border-radius: 8px; margin: 1rem 0; }
        .share-btn { transition: all 0.3s cubic-bezier(0.165, 0.84, 0.44, 1); }
        .share-btn:hover { transform: translateY(-3px); box-shadow: 0 5px 10px rgba(0,0,0,0.15); }
        @keyframes fadeInUp { from { opacity: 0; transform: translateY(20px); } to { opacity: 1; transform: translateY(0); } }
        .smooth-load { animation: fadeInUp 0.5s ease-out forwards; }
    </style>
</head>
<body class="bg-gray-50 text-gray-800 font-sans min-h-screen flex flex-col">
    <jsp:include page="../public/components/header.jsp" />

<div class="w-full flex justify-center items-start relative xl:overflow-visible overflow-hidden">
    <!-- QUẢNG CÁO SIDEBAR TRÁI (Sticky) -->
    <c:if test="${not empty sidebarLeftAds}">
        <div class="hidden xl:block w-[160px] flex-shrink-0 pt-8 z-0 mr-6 relative">
            <div class="sticky top-24 flex flex-col gap-4">
                <c:forEach var="ad" items="${sidebarLeftAds}">
                    <div class="bg-gray-100 rounded flex flex-col items-center justify-center text-gray-400 border border-gray-200 overflow-hidden relative" style="width: 160px; height: 600px;">
                        <span class="absolute top-1 left-2 text-[10px] text-gray-400 bg-white/80 px-1 rounded shadow-sm z-10">Tài trợ</span>
                        <a href="${ad.targetUrl}" target="_blank" class="block w-full h-full">
                            <img src="${ad.imageUrl}" class="w-full h-full object-cover shadow-md rounded" style="image-rendering: -webkit-optimize-contrast; image-rendering: crisp-edges;" loading="lazy" decoding="async" alt="Ad">
                        </a>
                    </div>
                </c:forEach>
            </div>
        </div>
    </c:if>

    <main class="max-w-6xl px-4 py-8 w-full smooth-load bg-white z-10 relative">
        <c:if test="${not empty topBannerAd}">
            <div class="w-full aspect-[1120/90] mb-8 rounded shadow-sm relative overflow-hidden group">
                <span class="absolute top-1 right-2 text-[10px] bg-white/80 text-gray-400 px-1 rounded shadow-sm z-10">Tài trợ</span>
                <a href="${topBannerAd.targetUrl}" target="_blank" class="block w-full h-full">
                    <img src="${topBannerAd.imageUrl}" class="w-full h-full object-cover" style="image-rendering: -webkit-optimize-contrast; image-rendering: crisp-edges;" loading="lazy" decoding="async" alt="Advertisement">
                </a>
            </div>
        </c:if>

        <div class="grid grid-cols-1 lg:grid-cols-12 gap-8">
            <div class="lg:col-span-8">
                            <nav aria-label="breadcrumb" class="mb-6">
                                <ol class="flex items-center space-x-2 text-sm text-gray-500">
                                    <li>
                                        <a href="${pageContext.request.contextPath}/" class="text-primary hover:text-[#004c6b] transition no-underline font-medium">
                                            <i class="fas fa-home me-1"></i> Trang chủ
                                        </a>
                                    </li>
                                    <li><span class="text-gray-300">/</span></li>
                                    <li>
                                        <a href="${pageContext.request.contextPath}/news?action=category&id=${news.categoryId}" class="text-primary hover:text-[#004c6b] transition no-underline font-medium">
                                            ${news.categoryName}
                                        </a>
                                    </li>
                                    <li><span class="text-gray-300">/</span></li>
                                    <li class="text-gray-400 truncate max-w-xs md:max-w-md lg:max-w-lg" aria-current="page">
                                        ${news.title}
                                    </li>
                                </ol>
                            </nav>

                            <article class="bg-white rounded-2xl shadow-sm border border-gray-100 overflow-hidden mb-8">
                                <div class="p-6 md:p-8">
                                    <h1 class="text-3xl md:text-4xl font-serif font-bold text-gray-900 leading-tight mb-6">${news.title}</h1>

                                    <div class="bg-gray-50 border-l-4 border-primary p-4 rounded-lg flex flex-wrap items-center gap-x-6 gap-y-3 mb-8 text-sm font-medium text-gray-600">
                                        <span class="flex items-center gap-2">
                                            <i class="fas fa-user text-primary"></i> ${news.authorName}
                                            <c:if test="${sessionScope.currentUser != null && sessionScope.currentUser.id != news.author}">
                                                <button type="button" id="followBtn" class="ms-2 px-2.5 py-0.5 rounded text-xs font-bold transition ${isFollowing ? 'bg-blue-100 text-blue-700 hover:bg-blue-200' : 'bg-blue-600 text-white hover:bg-blue-700'}" onclick="toggleFollow('${news.author}')">
                                                    ${isFollowing ? 'Đang theo dõi' : 'Theo dõi'}
                                                </button>
                                            </c:if>
                                        </span>
                                        <span class="hidden md:inline text-gray-300">|</span>
                                        <span class="flex items-center gap-2"><i class="fas fa-calendar-alt text-primary"></i> <fmt:formatDate value="${news.postedDate}" pattern="dd/MM/yyyy HH:mm" /></span>
                                        <span class="hidden md:inline text-gray-300">|</span>
                                         <span class="flex items-center gap-2"><i class="fas fa-eye text-primary"></i> <span id="viewCountSpan">${news.viewCount}</span> lượt xem</span>
                                        <span class="hidden md:inline text-gray-300">|</span>
                                        <span class="flex items-center gap-2"><i class="fas fa-tags text-primary"></i> ${news.categoryName}</span>
                                    </div>

<c:if test="${not empty news.image}">
                                        <div class="mb-4">
                                            <c:choose>
                                                <c:when test="${news.image.startsWith('http')}">
                                                    <img src="${news.image}" class="news-image" alt="${news.title}">
                                                </c:when>
                                                <c:otherwise>
                                                    <img src="${pageContext.request.contextPath}/images/${news.image}" class="news-image" alt="${news.title}">
                                                </c:otherwise>
                                            </c:choose>
                                        </div>
                                    </c:if>

                                    <div class="news-content">
                                        ${news.content}
                                    </div>

                                <!-- // : Thay thế cụm nút tương tác bằng layout mới có nút Chia sẻ -->
                                <div class="flex flex-wrap justify-between items-center border-t border-b border-gray-200 py-4 mb-6 mt-8 gap-4">
                                    
                                    <div class="flex flex-wrap gap-3">
                                        <button type="button" class="flex items-center gap-2 px-4 py-2 bg-blue-50 text-blue-600 hover:bg-blue-600 hover:text-white rounded-full font-bold text-sm transition-colors border border-transparent" onclick="reactNews('${news.id}', 'like')">
                                            <i class="far fa-thumbs-up"></i> Thích <span id="likeCount" class="bg-blue-600 text-white rounded-full px-2 py-0.5 text-xs">${news.likeCount != null ? news.likeCount : 0}</span>
                                        </button>
                                        <button type="button" class="flex items-center gap-2 px-4 py-2 bg-gray-50 text-gray-600 hover:bg-red-500 hover:text-white rounded-full font-bold text-sm transition-colors border border-transparent" onclick="reactNews('${news.id}', 'dislike')">
                                            <i class="far fa-thumbs-down"></i> Không thích <span id="dislikeCount" class="bg-red-500 text-white rounded-full px-2 py-0.5 text-xs">${news.dislikeCount != null ? news.dislikeCount : 0}</span>
                                        </button>
                                        <button type="button" class="flex items-center gap-2 px-4 py-2 bg-gray-100 text-gray-700 hover:bg-gray-800 hover:text-white rounded-full font-bold text-sm transition-colors border border-transparent" onclick="toggleCommentSection()">
                                            <i class="far fa-comment-dots"></i> Bình luận <span id="totalCommentBadge" class="bg-gray-800 text-white rounded-full px-2 py-0.5 text-xs">${news.commentCount != null ? news.commentCount : 0}</span>
                                        </button>
                                        <button type="button" id="bookmarkBtn" class="flex items-center gap-2 px-4 py-2 ${isBookmarked ? 'bg-amber-100 text-amber-600 hover:bg-amber-200' : 'bg-gray-100 text-gray-700 hover:bg-amber-500 hover:text-white'} rounded-full font-bold text-sm transition-colors border border-transparent" onclick="toggleBookmark('${news.id}')">
                                            <i class="${isBookmarked ? 'fas' : 'far'} fa-bookmark"></i> <span id="bookmarkText">${isBookmarked ? 'Đã lưu' : 'Lưu bài viết'}</span>
                                        </button>
                                    </div>

                                    <div class="flex items-center gap-3">
                                        <span class="text-gray-500 font-bold text-sm">Chia sẻ:</span>
                                        
                                        <a href="javascript:void(0);" onclick="shareFacebook()" class="w-9 h-9 flex items-center justify-center bg-gray-100 text-blue-600 rounded-full hover:bg-blue-600 hover:text-white transition-colors share-btn no-underline" title="Chia sẻ lên Facebook">
                                            <i class="fab fa-facebook-f"></i>
                                        </a>
                                        
                                        <a href="javascript:void(0);" onclick="shareTwitter()" class="w-9 h-9 flex items-center justify-center bg-gray-100 text-gray-800 rounded-full hover:bg-gray-800 hover:text-white transition-colors share-btn no-underline" title="Chia sẻ lên X (Twitter)">
                                            <i class="fab fa-twitter"></i>
                                        </a>
                                        
                                        <button type="button" onclick="copyArticleLink()" class="w-9 h-9 flex items-center justify-center bg-gray-100 text-gray-500 rounded-full hover:bg-gray-500 hover:text-white transition-colors share-btn border-none" title="Sao chép liên kết">
                                            <i class="fas fa-link"></i>
                                        </button>
                                    </div>
                                </div>

                                <style>
                                    /* // : Animation hover cho nút Share */
                                    .share-btn { transition: all 0.3s cubic-bezier(0.165, 0.84, 0.44, 1); }
                                    .share-btn:hover { transform: translateY(-3px); box-shadow: 0 5px 10px rgba(0,0,0,0.15) !important; }
                                </style>

                                <script>
                                    // : JS xử lý share native
                                    function shareFacebook() {
                                        const url = encodeURIComponent(window.location.href);
                                        window.open('https://www.facebook.com/sharer/sharer.php?u=' + url, 'facebook-share-dialog', 'width=800,height=600');
                                    }

                                    function shareTwitter() {
                                        const url = encodeURIComponent(window.location.href);
                                        const title = encodeURIComponent(document.title);
                                        window.open('https://twitter.com/intent/tweet?url=' + url + '&text=' + title, 'twitter-share-dialog', 'width=800,height=600');
                                    }

                                    function copyArticleLink() {
                                        navigator.clipboard.writeText(window.location.href).then(() => {
                                            alert("Đã sao chép liên kết bài viết vào bộ nhớ tạm!");
                                        }).catch(err => {
                                            console.error('Lỗi khi sao chép: ', err);
                                            alert("Trình duyệt không hỗ trợ sao chép tự động.");
                                        });
                                    }
                                </script>

                                    <div id="comment-section" class="bg-gray-50 rounded-xl p-6 lg:p-8 border border-gray-200 mt-10 hidden">
                                        <h5 class="text-xl font-bold text-gray-900 mb-6 flex items-center gap-2">
                                            <i class="fas fa-comments text-primary"></i> Ý kiến bạn đọc
                                        </h5>

                                        <c:choose>
                                            <c:when test="${sessionScope.currentUser == null}">
                                                <div class="text-center p-8 bg-white rounded-xl border border-gray-200 shadow-sm">
                                                    <i class="fas fa-lock text-4xl text-gray-400 mb-4 block"></i>
                                                    <p class="mb-6 text-gray-500 font-medium">Vui lòng đăng nhập để tham gia bình luận bài viết này.</p>
                                                    <a href="${pageContext.request.contextPath}/login" class="inline-block bg-primary hover:bg-[#004c6b] text-white px-6 py-2.5 rounded-full font-bold transition-colors shadow-md no-underline">Đăng nhập ngay</a>
                                                </div>
                                            </c:when>
                                            <c:otherwise>
                                                <div class="flex gap-4 mb-8">
                                                    <div class="w-12 h-12 bg-primary text-white rounded-full flex items-center justify-center font-bold text-xl flex-shrink-0 shadow-sm">
                                                        ${sessionScope.currentUser.fullname.substring(0, 1).toUpperCase()}
                                                    </div>
                                                    <div class="flex-grow">
                                                        <input type="hidden" id="newsIdInput" value="${news.id}">
                                                        <textarea class="w-full bg-white border border-gray-300 rounded-xl p-4 focus:ring-2 focus:ring-primary focus:border-primary outline-none transition-shadow resize-none" id="commentContent" rows="3" placeholder="Chia sẻ quan điểm của bạn..."></textarea>
                                                        <div class="flex justify-end mt-3">
                                                            <button type="button" class="bg-primary hover:bg-[#004c6b] text-white px-6 py-2.5 rounded-full font-bold transition-colors shadow-md flex items-center gap-2" onclick="addComment()">
                                                                <i class="fas fa-paper-plane"></i> Gửi bình luận
                                                            </button>
                                                        </div>
                                                    </div>
                                                </div>
                                            </c:otherwise>
                                        </c:choose>

                                        <div class="space-y-6 mt-8" id="commentsContainer">
                                            <c:forEach var="cmt" items="${commentsList}">
                                                <div class="flex gap-4 p-5 bg-white border border-gray-100 rounded-xl shadow-sm hover:shadow-md transition-shadow relative" id="comment-box-${cmt.id}">
                                                    <div class="w-12 h-12 bg-gray-500 text-white rounded-full flex items-center justify-center font-bold text-xl flex-shrink-0 shadow-sm">
                                                        ${cmt.userFullName.substring(0, 1).toUpperCase()}
                                                    </div>
                                                    <div class="flex-grow">
                                                        <div class="flex justify-between items-start mb-2">
                                                            <div>
                                                                <h6 class="font-bold text-gray-900 m-0 text-base">
                                                                    ${cmt.userFullName}
                                                                    <c:if test="${cmt.userId == news.author}">
                                                                        <span class="inline-flex items-center gap-1 ml-2 px-2 py-0.5 rounded text-xs font-semibold bg-blue-100 text-blue-800 border border-blue-200">
                                                                            <i class="fas fa-pen-nib text-[10px]"></i> Tác giả
                                                                        </span>
                                                                    </c:if>
                                                                    <c:if test="${cmt.isPinned}">
                                                                        <span class="inline-flex items-center gap-1 ml-2 px-2 py-0.5 rounded text-xs font-semibold bg-yellow-100 text-yellow-800 border border-yellow-200" title="Được tác giả ghim">
                                                                            <i class="fas fa-thumbtack text-[10px]"></i> Đã ghim
                                                                        </span>
                                                                    </c:if>
                                                                </h6>
                                                                <small class="text-gray-500 flex items-center gap-1 mt-1">
                                                                    <i class="far fa-clock"></i>
                                                                    <fmt:formatDate value="${cmt.createdDate}" pattern="dd/MM/yyyy HH:mm" />
                                                                </small>
                                                            </div>
                                                            <div class="flex gap-2">
                                                                <c:if test="${sessionScope.currentUser != null && sessionScope.currentUser.id == cmt.userId}">
                                                                    <button class="text-yellow-500 hover:text-yellow-600 bg-yellow-50 hover:bg-yellow-100 w-8 h-8 rounded-full flex items-center justify-center transition-colors" onclick="enableEditMode('${cmt.id}')" id="edit-btn-${cmt.id}" title="Sửa bình luận"><i class="fas fa-pen text-sm"></i></button>
                                                                </c:if>
                                                                <c:if test="${sessionScope.currentUser != null && sessionScope.currentUser.id != cmt.userId}">
                                                                    <button class="text-red-500 hover:text-red-600 bg-red-50 hover:bg-red-100 w-8 h-8 rounded-full flex items-center justify-center transition-colors" onclick="reportComment('${cmt.id}')" title="Báo cáo vi phạm"><i class="fas fa-flag text-sm"></i></button>
                                                                </c:if>
                                                            </div>
                                                        </div>

                                                        <div class="mt-3 text-gray-700 leading-relaxed text-base">
                                                            <div id="content-text-${cmt.id}" class="whitespace-pre-wrap"><c:out value="${cmt.content}" /></div>
                                                            
                                                            <div id="edit-area-${cmt.id}" class="hidden mt-3">
                                                                <textarea id="input-${cmt.id}" class="w-full bg-gray-50 border border-gray-300 rounded-lg p-3 focus:ring-2 focus:ring-primary focus:border-primary outline-none transition-shadow mb-3" rows="3"></textarea>
                                                                <div class="flex gap-2">
                                                                    <button class="bg-primary hover:bg-[#004c6b] text-white px-4 py-2 rounded-lg font-medium transition-colors text-sm" onclick="saveEdit('${cmt.id}')">Lưu</button>
                                                                    <button class="bg-gray-100 hover:bg-gray-200 text-gray-700 px-4 py-2 rounded-lg font-medium transition-colors text-sm border border-gray-300" onclick="cancelEdit('${cmt.id}')">Hủy</button>
                                                                </div>
                                                            </div>
                                                        </div>

                                                        <c:if test="${sessionScope.currentUser != null}">
                                                            <button class="text-[#00A896] hover:text-[#008f7f] font-semibold text-sm mt-3 flex items-center gap-1 transition-colors" onclick="toggleReplyForm('${cmt.id}')">
                                                                <i class="fas fa-reply"></i> Trả lời
                                                            </button>
                                                        </c:if>

                                                        <c:catch var="replyError">
                                                            <c:if test="${not empty cmt.replies}">
                                                                <div class="mt-4 ml-8 pl-4 border-l-2 border-gray-200 space-y-4" id="replies-${cmt.id}">
                                                                    <c:forEach var="rep" items="${cmt.replies}">
                                                                        <div class="flex gap-3 bg-gray-50 rounded-xl p-3">
                                                                            <div class="w-8 h-8 bg-cyan-600 text-white rounded-full flex items-center justify-center font-bold text-sm flex-shrink-0">
                                                                                ${rep.userFullName.substring(0,1).toUpperCase()}
                                                                            </div>
                                                                            <div>
                                                                                <div class="flex items-baseline gap-2">
                                                                                    <span class="font-bold text-gray-900 text-sm">
                                                                                        ${rep.userFullName}
                                                                                        <c:if test="${rep.userId == news.author}">
                                                                                            <span class="inline-flex items-center gap-1 ml-1 px-1.5 py-0.2 rounded text-[10px] font-semibold bg-blue-100 text-blue-800 border border-blue-200">
                                                                                                <i class="fas fa-pen-nib text-[8px]"></i> Tác giả
                                                                                            </span>
                                                                                        </c:if>
                                                                                    </span>
                                                                                    <small class="text-gray-500 text-xs"><fmt:formatDate value="${rep.createdDate}" pattern="dd/MM/yyyy HH:mm" /></small>
                                                                                </div>
                                                                                <p class="mt-1 mb-0 text-gray-700 text-sm whitespace-pre-wrap"><c:out value="${rep.content}" /></p>
                                                                            </div>
                                                                        </div>
                                                                    </c:forEach>
                                                                </div>
                                                            </c:if>
                                                            <c:if test="${empty cmt.replies}">
                                                                <div class="mt-4 ml-8 pl-4 border-l-2 border-gray-200 space-y-4 hidden" id="replies-${cmt.id}"></div>
                                                            </c:if>
                                                        </c:catch>
                                                        <c:if test="${replyError != null}">
                                                            <div class="bg-yellow-50 text-yellow-800 p-3 rounded-lg text-sm mt-3 border border-yellow-200 flex items-start gap-2">
                                                                <i class="fas fa-exclamation-triangle mt-0.5"></i> 
                                                                <span>Mã nguồn Java vừa được cập nhật nhưng Tomcat chưa nhận diện được. <strong>Vui lòng Restart lại Tomcat / Server!</strong></span>
                                                            </div>
                                                        </c:if>

                                                    </div>
                                                </div>

                                                <c:if test="${sessionScope.currentUser != null}">
                                                    <div class="hidden ml-12 mt-3 p-4 bg-gray-50 rounded-xl border border-gray-200" id="reply-form-${cmt.id}">
                                                        <div class="flex gap-3">
                                                            <div class="w-8 h-8 bg-primary text-white rounded-full flex items-center justify-center font-bold text-sm flex-shrink-0">
                                                                ${sessionScope.currentUser.fullname.substring(0,1).toUpperCase()}
                                                            </div>
                                                            <div class="flex-grow">
                                                                <textarea class="w-full bg-white border border-gray-300 rounded-lg p-3 text-sm focus:ring-2 focus:ring-primary focus:border-primary outline-none transition-shadow resize-none" id="reply-input-${cmt.id}" rows="2" placeholder="Trả lời ${cmt.userFullName}..."></textarea>
                                                                <div class="flex gap-2 mt-3">
                                                                    <button class="bg-primary hover:bg-[#004c6b] text-white px-5 py-1.5 rounded-full font-medium transition-colors shadow-sm text-sm flex items-center gap-1.5" onclick="sendReply('${cmt.id}', '${news.id}')">
                                                                        <i class="fas fa-paper-plane"></i> Gửi
                                                                    </button>
                                                                    <button class="bg-white hover:bg-gray-100 text-gray-700 border border-gray-300 px-5 py-1.5 rounded-full font-medium transition-colors text-sm" onclick="toggleReplyForm('${cmt.id}')">
                                                                        Hủy
                                                                    </button>
                                                                </div>
                                                            </div>
                                                        </div>
                                                    </div>
                                                </c:if>
                                            </c:forEach>

                                            <c:if test="${empty commentsList}">
                                                <div class="text-center p-8 text-gray-400 border-2 border-dashed border-gray-200 rounded-xl mt-6 bg-gray-50" id="noCommentPlaceholder">
                                                    <i class="far fa-comment-dots text-5xl mb-4 opacity-50 block"></i>
                                                    <p class="m-0 font-medium">Chưa có bình luận nào. Hãy là người đầu tiên lên tiếng!</p>
                                                </div>
                                            </c:if>
                                        </div>
                                    </div>
                                </div>
                            </article>

                            <!-- Tin liên quan: hiển hàng ngang dưới bình luận -->
                            <c:if test="${not empty relatedNews}">
                                <div class="mt-8">
                                    <h3 class="text-xl font-serif font-bold text-gray-900 mb-5 flex items-center gap-2">
                                        <i class="fas fa-newspaper text-primary"></i> Tin liên quan
                                    </h3>
                                    <div class="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-3 gap-5">
                                        <c:forEach var="relatedNews" items="${relatedNews}">
                                            <a href="${pageContext.request.contextPath}/news?action=detail&id=${relatedNews.id}" class="group block bg-white rounded-xl shadow-sm border border-gray-100 overflow-hidden hover:shadow-md transition-shadow no-underline">
                                                <c:if test="${not empty relatedNews.image}">
                                                    <div class="w-full h-36 overflow-hidden">
                                                        <c:choose>
                                                            <c:when test="${relatedNews.image.startsWith('http')}">
                                                                <img src="${relatedNews.image}" class="w-full h-full object-cover group-hover:scale-105 transition-transform duration-300" alt="${relatedNews.title}">
                                                            </c:when>
                                                            <c:otherwise>
                                                                <img src="${pageContext.request.contextPath}/images/${relatedNews.image}" class="w-full h-full object-cover group-hover:scale-105 transition-transform duration-300" alt="${relatedNews.title}">
                                                            </c:otherwise>
                                                        </c:choose>
                                                    </div>
                                                </c:if>
                                                <div class="p-3">
                                                    <h6 class="text-sm font-bold text-gray-800 group-hover:text-primary transition-colors m-0 line-clamp-2 leading-snug">${relatedNews.title}</h6>
                                                    <span class="text-xs text-gray-400 mt-2 block"><i class="fas fa-calendar-alt mr-1"></i><fmt:formatDate value="${relatedNews.postedDate}" pattern="dd/MM/yyyy" /> | <i class="fas fa-eye mr-1"></i>${relatedNews.viewCount}</span>
                                                </div>
                                            </a>
                                        </c:forEach>
                                    </div>
                                </div>
                            </c:if>
                        </div>

                        <!-- Sidebar: sticky khi cuộn -->
                        <div class="lg:col-span-4">
                            <div class="space-y-6">
                                <!-- Widget: Chuyên mục -->
                                <div class="bg-white rounded-xl shadow-sm border border-gray-100 overflow-hidden">
                                    <div class="bg-primary px-5 py-3">
                                        <h5 class="text-white font-bold text-base m-0 flex items-center gap-2">
                                            <i class="fas fa-list"></i> Chuyên mục
                                        </h5>
                                    </div>
                                    <div class="divide-y divide-gray-100">
                                        <c:forEach var="category" items="${categories}">
                                            <a href="${pageContext.request.contextPath}/news?action=category&id=${category.id}"
                                                class="flex justify-between items-center px-5 py-3 text-gray-700 hover:bg-gray-50 hover:text-primary transition-colors no-underline text-sm font-medium group">
                                                ${category.name}
                                                <i class="fas fa-chevron-right text-xs text-gray-400 group-hover:text-primary transition-colors"></i>
                                            </a>
                                        </c:forEach>
                                    </div>
                                </div>

                                <!-- Widget: Đăng ký nhận tin -->
                                <div class="bg-white rounded-xl shadow-sm border border-gray-100 overflow-hidden">
                                    <div class="bg-primary px-5 py-3">
                                        <h5 class="text-white font-bold text-base m-0 flex items-center gap-2">
                                            <i class="fas fa-envelope"></i> Đăng ký nhận tin
                                        </h5>
                                    </div>
                                    <div class="p-5">
                                        <p class="text-sm text-gray-600 mb-4">Nhận tin tức mới nhất qua email của bạn</p>
                                        <form action="${pageContext.request.contextPath}/newsletter" method="post">
                                            <input type="hidden" name="action" value="subscribe">
                                            <div class="mb-3">
                                                <input type="email" name="email"
                                                    class="w-full border border-gray-300 rounded-lg px-4 py-2.5 text-sm focus:ring-2 focus:ring-primary focus:border-primary outline-none transition-shadow"
                                                    placeholder="Nhập email của bạn" required>
                                            </div>
                                            <button type="submit" class="w-full bg-primary hover:bg-[#004c6b] text-white py-2.5 rounded-lg font-bold transition-colors shadow-sm flex items-center justify-center gap-2">
                                                <i class="fas fa-paper-plane"></i> Đăng ký
                                            </button>
                                        </form>
                                    </div>
                                </div>
                            </div>
                        </div>
                </main>

    <!-- QUẢNG CÁO SIDEBAR PHẢI (Sticky) -->
    <c:if test="${not empty sidebarRightAds}">
        <div class="hidden xl:block w-[160px] flex-shrink-0 pt-8 z-0 ml-6 relative">
            <div class="sticky top-24 flex flex-col gap-4">
                <c:forEach var="ad" items="${sidebarRightAds}">
                    <div class="bg-gray-100 rounded flex flex-col items-center justify-center text-gray-400 border border-gray-200 overflow-hidden relative" style="width: 160px; height: 600px;">
                        <span class="absolute top-1 left-2 text-[10px] text-gray-400 bg-white/80 px-1 rounded shadow-sm z-10">Tài trợ</span>
                        <a href="${ad.targetUrl}" target="_blank" class="block w-full h-full">
                            <img src="${ad.imageUrl}" class="w-full h-full object-cover shadow-md rounded" style="image-rendering: -webkit-optimize-contrast; image-rendering: crisp-edges;" loading="lazy" decoding="async" alt="Ad">
                        </a>
                    </div>
                </c:forEach>
            </div>
        </div>
    </c:if>
</div>

                <jsp:include page="../public/components/footer.jsp" />


                <script>
                    // 1. Thích / Không thích
                    function reactNews(newsId, action) {
                        fetch('${pageContext.request.contextPath}/news/react', {
                            method: 'POST',
                            headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
                            body: 'newsId=' + newsId + '&action=' + action
                        })
                            .then(response => {
                                if (response.status === 401) {
                                    alert("Bạn cần đăng nhập để thực hiện chức năng này!");
                                    window.location.href = '${pageContext.request.contextPath}/login';
                                    return null;
                                }
                                return response.json();
                            })
                            .then(data => {
                                if (data) {
                                    document.getElementById('likeCount').innerText = data.likes;
                                    document.getElementById('dislikeCount').innerText = data.dislikes;
                                }
                            })
                            .catch(error => console.error('Lỗi kết nối Server:', error));
                    }

                    // 2. Thêm Bình luận mới
                    function addComment() {
                        let contentElem = document.getElementById('commentContent');
                        let content = contentElem.value;
                        let newsId = document.getElementById('newsIdInput').value;

                        if (content.trim() === '') {
                            alert("Vui lòng nhập nội dung!"); return;
                        }

                        fetch('${pageContext.request.contextPath}/comment/action', {
                            method: 'POST',
                            headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
                            body: 'action=add&newsId=' + newsId + '&content=' + encodeURIComponent(content)
                        })
                            .then(res => {
                                if (res.status === 401) { window.location.href = '${pageContext.request.contextPath}/login'; return null; }
                                return res.json();
                            })
                            .then(data => {
                                if (data && data.status === 'success') {
                                    contentElem.value = ''; // Xóa chữ trong form

                                    // Ẩn chữ "chưa có bình luận" nếu có
                                    let placeholder = document.getElementById('noCommentPlaceholder');
                                    if (placeholder) placeholder.style.display = 'none';

                                    // Chèn DOM thẳng lên đầu
                                    let newHtml = `
                        <div class="comment-item d-flex gap-3 mb-4 p-3 bg-white border rounded-3 shadow-sm border-start border-primary border-4">
                            <div class="bg-primary text-white rounded-circle d-flex align-items-center justify-content-center fw-bold" style="width: 45px; height: 45px; font-size: 1.2rem;">
                                ` + data.fullname.substring(0, 1).toUpperCase() + `
                            </div>
                            <div class="flex-grow-1">
                                <h6 class="mb-1 fw-bold text-dark">` + data.fullname + ` <span class="badge bg-success ms-2" style="font-size: 0.7em">Vừa xong</span></h6>
                                <p class="mb-0 text-secondary" style="line-height: 1.6; white-space: pre-wrap;">` + data.content + `</p>
                            </div>
                        </div>`;

                                    document.getElementById('commentsContainer').insertAdjacentHTML('afterbegin', newHtml);

                                    // Tăng số lượng bình luận
                                    let countBadge = document.getElementById('totalCommentBadge');
                                    if (countBadge) countBadge.innerText = parseInt(countBadge.innerText) + 1;
                                } else {
                                    alert("Có lỗi xảy ra: " + data.message);
                                }
                            });
                    }

                    // : JavaScript sửa bình luận bằng Ajax ẩn/hiện element
                    function enableEditMode(commentId) {
                        const textDiv = document.getElementById('content-text-' + commentId);
                        const editArea = document.getElementById('edit-area-' + commentId);
                        const textarea = document.getElementById('input-' + commentId);
                        
                        // Đổ nội dung cũ vào textarea
                        textarea.value = textDiv.innerText.trim();
                        
                        // Ẩn chữ, hiện ô sửa
                        textDiv.style.display = 'none';
                        editArea.style.display = 'block';
                        
                        // Ẩn luôn nút Sửa chính để tránh bấm trùng
                        let editBtn = document.getElementById('edit-btn-' + commentId);
                        if (editBtn) editBtn.style.display = 'none';
                    }

                    function cancelEdit(commentId) {
                        document.getElementById('content-text-' + commentId).style.display = 'block';
                        document.getElementById('edit-area-' + commentId).style.display = 'none';
                        let editBtn = document.getElementById('edit-btn-' + commentId);
                        if (editBtn) editBtn.style.display = 'inline-block';
                    }

                    function saveEdit(commentId) {
                        const newContent = document.getElementById('input-' + commentId).value;
                        
                        if(!newContent.trim()) {
                            alert("Nội dung không được để trống!");
                            return;
                        }

                        // : Đảm bảo đường dẫn ContextPath chính xác và tránh bị escape lộn của JSP
                        fetch('${pageContext.request.contextPath}/comment/action?action=update', {
                            method: 'POST',
                            headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
                            body: 'id=' + commentId + '&content=' + encodeURIComponent(newContent)
                        })
                        .then(response => response.json())
                        .then(data => {
                            if (data.status === 'success') {
                                document.getElementById('content-text-' + commentId).innerText = newContent;
                                cancelEdit(commentId); // Thoát chế độ sửa
                            } else {
                                alert('Lỗi từ Server: ' + data.message);
                            }
                        })
                        .catch(err => {
                            console.error(err);
                            alert('Lỗi kết nối Server!');
                        });
                    }

                    // Hàm xử lý Báo cáo
                    function reportComment(id) {
                        if (!confirm("Bạn có chắc chắn muốn báo cáo bình luận này vi phạm tiêu chuẩn cộng đồng?")) return;

                        fetch('${pageContext.request.contextPath}/comment/action', {
                            method: 'POST',
                            headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
                            body: 'action=report&commentId=' + id
                        })
                            .then(res => res.json())
                            .then(data => {
                                if (data.status === 'success') {
                                    alert("Đã gửi báo cáo thành công! Admin sẽ kiểm duyệt bình luận này.");
                                } else {
                                    alert("Có lỗi xảy ra, vui lòng thử lại.");
                                }
                            });
                    }

                    // 6. Hiện / ẩn form trả lời
                    function toggleReplyForm(commentId) {
                        let box = document.getElementById('reply-form-' + commentId);
                        if (box.style.display === 'none' || box.style.display === '') {
                            box.style.display = 'block';
                            document.getElementById('reply-input-' + commentId).focus();
                        } else {
                            box.style.display = 'none';
                        }
                    }

                    // 7. Gửi reply qua AJAX
                    function sendReply(parentId, newsId) {
                        let inputElem = document.getElementById('reply-input-' + parentId);
                        let content = inputElem.value;

                        if (content.trim() === '') { alert("Vui lòng nhập nội dung!"); return; }

                        fetch('${pageContext.request.contextPath}/comment/action', {
                            method: 'POST',
                            headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
                            body: 'action=reply&newsId=' + newsId + '&parentId=' + parentId + '&content=' + encodeURIComponent(content)
                        })
                            .then(res => {
                                if (res.status === 401) { window.location.href = '${pageContext.request.contextPath}/login'; return null; }
                                return res.json();
                            })
                            .then(data => {
                                if (data && data.status === 'success') {
                                    inputElem.value = '';
                                    toggleReplyForm(parentId);

                                    // Hiện khối reply-list và chèn reply mới vào
                                    let replyList = document.getElementById('replies-' + parentId);
                                    replyList.classList.remove('hidden');

                                    let letter = data.fullname.substring(0, 1).toUpperCase();
                                    let isAuthor = data.userId === '${news.author}';
                                    let authorBadgeHtml = isAuthor ?
                                        ` <span class="inline-flex items-center gap-1 ml-1 px-1.5 py-0.2 rounded text-[10px] font-semibold bg-blue-100 text-blue-800 border border-blue-200">
                                            <i class="fas fa-pen-nib text-[8px]"></i> Tác giả
                                          </span>` : '';

                                    let newReplyHtml = `
                                        <div class="flex gap-3 bg-gray-50 rounded-xl p-3">
                                            <div class="w-8 h-8 bg-cyan-600 text-white rounded-full flex items-center justify-center font-bold text-sm flex-shrink-0">
                                                \${letter}
                                            </div>
                                            <div>
                                                <div class="flex items-baseline gap-2">
                                                    <span class="font-bold text-gray-900 text-sm">
                                                        \${data.fullname}\${authorBadgeHtml}
                                                    </span>
                                                    <small class="text-gray-500 text-xs">Vừa xong</small>
                                                </div>
                                                <p class="mt-1 mb-0 text-gray-700 text-sm whitespace-pre-wrap">\${data.content}</p>
                                            </div>
                                        </div>`;

                                    replyList.insertAdjacentHTML('beforeend', newReplyHtml);
                                } else {
                                    alert("Có lỗi xảy ra: " + (data ? data.message : 'Lỗi hệ thống'));
                                }
                            });
                    }
                    function toggleCommentSection() {
                        const commentSection = document.getElementById('comment-section');
                        if (commentSection) {
                            // Sử dụng classList.toggle của Tailwind để bật/tắt class 'hidden'
                            commentSection.classList.toggle('hidden');
                        }
                    }

                    // Trì hoãn 10 giây trước khi tăng View Count (RQ03)
                    setTimeout(function() {
                        fetch('${pageContext.request.contextPath}/news?action=incrementView&id=${news.id}')
                            .then(response => response.json())
                            .then(data => {
                                if (data.status === 'success') {
                                    console.log("Đã tăng lượt xem!");
                                    const viewCountSpan = document.getElementById('viewCountSpan');
                                    if (viewCountSpan) {
                                        viewCountSpan.innerText = parseInt(viewCountSpan.innerText) + 1;
                                    }
                                }
                            })
                            .catch(err => console.error("Lỗi tăng view:", err));
                    }, 10000);

                    // Xử lý theo dõi tác giả (RQ22)
                    function toggleFollow(authorId) {
                        const followBtn = document.getElementById('followBtn');
                        if (!followBtn) return;
                        
                        const isFollowing = followBtn.innerText.trim() === 'Đang theo dõi';
                        const action = isFollowing ? 'unfollow' : 'follow';
                        
                        fetch('${pageContext.request.contextPath}/news?action=' + action + '&authorId=' + authorId, { method: 'POST' })
                            .then(response => {
                                if (response.status === 401) {
                                    alert("Vui lòng đăng nhập để thực hiện chức năng này!");
                                    window.location.href = '${pageContext.request.contextPath}/login';
                                    return null;
                                }
                                return response.json();
                            })
                            .then(data => {
                                if (data && data.status === 'success') {
                                    if (action === 'follow') {
                                        followBtn.innerText = 'Đang theo dõi';
                                        followBtn.className = 'ms-2 px-2.5 py-0.5 rounded text-xs font-bold transition bg-blue-100 text-blue-700 hover:bg-blue-200';
                                    } else {
                                        followBtn.innerText = 'Theo dõi';
                                        followBtn.className = 'ms-2 px-2.5 py-0.5 rounded text-xs font-bold transition bg-blue-600 text-white hover:bg-blue-700';
                                    }
                                } else if (data) {
                                    alert(data.message);
                                }
                            })
                            .catch(err => console.error(err));
                    }

                    // Xử lý lưu bài viết (RQ27)
                    function toggleBookmark(newsId) {
                        const bookmarkBtn = document.getElementById('bookmarkBtn');
                        const bookmarkText = document.getElementById('bookmarkText');
                        if (!bookmarkBtn || !bookmarkText) return;
                        
                        const isBookmarked = bookmarkText.innerText.trim() === 'Đã lưu';
                        const action = isBookmarked ? 'unbookmark' : 'bookmark';
                        
                        fetch('${pageContext.request.contextPath}/news?action=' + action + '&newsId=' + newsId, { method: 'POST' })
                            .then(response => {
                                if (response.status === 401) {
                                    alert("Vui lòng đăng nhập để lưu bài viết!");
                                    window.location.href = '${pageContext.request.contextPath}/login';
                                    return null;
                                }
                                return response.json();
                            })
                            .then(data => {
                                if (data && data.status === 'success') {
                                    const icon = bookmarkBtn.querySelector('i');
                                    if (action === 'bookmark') {
                                        bookmarkText.innerText = 'Đã lưu';
                                        bookmarkBtn.className = 'flex items-center gap-2 px-4 py-2 bg-amber-100 text-amber-600 hover:bg-amber-200 rounded-full font-bold text-sm transition-colors border border-transparent';
                                        icon.className = 'fas fa-bookmark';
                                    } else {
                                        bookmarkText.innerText = 'Lưu bài viết';
                                        bookmarkBtn.className = 'flex items-center gap-2 px-4 py-2 bg-gray-100 text-gray-700 hover:bg-amber-500 hover:text-white rounded-full font-bold text-sm transition-colors border border-transparent';
                                        icon.className = 'far fa-bookmark';
                                    }
                                } else if (data) {
                                    alert(data.message);
                                }
                            })
                            .catch(err => console.error(err));
                    }
                </script>
            </body>

            </html>