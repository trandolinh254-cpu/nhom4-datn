<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Vị trí Quảng cáo Online - XYZ Admin Premium</title>

    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Be+Vietnam+Pro:wght@300;400;500;600;700&display=swap" rel="stylesheet">

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

        .main-content {
            padding-left: 0;
        }

        .navbar-admin {
            background: #ffffff;
            padding: 1rem 2rem;
            box-shadow: 0 2px 10px rgba(0,0,0,0.05);
            margin-bottom: 2rem;
            border-bottom: 1px solid #eaeaea;
        }

        .navbar-admin h4 {
            color: var(--text-color);
            font-weight: 700;
            font-size: 1.5rem;
        }

        .user-profile-badge {
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

        .user-profile-badge i {
            color: var(--primary);
            font-size: 1.2rem;
        }

        .card {
            border: 1px solid #eaeaea;
            border-radius: 12px;
            background: #ffffff;
            box-shadow: 0 2px 10px rgba(0,0,0,0.05);
        }

        .card-header {
            background: #ffffff;
            border-bottom: 1px solid #eaeaea;
            padding: 1.5rem;
            border-radius: 12px 12px 0 0 !important;
        }
    </style>
    <jsp:include page="/WEB-INF/views/components/dark-mode.jsp" />
</head>
<body>
    <div class="container-fluid">
        <div class="row">
            <%-- Nhúng Sidebar --%>
            <jsp:include page="/WEB-INF/views/admin/components/admin-sidebar.jsp">
                <jsp:param name="activeMenu" value="ads_online_positions" />
            </jsp:include>

            <div class="col-md-9 col-lg-10 ms-auto main-content">
                <nav class="navbar navbar-expand-lg navbar-admin sticky-top">
                    <div class="container-fluid">
                        <h4 class="mb-0 fw-bold">Vị trí Quảng cáo (Báo Online)</h4>
                        <div class="navbar-nav ms-auto">
                            <span class="user-profile-badge">
                                <i class="fas fa-user-circle"></i>
                                Xin chào, ${sessionScope.currentUser.fullname}
                            </span>
                        </div>
                    </div>
                </nav>

                <div class="container-fluid px-4 pb-4">
                    
                    <%-- Hiển thị thông báo (nếu có) --%>
                    <c:if test="${not empty sessionScope.successMessage}">
                        <div class="alert alert-success alert-dismissible fade show shadow-sm" role="alert">
                            <i class="fas fa-check-circle me-2"></i>${sessionScope.successMessage}
                            <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                        </div>
                        <c:remove var="successMessage" scope="session"/>
                    </c:if>
                    <c:if test="${not empty sessionScope.errorMessage}">
                        <div class="alert alert-danger alert-dismissible fade show shadow-sm" role="alert">
                            <i class="fas fa-exclamation-triangle me-2"></i>${sessionScope.errorMessage}
                            <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                        </div>
                        <c:remove var="errorMessage" scope="session"/>
                    </c:if>

                    <div class="card">
                        <div class="card-header d-flex justify-content-between align-items-center">
                            <h5 class="mb-0 fw-bold text-primary"><i class="fas fa-list me-2"></i> Danh sách Vị trí hiển thị</h5>
                            <button class="btn btn-primary" data-bs-toggle="modal" data-bs-target="#addPositionModal"><i class="fas fa-plus"></i> Thêm vị trí mới</button>
                        </div>
                        <div class="card-body p-0">
                        <table class="table table-hover align-middle mb-0">
                            <thead class="bg-light">
                                <tr>
                                    <th>ID</th>
                                    <th>Tên Vị Trí</th>
                                    <th>Kích thước chuẩn</th>
                                    <th>Giá gốc (VNĐ)</th>
                                    <th>Trạng thái</th>
                                    <th>Hành động</th>
                                </tr>
                            </thead>
                            <tbody>
                                <%-- Vòng lặp in dữ liệu từ Database ra --%>
                                <c:forEach var="pos" items="${positions}">
                                    <tr>
                                        <td>${pos.id}</td>
                                        <td class="fw-bold">${pos.name}</td>
                                        <td>${pos.sizeDesc}</td>
                                        <td class="text-danger fw-bold">
                                            <fmt:formatNumber value="${pos.basePrice}" type="number" pattern="#,###"/> đ
                                        </td>
                                        <td>
                                            <span class="badge ${pos.status == 'ACTIVE' ? 'bg-success' : 'bg-secondary'}">${pos.status}</span>
                                        </td>
                                        <td>
                                            <button class="btn btn-sm btn-outline-primary" data-bs-toggle="modal" data-bs-target="#editPositionModal${pos.id}"><i class="fas fa-edit"></i> Sửa</button>
                                            
                                            <!-- Modal Sửa Vị trí -->
                                            <div class="modal fade" id="editPositionModal${pos.id}" tabindex="-1" aria-hidden="true">
                                                <div class="modal-dialog">
                                                    <div class="modal-content">
                                                        <div class="modal-header bg-light">
                                                            <h5 class="modal-title fw-bold">Sửa Vị trí Quảng cáo (ID: ${pos.id})</h5>
                                                            <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                                                        </div>
                                                        <form action="${pageContext.request.contextPath}/admin/ads/online/positions/edit" method="post">
                                                            <div class="modal-body">
                                                                <input type="hidden" name="id" value="${pos.id}">
                                                                <div class="mb-3">
                                                                    <label class="form-label">Tên vị trí (Cố định)</label>
                                                                    <input type="text" class="form-control" name="name" value="${pos.name}" readonly>
                                                                </div>
                                                                <div class="mb-3">
                                                                    <label class="form-label">Kích thước chuẩn</label>
                                                                    <input type="text" class="form-control" name="size_desc" value="${pos.sizeDesc}" required>
                                                                </div>
                                                                <div class="mb-3">
                                                                    <label class="form-label">Giá gốc (VNĐ)</label>
                                                                    <input type="number" class="form-control" name="base_price" value="<fmt:formatNumber value="${pos.basePrice}" pattern="0" groupingUsed="false"/>" required>
                                                                </div>
                                                                <div class="mb-3">
                                                                    <label class="form-label">Trạng thái</label>
                                                                    <select class="form-select" name="status">
                                                                        <option value="ACTIVE" ${pos.status == 'ACTIVE' ? 'selected' : ''}>Hoạt động</option>
                                                                        <option value="INACTIVE" ${pos.status == 'INACTIVE' ? 'selected' : ''}>Tạm dừng</option>
                                                                    </select>
                                                                </div>
                                                            </div>
                                                            <div class="modal-footer">
                                                                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Đóng</button>
                                                                <button type="submit" class="btn btn-primary">Lưu thay đổi</button>
                                                            </div>
                                                        </form>
                                                    </div>
                                                </div>
                                            </div>
                                        </td>
                                    </tr>
                                </c:forEach>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- Modal Thêm Vị trí Mới -->
    <div class="modal fade" id="addPositionModal" tabindex="-1" aria-hidden="true">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header bg-light">
                    <h5 class="modal-title fw-bold">Thêm Vị trí Quảng cáo Mới</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <form action="${pageContext.request.contextPath}/admin/ads/online/positions/add" method="post">
                    <div class="modal-body">
                        <c:choose>
                            <c:when test="${not empty availablePositions}">
                                <div class="mb-3">
                                    <label class="form-label text-danger">Chọn vị trí (Chỉ hiển thị vị trí chưa được thêm)</label>
                                    <select class="form-select" name="id" id="newPosSelect" required onchange="updateNewPosName()">
                                        <option value="">-- Chọn vị trí --</option>
                                        <c:forEach var="entry" items="${availablePositions}">
                                            <option value="${entry.key}" data-name="${entry.value}">${entry.key} - ${entry.value}</option>
                                        </c:forEach>
                                    </select>
                                    <input type="hidden" name="name" id="newPosName">
                                    
                                    <!-- KHU VỰC HIỂN THỊ DEMO MINI -->
                                    <div id="miniDemoBox" class="mt-3 p-3 bg-light border rounded text-center" style="display:none; height: 180px; position: relative;">
                                        <div style="width: 100%; height: 20px; background: #ddd; margin-bottom: 5px;">Header</div>
                                        <div id="demo_1" class="fw-bold bg-warning text-dark border border-warning" style="display:none; width: 100%; height: 30px; line-height: 30px; font-size: 10px; margin-bottom: 5px;">SUPER MASTHEAD</div>
                                        <div id="demo_2" class="fw-bold bg-primary text-white border border-primary" style="display:none; width: 80%; height: 20px; line-height: 20px; font-size: 10px; margin: 0 auto 5px;">TOP BANNER</div>
                                        <div class="d-flex justify-content-center" style="height: 80px; gap: 10px;">
                                            <div id="demo_4" class="fw-bold bg-info text-dark border border-info d-flex align-items-center justify-content-center" style="display:none !important; width: 25px; font-size: 9px; writing-mode: vertical-rl;">LEFT</div>
                                            <div style="width: 120px; background: #eee; font-size: 10px; padding-top: 20px; color: #999;">Nội dung tin tức</div>
                                            <div id="demo_5" class="fw-bold bg-info text-dark border border-info d-flex align-items-center justify-content-center" style="display:none !important; width: 25px; font-size: 9px; writing-mode: vertical-rl;">RIGHT</div>
                                        </div>
                                    </div>
                                    <!-- KẾT THÚC DEMO -->
                                </div>
                                <div class="mb-3">
                                    <label class="form-label">Kích thước chuẩn (VD: 1120 x 90 px)</label>
                                    <input type="text" class="form-control" name="size_desc" required>
                                </div>
                                <div class="mb-3">
                                    <label class="form-label">Giá gốc (VNĐ)</label>
                                    <input type="number" class="form-control" name="base_price" required>
                                </div>
                                <div class="mb-3">
                                    <label class="form-label">Trạng thái</label>
                                    <select class="form-select" name="status">
                                        <option value="ACTIVE">Hoạt động</option>
                                        <option value="INACTIVE">Tạm dừng</option>
                                    </select>
                                </div>
                            </c:when>
                            <c:otherwise>
                                <div class="alert alert-success text-center">
                                    <i class="fas fa-check-circle fa-2x mb-2"></i><br>
                                    Tất cả các vị trí quảng cáo có sẵn đã được cấu hình!
                                </div>
                            </c:otherwise>
                        </c:choose>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Đóng</button>
                        <c:if test="${not empty availablePositions}">
                            <button type="submit" class="btn btn-primary">Lưu vị trí</button>
                        </c:if>
                    </div>
                </form>
            </div>
        </div>
    </div>
    
    <script>
        function updateNewPosName() {
            var select = document.getElementById("newPosSelect");
            var nameInput = document.getElementById("newPosName");
            var demoBox = document.getElementById("miniDemoBox");
            
            // Reset demos
            document.getElementById("demo_1").style.display = "none";
            document.getElementById("demo_2").style.display = "none";
            document.getElementById("demo_4").style.setProperty("display", "none", "important");
            document.getElementById("demo_5").style.setProperty("display", "none", "important");
            
            if (select.selectedIndex > 0) {
                var selectedOption = select.options[select.selectedIndex];
                var selectedName = selectedOption.getAttribute("data-name");
                nameInput.value = selectedName;
                
                demoBox.style.display = "block";
                var n = selectedName.toLowerCase();
                
                if(n.includes('masthead')) document.getElementById("demo_1").style.display = "block";
                else if(n.includes('top')) document.getElementById("demo_2").style.display = "block";
                else if(n.includes('left') || n.includes('trái')) document.getElementById("demo_4").style.setProperty("display", "flex", "important");
                else if(n.includes('right') || n.includes('phải')) document.getElementById("demo_5").style.setProperty("display", "flex", "important");
                
            } else {
                nameInput.value = "";
                demoBox.style.display = "none";
            }
        }
    </script>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>