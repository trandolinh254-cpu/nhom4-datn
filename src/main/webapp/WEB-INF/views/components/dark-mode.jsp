<%-- ===== CSS cho Dark Mode toàn trang ===== --%>
<style>
    /* Ghi đè CSS Variables ở các file chi tiết */
    html.dark {
        --text-color: #e0e0e0 !important;
        --text-muted: #b0b0b0 !important;
        --background-content: #1a1a2e !important;
        --navy: #0f172a !important;
        --navy-light: #1e293b !important;
        
        /* Ghi đè biến của Bootstrap */
        --bs-body-bg: #1a1a2e !important;
        --bs-body-color: #e0e0e0 !important;
        --bs-table-bg: transparent !important;
        --bs-table-color: #e0e0e0 !important;
        --bs-table-border-color: #2a2a4a !important;
        --bs-table-hover-bg: #2a3a5a !important;
        --bs-table-striped-bg: #1e2a4a !important;
    }
    
    /* Dark Mode - áp dụng khi html có class "dark" */
    html.dark body, html.dark main, html.dark .container {
        background-color: #1a1a2e !important;
        color: #e0e0e0 !important;
    }
    html.dark .bg-white, html.dark .bg-gray-100, html.dark .bg-gray-50, html.dark .bg-light, html.dark .sidebar-widget,
    html.dark .login-card, html.dark .login-header, html.dark .auth-card, html.dark .auth-header,
    html.dark .sidebar, html.dark #sidebar, html.dark .stat-card, html.dark .modal-content, html.dark .modal-header, html.dark .modal-footer {
        background-color: #16213e !important;
        border-color: #2a2a4a !important;
        color: #e0e0e0 !important;
    }
    html.dark .text-gray-800, html.dark .text-gray-900, html.dark .text-gray-700, html.dark .text-dark,
    html.dark h1, html.dark h2, html.dark h3, html.dark h4, html.dark h5, html.dark h6, 
    html.dark .card-title, html.dark .widget-title, html.dark .news-title {
        color: #e0e0e0 !important;
    }
    html.dark .text-gray-600, html.dark .text-gray-500, html.dark .text-muted {
        color: #b0b0b0 !important;
    }
    html.dark .border-gray-200, html.dark .border-gray-100, html.dark .border-gray-300, html.dark .border {
        border-color: #2a2a4a !important;
    }
    html.dark a:not(.btn):not(.badge):not(.nav-link) {
        color: #93c5fd;
    }
    html.dark a:hover:not(.btn):not(.nav-link) {
        color: #60a5fa !important;
    }
    /* Card, article bg */
    html.dark article, html.dark .card, html.dark .profile-card, html.dark .sidebar-widget {
        background-color: #1e2a4a !important;
        border-color: #2a2a4a !important;
    }
    /* Header & Footer */
    html.dark .top-bar-dark, html.dark .navbar {
        background-color: #0f172a !important;
        border-color: #1e293b !important;
    }
    html.dark .header-dark {
        background-color: #16213e !important;
        box-shadow: 0 1px 6px rgba(0,0,0,0.4) !important;
    }
    html.dark .nav-bar-dark {
        background-color: #16213e !important;
        border-color: #2a2a4a !important;
    }
    html.dark .dropdown-dark, html.dark .dropdown-menu {
        background-color: #1e2a4a !important;
        border-color: #2a2a4a !important;
    }
    html.dark .dropdown-dark a, html.dark .dropdown-item {
        color: #e0e0e0 !important;
    }
    html.dark .dropdown-dark a:hover, html.dark .dropdown-item:hover {
        background-color: #2a3a5a !important;
        color: #60a5fa !important;
    }
    /* Footer dark */
    html.dark footer {
        background-color: #0f172a !important;
        border-color: #1e293b !important;
    }
    /* Ảnh: giữ nguyên, thêm bo góc mềm */
    html.dark img {
        opacity: 0.92;
        border-radius: inherit;
    }
    /* Input/search dark */
    html.dark input[type="text"], html.dark input[type="search"], html.dark input[type="email"], html.dark input[type="password"], html.dark textarea, html.dark select, html.dark .form-control {
        background-color: #1e2a4a !important;
        border-color: #2a2a4a !important;
        color: #e0e0e0 !important;
    }
    /* Table dark cho admin */
    html.dark table {
        color: #e0e0e0 !important;
    }
    html.dark thead {
        background-color: #0f172a !important;
        color: #93c5fd !important;
    }
    html.dark tbody tr {
        border-bottom-color: #2a2a4a !important;
    }
    html.dark tbody tr:hover {
        background-color: #2a3a5a !important;
    }
    /* Section title */
    html.dark .section-title {
        color: #60a5fa !important;
    }
    /* Badge */
    html.dark .badge {
        opacity: 0.9;
    }
    /* Transition toàn trang mượt */
    body, header, footer, article, .card, nav, a, input, img, table, tr, th, td {
        transition: background-color 0.3s ease, color 0.3s ease, border-color 0.3s ease, opacity 0.3s ease;
    }
</style>

<%-- Script khôi phục theme khi chuyển trang --%>
<script>
    (function restoreTheme() {
        var saved = localStorage.getItem('xyz_theme');
        if (saved === 'dark') {
            document.documentElement.classList.add('dark');
            // Cập nhật icon trên trang nếu có nút toggle
            window.addEventListener('DOMContentLoaded', function() {
                var icon = document.getElementById('darkIcon');
                if (icon) icon.className = 'fas fa-sun text-yellow-400';
            });
        }
    })();
</script>
