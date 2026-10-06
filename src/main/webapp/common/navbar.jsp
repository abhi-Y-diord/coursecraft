<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<header class="app-topbar d-flex align-items-center justify-content-between px-3">
    <div class="d-flex align-items-center gap-3">
        <a href="${pageContext.request.contextPath}/" class="app-brand">
            CourseCraft
        </a>
    </div>

    <c:if test="${not empty sessionScope.user}">
        <div class="d-flex align-items-center gap-3">
            <form action="${pageContext.request.contextPath}/student/catalog" method="get" class="d-none d-md-block">
                <div class="input-group input-group-sm" style="width: 220px;">
                    <input type="text" name="q" class="form-control" placeholder="Search courses..." value="${param.q}">
                    <button class="btn btn-outline-secondary" type="submit" aria-label="Search"><i class="bi bi-search"></i></button>
                </div>
            </form>

            <div class="dropdown">
                <a href="#" class="d-flex align-items-center text-decoration-none dropdown-toggle text-dark" data-bs-toggle="dropdown" aria-expanded="false">
                    <div class="text-end me-2">
                        <div class="fw-semibold text-dark" style="font-size: 14px;"><c:out value="${sessionScope.user.name}" /></div>
                        <div class="text-muted small" style="font-size: 11px;"><c:out value="${sessionScope.user.role}" /></div>
                    </div>
                </a>
                <ul class="dropdown-menu dropdown-menu-end">
                    <li><a class="dropdown-menu-item dropdown-item" href="${pageContext.request.contextPath}/profile"><i class="bi bi-person me-2"></i>Profile & Password</a></li>
                    <li><hr class="dropdown-divider"></li>
                    <li><a class="dropdown-menu-item dropdown-item text-danger" href="${pageContext.request.contextPath}/logout"><i class="bi bi-box-arrow-right me-2"></i>Sign out</a></li>
                </ul>
            </div>
        </div>
    </c:if>
    <c:if test="${empty sessionScope.user}">
        <div class="d-flex gap-2">
            <a href="${pageContext.request.contextPath}/login" class="btn btn-sm btn-outline-secondary">Sign in</a>
            <a href="${pageContext.request.contextPath}/register" class="btn btn-sm btn-primary">Register</a>
        </div>
    </c:if>
</header>
