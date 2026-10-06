<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<c:set var="pageTitle" value="Faculty Dashboard" />
<c:set var="activeNav" value="dashboard" />
<%@ include file="/common/header.jsp" %>
<%@ include file="/common/navbar.jsp" %>

<div class="d-flex">
    <%@ include file="/common/sidebar.jsp" %>
    <main class="app-content">
        <h1 class="page-title mb-3">Faculty Dashboard</h1>
        <%@ include file="/common/flash.jsp" %>

        <!-- Submissions Awaiting Evaluation Table -->
        <div class="card cc-card">
            <div class="d-flex justify-content-between align-items-center mb-3">
                <h2 class="section-title mb-0">Submissions awaiting evaluation</h2>
                <span class="cc-chip cc-chip-pending"><c:out value="${ungradedSubmissions.size()}" /> pending</span>
            </div>
            
            <div class="table-responsive border rounded">
                <table class="table table-hover align-middle mb-0">
                    <thead>
                        <tr>
                            <th>Student</th>
                            <th>Assignment</th>
                            <th>Course</th>
                            <th>Submitted Date</th>
                            <th>Action</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="sub" items="${ungradedSubmissions}">
                            <tr>
                                <td class="fw-medium"><c:out value="${sub.studentName}" /></td>
                                <td><c:out value="${sub.assignmentTitle}" /></td>
                                <td><span class="code-font fw-semibold"><c:out value="${sub.courseCode}" /></span></td>
                                <td class="text-muted small"><c:out value="${sub.submittedOn}" /></td>
                                <td>
                                    <a href="${pageContext.request.contextPath}/faculty/grading?assignmentId=${sub.assignmentId}&studentId=${sub.studentId}" class="btn btn-xs btn-primary">
                                        Evaluate
                                    </a>
                                </td>
                            </tr>
                        </c:forEach>
                        <c:if test="${empty ungradedSubmissions}">
                            <tr>
                                <td colspan="5" class="text-center text-muted py-3">No ungraded submissions awaiting evaluation.</td>
                            </tr>
                        </c:if>
                    </tbody>
                </table>
            </div>
        </div>

        <!-- My Courses Table (Compact Table per Anti-AI Rules) -->
        <div class="card cc-card">
            <h2 class="section-title">Assigned courses</h2>
            <div class="table-responsive border rounded">
                <table class="table table-hover align-middle mb-0">
                    <thead>
                        <tr>
                            <th>Code</th>
                            <th>Title</th>
                            <th>Category</th>
                            <th>Enrolled / Capacity</th>
                            <th>Duration</th>
                            <th>Actions</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="c" items="${myCourses}">
                            <tr>
                                <td class="code-font fw-semibold"><c:out value="${c.courseCode}" /></td>
                                <td class="fw-medium"><c:out value="${c.title}" /></td>
                                <td class="text-muted small"><c:out value="${c.categoryName}" /></td>
                                <td class="tabular-nums"><c:out value="${c.enrolledCount}" /> / <c:out value="${c.capacity}" /></td>
                                <td class="tabular-nums text-muted small"><c:out value="${c.durationWeeks}" /> weeks</td>
                                <td>
                                    <a href="${pageContext.request.contextPath}/faculty/course?id=${c.courseId}" class="btn btn-xs btn-outline-primary">Workspace</a>
                                    <a href="${pageContext.request.contextPath}/faculty/attendance?courseId=${c.courseId}" class="btn btn-xs btn-outline-secondary ms-1">Mark attendance</a>
                                </td>
                            </tr>
                        </c:forEach>
                        <c:if test="${empty myCourses}">
                            <tr>
                                <td colspan="6" class="text-center text-muted py-3">No courses currently assigned.</td>
                            </tr>
                        </c:if>
                    </tbody>
                </table>
            </div>
        </div>
    </main>
</div>

<%@ include file="/common/footer.jsp" %>
