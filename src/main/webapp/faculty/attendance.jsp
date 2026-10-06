<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<c:set var="pageTitle" value="Mark Attendance" />
<c:set var="activeNav" value="attendance" />
<%@ include file="/common/header.jsp" %>
<%@ include file="/common/navbar.jsp" %>

<div class="d-flex">
    <%@ include file="/common/sidebar.jsp" %>
    <main class="app-content">
        <h1 class="page-title mb-3">Attendance Marking</h1>
        <%@ include file="/common/flash.jsp" %>

        <!-- Course & Date Selection Bar -->
        <div class="card cc-card py-3 mb-3">
            <form action="${pageContext.request.contextPath}/faculty/attendance" method="get" class="row g-2 align-items-center">
                <div class="col-md-5">
                    <label for="courseSelect" class="form-label small fw-medium">Course</label>
                    <select id="courseSelect" name="courseId" class="form-select form-select-sm" onchange="this.form.submit()">
                        <c:forEach var="c" items="${myCourses}">
                            <option value="${c.courseId}" ${currentCourse.courseId == c.courseId ? 'selected' : ''}>
                                <c:out value="${c.courseCode}" /> - <c:out value="${c.title}" />
                            </option>
                        </c:forEach>
                    </select>
                </div>
                <div class="col-md-4">
                    <label for="dateSelect" class="form-label small fw-medium">Session date</label>
                    <input type="date" id="dateSelect" name="date" class="form-control form-control-sm" value="${sessionDate}" onchange="this.form.submit()">
                </div>
            </form>
        </div>

        <c:if test="${not empty currentCourse}">
            <!-- Roster Table Form -->
            <div class="card cc-card">
                <div class="d-flex justify-content-between align-items-center mb-3">
                    <div>
                        <h2 class="section-title mb-0"><c:out value="${currentCourse.courseCode}" /> Class Roster</h2>
                        <span class="text-muted small">Date: <c:out value="${sessionDate}" /></span>
                    </div>
                    <div>
                        <button type="button" class="btn btn-sm btn-outline-secondary" id="markAllPresentBtn">Mark all present</button>
                    </div>
                </div>

                <form action="${pageContext.request.contextPath}/faculty/attendance" method="post">
                    <input type="hidden" name="csrfToken" value="${sessionScope.csrfToken}" />
                    <input type="hidden" name="courseId" value="${currentCourse.courseId}" />
                    <input type="hidden" name="sessionDate" value="${sessionDate}" />

                    <div class="table-responsive border rounded mb-3">
                        <table class="table table-hover align-middle mb-0">
                            <thead>
                                <tr>
                                    <th>Student ID</th>
                                    <th>Student Name</th>
                                    <th>Email</th>
                                    <th>Attendance Status</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach var="e" items="${enrolledStudents}">
                                    <c:set var="attStatus" value="PRESENT" />
                                    <c:forEach var="att" items="${existingAtt}">
                                        <c:if test="${att.studentId == e.studentId}">
                                            <c:set var="attStatus" value="${att.status}" />
                                        </c:if>
                                    </c:forEach>

                                    <tr>
                                        <td class="code-font text-muted"><c:out value="${e.studentId}" /></td>
                                        <td class="fw-medium"><c:out value="${e.studentName}" /></td>
                                        <td class="text-muted small"><c:out value="${e.studentEmail}" /></td>
                                        <td>
                                            <input type="hidden" name="studentId" value="${e.studentId}" />
                                            <div class="btn-group btn-group-sm" role="group" aria-label="Attendance toggle">
                                                <input type="radio" class="btn-check att-radio-present" name="status_${e.studentId}" id="pres_${e.studentId}" value="PRESENT" ${attStatus == 'PRESENT' ? 'checked' : ''}>
                                                <label class="btn btn-outline-success px-3" for="pres_${e.studentId}">Present</label>

                                                <input type="radio" class="btn-check" name="status_${e.studentId}" id="abs_${e.studentId}" value="ABSENT" ${attStatus == 'ABSENT' ? 'checked' : ''}>
                                                <label class="btn btn-outline-danger px-3" for="abs_${e.studentId}">Absent</label>
                                            </div>
                                        </td>
                                    </tr>
                                </c:forEach>
                                <c:if test="${empty enrolledStudents}">
                                    <tr>
                                        <td colspan="4" class="text-center text-muted py-4">No active students enrolled in this course.</td>
                                    </tr>
                                </c:if>
                            </tbody>
                        </table>
                    </div>

                    <c:if test="${not empty enrolledStudents}">
                        <div class="d-flex justify-content-end">
                            <button type="submit" class="btn btn-sm btn-primary px-4">Save attendance</button>
                        </div>
                    </c:if>
                </form>
            </div>

            <!-- Past Sessions History -->
            <c:if test="${not empty pastDates}">
                <div class="card cc-card mt-4">
                    <h2 class="section-title mb-2">Past recorded sessions</h2>
                    <div class="d-flex flex-wrap gap-2">
                        <c:forEach var="pd" items="${pastDates}">
                            <a href="${pageContext.request.contextPath}/faculty/attendance?courseId=${currentCourse.courseId}&date=${pd}" class="btn btn-sm btn-outline-secondary code-font">
                                <c:out value="${pd}" />
                            </a>
                        </c:forEach>
                    </div>
                </div>
            </c:if>
        </c:if>
    </main>
</div>

<script>
document.addEventListener('DOMContentLoaded', function() {
    const markAllBtn = document.getElementById('markAllPresentBtn');
    if (markAllBtn) {
        markAllBtn.addEventListener('click', function() {
            document.querySelectorAll('.att-radio-present').forEach(function(radio) {
                radio.checked = true;
            });
        });
    }
});
</script>

<%@ include file="/common/footer.jsp" %>
