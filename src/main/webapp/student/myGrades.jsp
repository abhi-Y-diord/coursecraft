<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<c:set var="pageTitle" value="My Grades" />
<c:set var="activeNav" value="grades" />
<%@ include file="/common/header.jsp" %>
<%@ include file="/common/navbar.jsp" %>

<div class="d-flex">
    <%@ include file="/common/sidebar.jsp" %>
    <main class="app-content">
        <h1 class="page-title mb-3">My Grades</h1>
        <%@ include file="/common/flash.jsp" %>

        <c:forEach var="e" items="${enrollments}">
            <c:set var="assignments" value="${courseAssignmentsMap[e.courseId]}" />
            <c:set var="subMap" value="${courseSubmissionsMap[e.courseId]}" />

            <div class="card cc-card mb-4">
                <div class="d-flex justify-content-between align-items-center mb-3">
                    <div>
                        <span class="code-font fw-semibold me-2"><c:out value="${e.courseCode}" /></span>
                        <h2 class="h6 fw-bold mb-0 d-inline-block"><c:out value="${e.courseTitle}" /></h2>
                    </div>
                </div>

                <div class="table-responsive border rounded">
                    <table class="table table-hover align-middle mb-0">
                        <thead>
                            <tr>
                                <th>Assignment</th>
                                <th>Due Date</th>
                                <th>Marks Obtained</th>
                                <th>Max Marks</th>
                                <th>Status</th>
                                <th>Feedback</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="as" items="${assignments}">
                                <c:set var="sub" value="${subMap[as.assignmentId]}" />
                                <tr>
                                    <td class="fw-medium"><c:out value="${as.title}" /></td>
                                    <td class="text-muted small"><c:out value="${as.dueDate}" /></td>
                                    <td class="tabular-nums fw-bold">
                                        <c:out value="${not empty sub and sub.graded ? sub.marksObtained : '-'}" />
                                    </td>
                                    <td class="tabular-nums"><c:out value="${as.maxMarks}" /></td>
                                    <td>
                                        <c:choose>
                                            <c:when test="${not empty sub and sub.graded}">
                                                <span class="cc-chip cc-chip-graded">Graded</span>
                                            </c:when>
                                            <c:when test="${not empty sub}">
                                                <span class="cc-chip cc-chip-submitted">Submitted</span>
                                            </c:when>
                                            <c:otherwise>
                                                <span class="cc-chip cc-chip-pending">Pending</span>
                                            </c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td class="text-secondary small">
                                        <c:out value="${not empty sub and not empty sub.feedback ? sub.feedback : '-'}" />
                                    </td>
                                </tr>
                            </c:forEach>
                            <c:if test="${empty assignments}">
                                <tr>
                                    <td colspan="6" class="text-center text-muted py-3">No assignments for this course.</td>
                                </tr>
                            </c:if>
                        </tbody>
                    </table>
                </div>
            </div>
        </c:forEach>

        <c:if test="${empty enrollments}">
            <div class="text-center py-5 text-muted border rounded bg-white">
                No course enrollments found.
            </div>
        </c:if>
    </main>
</div>

<%@ include file="/common/footer.jsp" %>
