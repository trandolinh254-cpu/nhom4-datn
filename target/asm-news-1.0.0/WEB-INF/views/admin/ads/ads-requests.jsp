<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Yêu cầu Quảng cáo - XYZ Admin Premium</title>
    
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Be+Vietnam+Pro:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">

    <style>
        :root { 
            --primary: #006389;
            --text-color: #333333; 
            --text-muted: #6c757d;
        }
        body { 
            font-family: 'Inter', 'Be Vietnam Pro', sans-serif; 
            background: #f8f9fa; 
            color: var(--text-color);
            overflow-x: hidden; 
            min-height: 100vh; 
        }
        .main-content { padding-left: 0; }
        
        .navbar-admin { 
            background: #ffffff; 
            padding: 1rem 2rem; 
            box-shadow: 0 2px 10px rgba(0,0,0,0.05);
            border-bottom: 1px solid #eaeaea; 
            margin-bottom: 2rem; 
        }
        .navbar-admin h4 { font-weight: 700; color: var(--text-color); }
        
        /* FIX: CSS chuẩn cho khối Bảng (Table Card) cao cấp */
        .card { 
            border-radius: 12px; 
            border: none;
            box-shadow: 0 4px 15px rgba(0,0,0,0.03); 
            background: #ffffff;
        }
        .card-header { 
            background: #ffffff;
            border-bottom: 1px solid #f1f5f9; 
            padding: 1.5rem; 
            border-radius: 12px 12px 0 0 !important; 
        }
        .table th {
            font-weight: 600;
            text-transform: uppercase;
            font-size: 0.85rem;
            letter-spacing: 0.5px;
            padding: 15px;
            background: #f8fafc;
            color: #475569;
            border-bottom: 2px solid #e2e8f0;
        }
        .table td { padding: 15px; vertical-align: middle; border-bottom: 1px solid #f1f5f9; }
        .table tbody tr:hover { background-color: #f8fafc; }
        .badge { padding: 0.5em 0.8em; border-radius: 6px; font-weight: 500; }
    </style>
</head>
<body>
    <div class="container-fluid">
        <div class="row">
            <%-- FIX: Nhúng Sidebar và truyền biến activeMenu tương ứng --%>
            <jsp:include page="/WEB-INF/views/admin/components/admin-sidebar.jsp">
                <jsp:param name="activeMenu" value="ads_req_pending" />
            </jsp:include>

            <div class="col-md-9 col-lg-10 ms-auto main-content">
                <nav class="navbar navbar-admin sticky-top">
                    <div class="container-fluid">
                        <h4 class="mb-0 fw-bold">Yêu cầu Booking Quảng Cáo</h4>
                    </div>
                </nav>

                <div class="container-fluid px-4 pb-4">
                    
                    <%-- Alert Messages --%>
                    <c:if test="${not empty successMessage}">
                        <div class="alert alert-success alert-dismissible fade show shadow-sm" role="alert">
                            <i class="fas fa-check-circle me-2"></i> ${successMessage}
                            <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                        </div>
                    </c:if>
                    <c:if test="${not empty errorMessage}">
                        <div class="alert alert-danger alert-dismissible fade show shadow-sm" role="alert">
                            <i class="fas fa-exclamation-circle me-2"></i> ${errorMessage}
                            <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                        </div>
                    </c:if>
                    
                    <%-- ==================== BẢNG 1: ĐƠN CHỜ DUYỆT (PENDING) ==================== --%>
                    <div class="d-flex justify-content-between align-items-center mb-4">
                        <h5 class="fw-bold mb-0 text-dark">
                            <i class="fas fa-clock me-2 text-warning"></i>Đơn chờ duyệt
                            <c:if test="${not empty pendingRequests}">
                                <span class="badge bg-warning text-dark ms-2">${pendingRequests.size()}</span>
                            </c:if>
                        </h5>
                    </div>

                    <div class="card mb-5">
                        <div class="card-body p-0">
                            <div class="table-responsive">
                                <table class="table table-hover mb-0">
                                    <thead>
                                        <tr>
                                            <th class="ps-4">ID</th>
                                            <th>Khách hàng</th>
                                            <th>Gói dịch vụ</th>
                                            <th>Ngày gửi</th>
                                            <th>Trạng thái</th>
                                            <th class="text-end pe-4">Thao tác</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <c:choose>
                                            <c:when test="${empty pendingRequests}">
                                                <tr>
                                                    <td colspan="6" class="text-center py-4 text-muted">Không có yêu cầu nào đang chờ duyệt.</td>
                                                </tr>
                                            </c:when>
                                            <c:otherwise>
                                                <c:forEach var="req" items="${pendingRequests}">
                                                    <tr>
                                                        <td class="ps-4 fw-bold text-muted">#REQ-<fmt:formatNumber value="${req.id}" pattern="000"/></td>
                                                        <td>
                                                            <div class="fw-bold text-dark">${req.contract.contactName}</div>
                                                            <small class="text-muted">${req.contract.email}</small>
                                                        </td>
                                                        <td><span class="badge bg-info text-white">${req.campaignName}</span></td>
                                                        <td><fmt:formatDate value="${req.contract.createdAt}" pattern="dd/MM/yyyy"/></td>
                                                        <td><span class="badge bg-warning text-dark">Chờ duyệt</span></td>
                                                        <td class="text-end pe-4">
                                                            <button class="btn btn-sm btn-success rounded-3" title="Duyệt" data-bs-toggle="modal" data-bs-target="#approveModal${req.id}">
                                                                <i class="fas fa-check"></i>
                                                            </button>
                                                            <form action="${pageContext.request.contextPath}/admin/ads/reject" method="POST" class="d-inline">
                                                                <input type="hidden" name="campaign_id" value="${req.id}">
                                                                <button type="submit" class="btn btn-sm btn-danger rounded-3" title="Từ chối" onclick="return confirm('Bạn có chắc muốn từ chối yêu cầu này?');">
                                                                    <i class="fas fa-times"></i>
                                                                </button>
                                                            </form>

                                                            <!-- Modal Duyệt (Upload ảnh) -->
                                                            <div class="modal fade text-start" id="approveModal${req.id}" tabindex="-1" aria-hidden="true">
                                                                <div class="modal-dialog">
                                                                    <div class="modal-content">
                                                                        <div class="modal-header">
                                                                            <h5 class="modal-title">Duyệt Quảng Cáo #REQ-<fmt:formatNumber value="${req.id}" pattern="000"/></h5>
                                                                            <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                                                                        </div>
                                                                        <form action="${pageContext.request.contextPath}/admin/ads/approve" method="POST" enctype="multipart/form-data">
                                                                            <div class="modal-body">
                                                                                <input type="hidden" name="campaign_id" value="${req.id}">
                                                                                <div class="mb-3">
                                                                                    <label class="form-label fw-bold">Tải lên Banner thay thế (Tùy chọn)</label>
                                                                                    <input type="file" name="ad_image" class="form-control" accept="image/*">
                                                                                    <small class="text-muted">Khách hàng đã tải lên banner. Chỉ chọn file nếu bạn muốn tải lên banner khác.</small>
                                                                                </div>
                                                                            </div>
                                                                            <div class="modal-footer">
                                                                                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Hủy</button>
                                                                                <button type="submit" class="btn btn-success">Xác nhận Duyệt</button>
                                                                            </div>
                                                                        </form>
                                                                    </div>
                                                                </div>
                                                            </div>
                                                        </td>
                                                    </tr>
                                                </c:forEach>
                                            </c:otherwise>
                                        </c:choose>
                                    </tbody>
                                </table>
                            </div>
                        </div>
                    </div>

                    <%-- ==================== BẢNG 2: ĐƠN ĐANG CHẠY (RUNNING) ==================== --%>
                    <div class="d-flex justify-content-between align-items-center mb-4">
                        <h5 class="fw-bold mb-0 text-dark">
                            <i class="fas fa-play-circle me-2 text-success"></i>Quảng cáo đang chạy
                            <c:if test="${not empty runningRequests}">
                                <span class="badge bg-success ms-2">${runningRequests.size()}</span>
                            </c:if>
                        </h5>
                    </div>

                    <div class="card">
                        <div class="card-body p-0">
                            <div class="table-responsive">
                                <table class="table table-hover mb-0">
                                    <thead>
                                        <tr>
                                            <th class="ps-4">ID</th>
                                            <th>Khách hàng</th>
                                            <th>Gói dịch vụ</th>
                                            <th>Vị trí</th>
                                            <th>Trạng thái</th>
                                            <th>Ảnh banner</th>
                                            <th class="text-end pe-4">Thao tác</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <c:choose>
                                            <c:when test="${empty runningRequests}">
                                                <tr>
                                                    <td colspan="7" class="text-center py-4 text-muted">Chưa có quảng cáo nào đang chạy.</td>
                                                </tr>
                                            </c:when>
                                            <c:otherwise>
                                                <c:forEach var="req" items="${runningRequests}">
                                                    <tr>
                                                        <td class="ps-4 fw-bold text-muted">#REQ-<fmt:formatNumber value="${req.id}" pattern="000"/></td>
                                                        <td>
                                                            <div class="fw-bold text-dark">${req.contract.contactName}</div>
                                                            <small class="text-muted">${req.contract.email}</small>
                                                        </td>
                                                        <td><span class="badge bg-info text-white">${req.campaignName}</span></td>
                                                        <td>
                                                            <c:choose>
                                                                <c:when test="${req.positionId == 1}">
                                                                    <span class="badge bg-warning text-dark">Super Masthead</span>
                                                                </c:when>
                                                                <c:when test="${req.positionId == 2}">
                                                                    <span class="badge bg-primary">Top Banner</span>
                                                                </c:when>
                                                                <c:when test="${req.positionId == 3}">
                                                                    <span class="badge bg-info">Medium Rectangle</span>
                                                                </c:when>
                                                                <c:when test="${req.positionId == 4}">
                                                                    <span class="badge bg-secondary">Sidebar Left</span>
                                                                </c:when>
                                                                <c:when test="${req.positionId == 5}">
                                                                    <span class="badge bg-secondary">Sidebar Right</span>
                                                                </c:when>
                                                                <c:otherwise>
                                                                    <span class="badge bg-dark">Vị trí #${req.positionId}</span>
                                                                </c:otherwise>
                                                            </c:choose>
                                                        </td>
                                                        <td><span class="badge bg-success"><i class="fas fa-circle me-1" style="font-size:8px"></i>Đang chạy</span></td>
                                                        <td>
                                                            <c:if test="${not empty req.imageUrl}">
                                                                <img src="${req.imageUrl}" alt="Banner" style="max-width:120px; max-height:60px; object-fit:cover; border-radius:4px; border:1px solid #e2e8f0;">
                                                            </c:if>
                                                        </td>
                                                        <td class="text-end pe-4">
                                                            <form action="${pageContext.request.contextPath}/admin/ads/stop" method="POST" class="d-inline">
                                                                <input type="hidden" name="campaign_id" value="${req.id}">
                                                                <button type="submit" class="btn btn-sm btn-outline-danger rounded-3" title="Dừng quảng cáo" onclick="return confirm('Bạn có chắc muốn dừng quảng cáo này? Nó sẽ bị gỡ khỏi trang chủ.');">
                                                                    <i class="fas fa-stop me-1"></i>Dừng
                                                                </button>
                                                            </form>
                                                        </td>
                                                    </tr>
                                                </c:forEach>
                                            </c:otherwise>
                                        </c:choose>
                                    </tbody>
                                </table>
                            </div>
                        </div>
                    </div>

                </div>
            </div>
        </div>
    </div>
    
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>