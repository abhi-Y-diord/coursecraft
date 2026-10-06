<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<c:if test="${not empty sessionScope.user}">
    <aside class="app-sidebar">
        <c:choose>
            <c:when test="${sessionScope.user.role == 'ADMIN'}">
                <div class="nav-section-label">ADMINISTRATION</div>
                <nav class="nav flex-column gap-1">
                    <a class="nav-link ${activeNav == 'dashboard' ? 'active' : ''}" href="${pageContext.request.contextPath}/admin/dashboard">
                        <i class="bi bi-house"></i> Dashboard
                    </a>
                    <a class="nav-link ${activeNav == 'faculty' ? 'active' : ''}" href="${pageContext.request.contextPath}/admin/faculty">
                        <i class="bi bi-person-badge"></i> Faculty Accounts
                    </a>
                    <a class="nav-link ${activeNav == 'students' ? 'active' : ''}" href="${pageContext.request.contextPath}/admin/students">
                        <i class="bi bi-people"></i> Student Accounts
                    </a>
                    <a class="nav-link ${activeNav == 'courses' ? 'active' : ''}" href="${pageContext.request.contextPath}/admin/courses">
                        <i class="bi bi-journal-text"></i> Course Management
                    </a>
                    <a class="nav-link ${activeNav == 'enrollments' ? 'active' : ''}" href="${pageContext.request.contextPath}/admin/enrollments">
                        <i class="bi bi-card-checklist"></i> All Enrollments
                    </a>
                    <a class="nav-link ${activeNav == 'announcements' ? 'active' : ''}" href="${pageContext.request.contextPath}/admin/announcements">
                        <i class="bi bi-megaphone"></i> Announcements
                    </a>
                    <a class="nav-link ${activeNav == 'reports' ? 'active' : ''}" href="${pageContext.request.contextPath}/admin/reports">
                        <i class="bi bi-bar-chart"></i> Reports
                    </a>
                </nav>
            </c:when>

            <c:when test="${sessionScope.user.role == 'FACULTY'}">
                <div class="nav-section-label">TEACHING</div>
                <nav class="nav flex-column gap-1">
                    <a class="nav-link ${activeNav == 'dashboard' ? 'active' : ''}" href="${pageContext.request.contextPath}/faculty/dashboard">
                        <i class="bi bi-house"></i> Dashboard
                    </a>
                    <a class="nav-link ${activeNav == 'attendance' ? 'active' : ''}" href="${pageContext.request.contextPath}/faculty/attendance">
                        <i class="bi bi-calendar-check"></i> Attendance
                    </a>
                    <a class="nav-link ${activeNav == 'announcements' ? 'active' : ''}" href="${pageContext.request.contextPath}/admin/announcements">
                        <i class="bi bi-megaphone"></i> Announcements
                    </a>
                </nav>
            </c:when>

            <c:when test="${sessionScope.user.role == 'STUDENT'}">
                <div class="nav-section-label">LEARNING</div>
                <nav class="nav flex-column gap-1">
                    <a class="nav-link ${activeNav == 'dashboard' ? 'active' : ''}" href="${pageContext.request.contextPath}/student/dashboard">
                        <i class="bi bi-house"></i> Dashboard
                    </a>
                    <a class="nav-link ${activeNav == 'catalog' ? 'active' : ''}" href="${pageContext.request.contextPath}/student/catalog">
                        <i class="bi bi-search"></i> Course Catalog
                    </a>
                    <a class="nav-link ${activeNav == 'grades' ? 'active' : ''}" href="${pageContext.request.contextPath}/student/grades">
                        <i class="bi bi-clipboard-data"></i> My Grades
                    </a>
                    <a class="nav-link ${activeNav == 'attendance' ? 'active' : ''}" href="${pageContext.request.contextPath}/student/attendance">
                        <i class="bi bi-calendar-check"></i> My Attendance
                    </a>
                </nav>
            </c:when>
        </c:choose>
    </aside>
</c:if>
