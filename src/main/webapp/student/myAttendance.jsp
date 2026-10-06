<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<c:set var="pageTitle" value="My Attendance" />
<c:set var="activeNav" value="attendance" />
<%@ include file="/common/header.jsp" %>
<%@ include file="/common/navbar.jsp" %>

<div class="d-flex">
    <%@ include file="/common/sidebar.jsp" %>
    <main class="app-content">
        <h1 class="page-title mb-3">My Attendance</h1>
        <%@ include file="/common/flash.jsp" %>

        <c:forEach var="e" items="${enrollments}">
            <c:set var="pct" value="${percentageMap[e.courseId]}" />
            <c:set var="logs" value="${attendanceLogsMap[e.courseId]}" />

            <div class="card cc-card mb-4">
                <div class="d-flex justify-content-between align-items-center mb-3">
                    <div>
                        <span class="code-font fw-semibold me-2"><c:out value="${e.courseCode}" /></span>
                        <h2 class="h6 fw-bold mb-0 d-inline-block"><c:out value="${e.courseTitle}" /></h2>
                    </div>
                    <div>
                        <span class="cc-chip ${pct >= 75 ? 'cc-chip-active' : (pct >= 60 ? 'cc-chip-pending' : 'cc-chip-disabled')}">
                            <c:out value="${pct}" />% Attendance
                        </span>
                    </div>
                </div>

                <c:if test="${pct < 75}">
                    <div class="inline-alert inline-alert-danger py-2 mb-3 small">
                        Attendance warning: Your attendance is currently below 75%. Please attend upcoming scheduled sessions to reach the mandatory minimum.
                    </div>
                </c:if>

                <div class="table-responsive border rounded">
                    <table class="table table-hover align-middle mb-0">
                        <thead>
                            <tr>
                                <th>Session Date</th>
                                <th>Status</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="att" items="${logs}">
                                <tr>
                                    <td class="code-font"><c:out value="${att.sessionDate}" /></td>
                                    <td>
                                        <span class="cc-chip ${att.status == 'PRESENT' ? 'cc-chip-active' : 'cc-chip-disabled'}">
                                            <c:out value="${att.status}" />
                                        </span>
                                    </td>
                                </tr>
                            </c:forEach>
                            <c:if test="${empty logs}">
                                <tr>
                                    <td colspan="2" class="text-center text-muted py-3">No attendance records for this course.</td>
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
