<%-- Khai báo chuẩn JSP cho dự án Java Web --%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<!DOCTYPE html>
<html lang="vi">
<head>
<meta charset="utf-8"/>
<meta content="width=device-width, initial-scale=1.0" name="viewport"/>
<title>XYZ Premium AI</title> <!-- // FIX -->
<script src="https://cdn.tailwindcss.com?plugins=forms,container-queries"></script>
<link href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:wght,FILL@100..700,0..1&display=swap" rel="stylesheet"/>
<link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;700&family=Merriweather:ital,wght@0,400;0,700;1,400&display=swap" rel="stylesheet"/>
<link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css" rel="stylesheet">
<script id="tailwind-config">
        tailwind.config = {
            darkMode: "class",
            theme: {
                extend: {
                    "colors": {
                        "on-surface-variant": "#3e484f",
                        "on-tertiary": "#ffffff",
                        "on-secondary": "#ffffff",
                        "secondary": "#5f5e5e",
                        "on-secondary-container": "#656464",
                        "on-background": "#1a1c1c",
                        "secondary-container": "#e4e2e1",
                        "on-primary-fixed-variant": "#004c6b",
                        "surface-container-low": "#f3f3f3",
                        "outline-variant": "#bec8d1",
                        "outline": "#6e7880",
                        "on-primary-fixed": "#001e2d",
                        "on-tertiary-fixed": "#1b1c1c",
                        "surface-variant": "#e2e2e2",
                        "inverse-surface": "#2f3131",
                        "secondary-fixed-dim": "#c8c6c5",
                        "surface-container-highest": "#e2e2e2",
                        "on-error": "#ffffff",
                        "urgent-red": "#E11D48",
                        "on-error-container": "#93000a",
                        "surface-bright": "#f9f9f9",
                        "primary-container": "#007dac",
                        "tertiary-container": "#747475",
                        "primary": "#006389",
                        "surface-tint": "#00658d",
                        "error-container": "#ffdad6",
                        "primary-fixed": "#c6e7ff",
                        "background": "#f9f9f9",
                        "on-secondary-fixed-variant": "#474746",
                        "error": "#ba1a1a",
                        "on-tertiary-fixed-variant": "#464747",
                        "inverse-primary": "#81cfff",
                        "surface-dim": "#dadada",
                        "border-subtle": "#E5E5E5",
                        "tertiary-fixed": "#e3e2e2",
                        "on-tertiary-container": "#fefcfc",
                        "pure-white": "#FFFFFF",
                        "on-surface": "#1a1c1c",
                        "on-secondary-fixed": "#1b1c1c",
                        "on-primary-container": "#fcfcff",
                        "surface-container-high": "#e8e8e8",
                        "secondary-fixed": "#e4e2e1",
                        "surface-container-lowest": "#ffffff",
                        "on-primary": "#ffffff",
                        "surface-container": "#eeeeee",
                        "surface": "#f9f9f9",
                        "tertiary": "#5b5c5c",
                        "tertiary-fixed-dim": "#c7c6c6",
                        "primary-fixed-dim": "#81cfff",
                        "inverse-on-surface": "#f1f1f1"
                    },
                    "borderRadius": {
                        "DEFAULT": "0.125rem",
                        "lg": "0.25rem",
                        "xl": "0.5rem",
                        "full": "0.75rem"
                    },
                    "spacing": {
                        "stack-sm": "8px",
                        "gutter": "24px",
                        "section-gap": "48px",
                        "stack-md": "16px",
                        "container-max": "1200px",
                        "margin-mobile": "16px"
                    },
                    "fontFamily": {
                        "body-lg": ["Inter"],
                        "body-md": ["Inter"],
                        "meta-sm": ["Inter"],
                        "headline-md": ["Merriweather"],
                        "display-lg-mobile": ["Merriweather"],
                        "label-caps": ["Inter"],
                        "headline-sm": ["Merriweather"],
                        "display-lg": ["Merriweather"]
                    },
                    "fontSize": {
                        "body-lg": ["18px", { "lineHeight": "30px", "fontWeight": "400" }],
                        "body-md": ["16px", { "lineHeight": "26px", "fontWeight": "400" }],
                        "meta-sm": ["13px", { "lineHeight": "18px", "fontWeight": "400" }],
                        "headline-md": ["24px", { "lineHeight": "32px", "fontWeight": "700" }],
                        "display-lg-mobile": ["32px", { "lineHeight": "40px", "fontWeight": "700" }],
                        "label-caps": ["12px", { "lineHeight": "16px", "letterSpacing": "0.05em", "fontWeight": "700" }],
                        "headline-sm": ["20px", { "lineHeight": "28px", "fontWeight": "700" }],
                        "display-lg": ["40px", { "lineHeight": "52px", "letterSpacing": "-0.02em", "fontWeight": "700" }]
                    }
                }
            }
        }
    </script>
<style>
        .material-symbols-outlined {
            font-variation-settings: 'FILL' 0, 'wght' 400, 'GRAD' 0, 'opsz' 24;
        }
        .icon-fill {
            font-variation-settings: 'FILL' 1;
        }
    </style>
</head>
<body class="bg-surface text-on-surface font-body-md antialiased flex flex-col min-h-screen">
<jsp:include page="../public/components/header.jsp" />

<main class="flex-grow">
<section class="bg-pure-white border-b border-border-subtle py-section-gap md:py-[80px]">
<div class="max-w-container-max mx-auto px-gutter grid grid-cols-1 md:grid-cols-2 gap-section-gap items-center">
<div>
<div class="inline-block bg-primary-container text-on-primary-container font-label-caps text-label-caps px-2 py-1 rounded-sm mb-stack-md uppercase">Độc quyền</div>
<h1 class="font-display-lg text-display-lg md:text-[56px] md:leading-[64px] text-on-surface mb-stack-md">XYZ Premium — Trải nghiệm dịch vụ AI đẳng cấp</h1> <!-- // FIX -->
<p class="font-body-lg text-body-lg text-on-surface-variant mb-stack-md">Không giới hạn lượt sử dụng trợ lý ảo AI, dịch thuật đa ngôn ngữ và tóm tắt bài viết tự động.</p> <!-- // FIX -->
<button class="bg-primary text-on-primary font-label-caps text-label-caps px-8 py-4 rounded uppercase hover:bg-surface-tint transition-colors shadow-sm">Đăng ký ngay</button>
</div>
<div class="relative w-full aspect-[4/3] rounded overflow-hidden">
<img alt="News reading experience" class="object-cover w-full h-full" src="https://images.unsplash.com/photo-1585829365295-ab7cd400c167?ixlib=rb-4.0.3&auto=format&fit=crop&w=800&q=80"/>
<div class="absolute inset-0 ring-1 ring-inset ring-outline-variant rounded"></div>
</div>
</div>
</section>

<section class="py-section-gap bg-surface">
<div class="max-w-container-max mx-auto px-gutter">
<div class="text-center mb-section-gap">
<h2 class="font-headline-md text-headline-md text-on-surface">Đặc quyền Premium AI</h2> <!-- // FIX -->
</div>
<div class="grid grid-cols-1 md:grid-cols-3 gap-gutter">
<div class="bg-pure-white p-6 border border-border-subtle rounded flex flex-col items-start">
<div class="w-12 h-12 rounded bg-surface-container-low flex items-center justify-center text-primary mb-stack-md">
<span class="material-symbols-outlined icon-fill">smart_toy</span> <!-- // FIX -->
</div>
<h3 class="font-headline-sm text-headline-sm text-on-surface mb-stack-sm">Trợ lý ảo AI Chat</h3> <!-- // FIX -->
<p class="font-body-md text-body-md text-on-surface-variant">Trò chuyện, giải đáp thắc mắc và hỗ trợ viết lách thông minh 24/7.</p> <!-- // FIX -->
</div>
<div class="bg-pure-white p-6 border border-border-subtle rounded flex flex-col items-start">
<div class="w-12 h-12 rounded bg-surface-container-low flex items-center justify-center text-primary mb-stack-md">
<span class="material-symbols-outlined icon-fill">translate</span> <!-- // FIX -->
</div>
<h3 class="font-headline-sm text-headline-sm text-on-surface mb-stack-sm">Dịch thuật AI</h3> <!-- // FIX -->
<p class="font-body-md text-body-md text-on-surface-variant">Dịch thuật bài viết chuẩn xác sang nhiều ngôn ngữ khác nhau ngay lập tức.</p> <!-- // FIX -->
</div>
<div class="bg-pure-white p-6 border border-border-subtle rounded flex flex-col items-start">
<div class="w-12 h-12 rounded bg-surface-container-low flex items-center justify-center text-primary mb-stack-md">
<span class="material-symbols-outlined icon-fill">description</span> <!-- // FIX -->
</div>
<h3 class="font-headline-sm text-headline-sm text-on-surface mb-stack-sm">Tóm tắt tự động</h3> <!-- // FIX -->
<p class="font-body-md text-body-md text-on-surface-variant">Tóm tắt nhanh nội dung bài viết dài chỉ trong vài giây bằng trí tuệ nhân tạo.</p> <!-- // FIX -->
</div>
</div>
</div>
</section>

<section class="py-section-gap bg-pure-white border-y border-border-subtle">
<div class="max-w-container-max mx-auto px-gutter">
<div class="text-center mb-section-gap">
<h2 class="font-headline-md text-headline-md text-on-surface">Chọn gói phù hợp với bạn</h2>
</div>

<div class="max-w-md mx-auto"> <!-- // FIX -->
    <%-- FIX: Chỉ hiển thị duy nhất Gói Premium Trọn Đời --%>
    <div class="bg-primary text-on-primary p-8 border border-primary rounded-xl flex flex-col relative shadow-xl text-center"> <!-- // FIX -->
        <div class="absolute top-0 right-0 bg-urgent-red text-on-error font-label-caps text-label-caps px-4 py-1.5 rounded-bl rounded-tr-xl uppercase text-[10px] tracking-wider">Ưu đãi trọn đời</div> <!-- // FIX -->
        <h3 class="font-headline-sm text-headline-sm text-on-primary mb-3">Gói Premium Trọn Đời</h3> <!-- // FIX -->
        <div class="mb-5"> <!-- // FIX -->
            <span class="font-display-lg text-display-lg text-on-primary text-5xl">990.000đ</span> <!-- // FIX -->
            <span class="font-body-md text-body-md text-on-primary/80 block mt-1">Sở hữu vĩnh viễn</span> <!-- // FIX -->
        </div> <!-- // FIX -->
        <p class="font-body-md text-body-md text-on-primary/95 mb-6">Trải nghiệm không giới hạn trợ lý ảo AI Chat, dịch thuật đa ngôn ngữ và tóm tắt tự động trọn đời. Chỉ thanh toán một lần duy nhất.</p> <!-- // FIX -->
        <a href="${pageContext.request.contextPath}/order?type=digital&duration=lifetime" class="text-center block w-full bg-pure-white text-primary font-label-caps text-label-caps px-6 py-4 rounded-lg uppercase hover:bg-surface-tint hover:text-pure-white transition-all font-bold shadow-md">Đăng ký ngay</a> <!-- // FIX -->
    </div> <!-- // FIX -->
</div> <!-- // FIX -->
</div>
</section>
</main>
<jsp:include page="../public/components/footer.jsp" />
</body>
</html>