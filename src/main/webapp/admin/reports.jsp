<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<c:set var="pageTitle" value="Reports & CSV Export" />
<c:set var="activeNav" value="reports" />
<%@ include file="/common/header.jsp" %>
<%@ include file="/common/navbar.jsp" %>

<div class="d-flex">
    <%@ include file="/common/sidebar.jsp" %>
    <main class="app-content">
        <div class="d-flex justify-content-between align-items-center mb-3">
            <h1 class="page-title">Reports & CSV Export</h1>
            <div>
                <a href="${pageContext.request.contextPath}/admin/reports?export=csv&type=enrollment&q=${param.q}&status=${param.status}" class="btn btn-sm btn-outline-primary">
                    <i class="bi bi-download me-1"></i>Export Enrollments CSV
                </a>
                <a href="${pageContext.request.contextPath}/admin/reports?export=csv&type=attendance&q=${param.q}&status=${param.status}" class="btn btn-sm btn-outline-secondary ms-1">
                    <i class="bi bi-download me-1"></i>Export Attendance CSV
                </a>
            </div>
        </div>
        <%@ include file="/common/flash.jsp" %>

        <div class="card cc-card py-2 mb-3">
            <form action="${pageContext.request.contextPath}/admin/reports" method="get" class="row g-2 align-items-center">
                <div class="col-md-5">
                    <input type="text" name="q" class="form-control form-control-sm" placeholder="Search student, course..." value="${param.q}">
                </div>
                <div class="col-md-3">
                    <select name="status" class="form-select form-select-sm">
                        <option value="">All enrollment statuses</option>
                        <option value="ACTIVE" ${param.status == 'ACTIVE' ? 'selected' : ''}>ACTIVE</option>
                        <option value="COMPLETED" ${param.status == 'COMPLETED' ? 'selected' : ''}>COMPLETED</option>
                        <option value="DROPPED" ${param.status == 'DROPPED' ? 'selected' : ''}>DROPPED</option>
                    </select>
                </div>
                <div class="col-md-2">
                    <button type="submit" class="btn btn-sm btn-outline-secondary w-100">Filter</button>
                </div>
                <div class="col-md-2">
                    <a href="${pageContext.request.contextPath}/admin/reports" class="btn btn-sm btn-link text-secondary w-100">Clear</a>
                </div>
            </form>
        </div>

        <div class="table-responsive bg-white border rounded">
            <table class="table table-hover align-middle mb-0">
                <thead>
                    <tr>
                        <th>Enrollment ID</th>
                        <th>Student Name</th>
                        <th>Email</th>
                        <th>Course Code</th>
                        <th>Course Title</th>
                        <th>Enrolled Date</th>
                        <th>Status</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach var="e" items="${enrollments}">
                        <tr>
                            <td class="code-font text-muted"><c:out value="${e.enrollmentId}" /></td>
                            <td class="fw-medium"><c:out value="${e.studentName}" /></td>
                            <td class="text-muted small"><c:out value="${e.studentEmail}" /></td>
                            <td class="code-font fw-semibold"><c:out value="${e.courseCode}" /></td>
                            <td><c:out value="${e.courseTitle}" /></td>
                            <td class="text-muted small"><c:out value="${e.enrolledOn}" /></td>
                            <td><span class="cc-chip cc-chip-enrolled"><c:out value="${e.status}" /></span></td>
                        </tr>
                    </c:forEach>
                    <c:if test="${empty enrollments}">
                        <tr>
                            <td colspan="7" class="text-center text-muted py-4">No records found matching filters.</td>
                        </tr>
                    </c:if>
                </tbody>
            </table>
        </div>
    </main>
</div>

<%@ include file="/common/footer.jsp" %>
