<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<c:set var="pageTitle" value="All Enrollments" />
<c:set var="activeNav" value="enrollments" />
<%@ include file="/common/header.jsp" %>
<%@ include file="/common/navbar.jsp" %>

<div class="d-flex">
    <%@ include file="/common/sidebar.jsp" %>
    <main class="app-content">
        <h1 class="page-title mb-3">All Enrollments</h1>
        <%@ include file="/common/flash.jsp" %>

        <!-- Filter Bar -->
        <div class="card cc-card py-2 mb-3">
            <form action="${pageContext.request.contextPath}/admin/enrollments" method="get" class="row g-2 align-items-center">
                <div class="col-md-5">
                    <input type="text" name="q" class="form-control form-control-sm" placeholder="Search student, email, course..." value="${param.q}">
                </div>
                <div class="col-md-3">
                    <select name="status" class="form-select form-select-sm">
                        <option value="">All statuses</option>
                        <option value="ACTIVE" ${param.status == 'ACTIVE' ? 'selected' : ''}>ACTIVE</option>
                        <option value="COMPLETED" ${param.status == 'COMPLETED' ? 'selected' : ''}>COMPLETED</option>
                        <option value="DROPPED" ${param.status == 'DROPPED' ? 'selected' : ''}>DROPPED</option>
                    </select>
                </div>
                <div class="col-md-2">
                    <button type="submit" class="btn btn-sm btn-outline-secondary w-100">Filter</button>
                </div>
                <div class="col-md-2">
                    <a href="${pageContext.request.contextPath}/admin/enrollments" class="btn btn-sm btn-link text-secondary w-100">Clear</a>
                </div>
            </form>
        </div>

        <!-- Table -->
        <div class="table-responsive bg-white border rounded">
            <table class="table table-hover align-middle mb-0">
                <thead>
                    <tr>
                        <th>Enrollment ID</th>
                        <th>Student</th>
                        <th>Email</th>
                        <th>Course Code</th>
                        <th>Course Title</th>
                        <th>Enrolled Date</th>
                        <th>Status</th>
                        <th>Action</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach var="e" items="${pageObj.items}">
                        <tr>
                            <td class="code-font text-muted"><c:out value="${e.enrollmentId}" /></td>
                            <td class="fw-medium"><c:out value="${e.studentName}" /></td>
                            <td class="text-muted small"><c:out value="${e.studentEmail}" /></td>
                            <td class="code-font fw-semibold"><c:out value="${e.courseCode}" /></td>
                            <td><c:out value="${e.courseTitle}" /></td>
                            <td class="text-muted small"><c:out value="${e.enrolledOn}" /></td>
                            <td>
                                <span class="cc-chip ${e.status == 'ACTIVE' ? 'cc-chip-active' : (e.status == 'COMPLETED' ? 'cc-chip-completed' : 'cc-chip-disabled')}">
                                    <c:out value="${e.status}" />
                                </span>
                            </td>
                            <td>
                                <c:if test="${e.status == 'ACTIVE'}">
                                    <form action="${pageContext.request.contextPath}/admin/enrollments" method="post" class="d-inline">
                                        <input type="hidden" name="csrfToken" value="${sessionScope.csrfToken}" />
                                        <input type="hidden" name="action" value="updateStatus" />
                                        <input type="hidden" name="enrollmentId" value="${e.enrollmentId}" />
                                        <input type="hidden" name="status" value="COMPLETED" />
                                        <button type="submit" class="btn btn-xs btn-outline-success">Mark Completed</button>
                                    </form>
                                    <form action="${pageContext.request.contextPath}/admin/enrollments" method="post" class="d-inline ms-1">
                                        <input type="hidden" name="csrfToken" value="${sessionScope.csrfToken}" />
                                        <input type="hidden" name="action" value="updateStatus" />
                                        <input type="hidden" name="enrollmentId" value="${e.enrollmentId}" />
                                        <input type="hidden" name="status" value="DROPPED" />
                                        <button type="submit" class="btn btn-xs btn-outline-danger">Drop</button>
                                    </form>
                                </c:if>
                            </td>
                        </tr>
                    </c:forEach>
                    <c:if test="${empty pageObj.items}">
                        <tr>
                            <td colspan="8" class="text-center text-muted py-4">No enrollments found.</td>
                        </tr>
                    </c:if>
                </tbody>
            </table>
        </div>

        <%@ include file="/common/pagination.jsp" %>
    </main>
</div>

<%@ include file="/common/footer.jsp" %>
