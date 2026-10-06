<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<c:set var="pageTitle" value="${course.courseCode} - Course Details" />
<c:set var="activeNav" value="catalog" />
<%@ include file="/common/header.jsp" %>
<%@ include file="/common/navbar.jsp" %>

<div class="d-flex">
    <%@ include file="/common/sidebar.jsp" %>
    <main class="app-content">
        <%@ include file="/common/flash.jsp" %>

        <c:choose>
            <!-- UNENROLLED SPLASH VIEW -->
            <c:when test="${not enrolled}">
                <div class="card cc-card p-4 mb-4">
                    <div class="row g-4 align-items-center">
                        <div class="col-md-8">
                            <span class="course-code-badge h6 mb-2 d-inline-block"><c:out value="${course.courseCode}" /></span>
                            <h1 class="page-title h3 mb-2"><c:out value="${course.title}" /></h1>
                            <p class="text-muted small mb-3">
                                Category: <c:out value="${course.categoryName}" /> &bull; Instructor: <c:out value="${course.facultyName != null ? course.facultyName : 'Unassigned'}" /> &bull; Duration: <c:out value="${course.durationWeeks}" /> weeks
                            </p>
                            <p class="text-secondary"><c:out value="${course.description}" /></p>
                        </div>
                        <div class="col-md-4">
                            <!-- Sticky Enrolment Box -->
                            <div class="p-3 border rounded bg-light text-center">
                                <div class="fw-semibold mb-2">Enrollment Status</div>
                                
                                <c:set var="fillPct" value="${(course.enrolledCount / course.capacity) * 100}" />
                                <div class="progress mb-2" style="height: 8px;">
                                    <div class="progress-bar ${course.full ? 'bg-danger' : 'bg-primary'}" role="progressbar" style="width: ${fillPct}%;"></div>
                                </div>
                                
                                <div class="small text-muted mb-3 tabular-nums">
                                    <c:out value="${course.enrolledCount}" /> of <c:out value="${course.capacity}" /> seats filled (<c:out value="${course.seatsLeft}" /> seats left)
                                </div>

                                <c:choose>
                                    <c:when test="${course.full}">
                                        <button class="btn btn-sm btn-danger w-100" disabled>Course is Full</button>
                                    </c:when>
                                    <c:otherwise>
                                        <form action="${pageContext.request.contextPath}/student/enroll" method="post">
                                            <input type="hidden" name="csrfToken" value="${sessionScope.csrfToken}" />
                                            <input type="hidden" name="courseId" value="${course.courseId}" />
                                            <button type="submit" class="btn btn-sm btn-primary w-100">Enrol in course</button>
                                        </form>
                                    </c:otherwise>
                                </c:choose>
                            </div>
                        </div>
                    </div>
                </div>
            </c:when>

            <!-- ENROLLED WORKSPACE VIEW -->
            <c:otherwise>
                <div class="card cc-card p-3 mb-3">
                    <div class="d-flex justify-content-between align-items-start">
                        <div>
                            <span class="course-code-badge h6 mb-1 d-inline-block"><c:out value="${course.courseCode}" /></span>
                            <h1 class="page-title h4 mb-1"><c:out value="${course.title}" /></h1>
                            <div class="text-muted small">
                                Instructor: <c:out value="${course.facultyName}" /> &bull; <c:out value="${course.categoryName}" />
                            </div>
                        </div>
                        <div>
                            <span class="cc-chip cc-chip-enrolled">Enrolled</span>
                        </div>
                    </div>
                </div>

                <!-- Tabs -->
                <ul class="nav nav-tabs mb-4" id="studentWorkspaceTabs" role="tablist">
                    <li class="nav-item">
                        <button class="nav-link active" id="stream-tab" data-bs-toggle="tab" data-bs-target="#stream" type="button" role="tab">Stream</button>
                    </li>
                    <li class="nav-item">
                        <button class="nav-link" id="classwork-tab" data-bs-toggle="tab" data-bs-target="#classwork" type="button" role="tab">Classwork</button>
                    </li>
                    <li class="nav-item">
                        <button class="nav-link" id="grades-tab" data-bs-toggle="tab" data-bs-target="#grades" type="button" role="tab">My Grades</button>
                    </li>
                    <li class="nav-item">
                        <button class="nav-link" id="attendance-tab" data-bs-toggle="tab" data-bs-target="#attendance" type="button" role="tab">Attendance</button>
                    </li>
                </ul>

                <div class="tab-content">
                    <!-- Stream -->
                    <div class="tab-pane fade show active" id="stream" role="tabpanel">
                        <c:forEach var="a" items="${announcements}">
                            <div class="card cc-card p-3 mb-3">
                                <div class="fw-semibold text-dark mb-1"><c:out value="${a.title}" /></div>
                                <div class="text-muted small mb-2" style="font-size: 11px;">Posted by <c:out value="${a.postedByName}" /> &bull; <c:out value="${a.postedOn}" /></div>
                                <p class="text-secondary small mb-0"><c:out value="${a.message}" /></p>
                            </div>
                        </c:forEach>
                        <c:if test="${empty announcements}">
                            <div class="text-center py-4 text-muted small bg-white border rounded">No course announcements.</div>
                        </c:if>
                    </div>

                    <!-- Classwork -->
                    <div class="tab-pane fade" id="classwork" role="tabpanel">
                        <div class="card cc-card mb-4">
                            <h2 class="h6 fw-semibold text-secondary mb-3">Course Materials</h2>
                            <div class="table-responsive border rounded">
                                <table class="table table-hover align-middle mb-0">
                                    <thead>
                                        <tr>
                                            <th>Week</th>
                                            <th>Title</th>
                                            <th>Type</th>
                                            <th>Uploaded</th>
                                            <th>Action</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <c:forEach var="m" items="${materials}">
                                            <tr>
                                                <td class="tabular-nums fw-medium">Week <c:out value="${m.weekNo}" /></td>
                                                <td class="fw-medium"><c:out value="${m.title}" /></td>
                                                <td><span class="cc-chip cc-chip-enrolled"><c:out value="${m.type}" /></span></td>
                                                <td class="text-muted small"><c:out value="${m.uploadedOn}" /></td>
                                                <td>
                                                    <c:choose>
                                                        <c:when test="${m.type == 'LINK'}">
                                                            <a href="${m.filePath}" target="_blank" class="btn btn-xs btn-outline-secondary">Open link</a>
                                                        </c:when>
                                                        <c:otherwise>
                                                            <a href="${pageContext.request.contextPath}/uploads/${m.filePath}" target="_blank" class="btn btn-xs btn-outline-secondary">Download</a>
                                                        </c:otherwise>
                                                    </c:choose>
                                                </td>
                                            </tr>
                                        </c:forEach>
                                        <c:if test="${empty materials}">
                                            <tr>
                                                <td colspan="5" class="text-center text-muted py-3">No materials posted yet.</td>
                                            </tr>
                                        </c:if>
                                    </tbody>
                                </table>
                            </div>
                        </div>

                        <div class="card cc-card">
                            <h2 class="h6 fw-semibold text-secondary mb-3">Assignments</h2>
                            <div class="table-responsive border rounded">
                                <table class="table table-hover align-middle mb-0">
                                    <thead>
                                        <tr>
                                            <th>Week</th>
                                            <th>Title</th>
                                            <th>Due Date</th>
                                            <th>Max Marks</th>
                                            <th>Status</th>
                                            <th>Action</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <c:forEach var="as" items="${assignments}">
                                            <c:set var="mySub" value="${subMap[as.assignmentId]}" />
                                            <tr>
                                                <td class="tabular-nums fw-medium">Week <c:out value="${as.weekNo}" /></td>
                                                <td class="fw-medium"><c:out value="${as.title}" /></td>
                                                <td class="text-muted small"><c:out value="${as.dueDate}" /></td>
                                                <td class="tabular-nums"><c:out value="${as.maxMarks}" /></td>
                                                <td>
                                                    <c:choose>
                                                        <c:when test="${not empty mySub and mySub.graded}">
                                                            <span class="cc-chip cc-chip-graded"><c:out value="${mySub.marksObtained}" /> / <c:out value="${as.maxMarks}" /></span>
                                                        </c:when>
                                                        <c:when test="${not empty mySub}">
                                                            <span class="cc-chip cc-chip-submitted">Submitted</span>
                                                        </c:when>
                                                        <c:otherwise>
                                                            <span class="cc-chip cc-chip-pending">Not submitted</span>
                                                        </c:otherwise>
                                                    </c:choose>
                                                </td>
                                                <td>
                                                    <a href="${pageContext.request.contextPath}/student/submission?assignmentId=${as.assignmentId}" class="btn btn-xs btn-outline-primary">
                                                        <c:out value="${not empty mySub ? 'View submission' : 'Submit'}" />
                                                    </a>
                                                </td>
                                            </tr>
                                        </c:forEach>
                                        <c:if test="${empty assignments}">
                                            <tr>
                                                <td colspan="6" class="text-center text-muted py-3">No assignments posted yet.</td>
                                            </tr>
                                        </c:if>
                                    </tbody>
                                </table>
                            </div>
                        </div>
                    </div>

                    <!-- My Grades -->
                    <div class="tab-pane fade" id="grades" role="tabpanel">
                        <div class="card cc-card">
                            <h2 class="h6 fw-semibold mb-3">My Grades for <c:out value="${course.courseCode}" /></h2>
                            <div class="table-responsive border rounded">
                                <table class="table table-hover align-middle mb-0">
                                    <thead>
                                        <tr>
                                            <th>Assignment</th>
                                            <th>Due Date</th>
                                            <th>Marks Obtained</th>
                                            <th>Max Marks</th>
                                            <th>Feedback</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <c:forEach var="as" items="${assignments}">
                                            <c:set var="mySub" value="${subMap[as.assignmentId]}" />
                                            <tr>
                                                <td class="fw-medium"><c:out value="${as.title}" /></td>
                                                <td class="text-muted small"><c:out value="${as.dueDate}" /></td>
                                                <td class="tabular-nums fw-semibold">
                                                    <c:out value="${not empty mySub and mySub.graded ? mySub.marksObtained : '-'}" />
                                                </td>
                                                <td class="tabular-nums"><c:out value="${as.maxMarks}" /></td>
                                                <td class="text-secondary small">
                                                    <c:out value="${not empty mySub and not empty mySub.feedback ? mySub.feedback : '-'}" />
                                                </td>
                                            </tr>
                                        </c:forEach>
                                    </tbody>
                                </table>
                            </div>
                        </div>
                    </div>

                    <!-- Attendance -->
                    <div class="tab-pane fade" id="attendance" role="tabpanel">
                        <div class="card cc-card">
                            <div class="d-flex justify-content-between align-items-center mb-3">
                                <h2 class="h6 fw-semibold mb-0">My Attendance</h2>
                                <span class="cc-chip ${attendancePct >= 75 ? 'cc-chip-active' : 'cc-chip-disabled'}">
                                    Attendance: <c:out value="${attendancePct}" />%
                                </span>
                            </div>
                            <div class="table-responsive border rounded">
                                <table class="table table-hover align-middle mb-0">
                                    <thead>
                                        <tr>
                                            <th>Session Date</th>
                                            <th>Status</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <c:forEach var="att" items="${myAttendance}">
                                            <tr>
                                                <td class="code-font"><c:out value="${att.sessionDate}" /></td>
                                                <td>
                                                    <span class="cc-chip ${att.status == 'PRESENT' ? 'cc-chip-active' : 'cc-chip-disabled'}">
                                                        <c:out value="${att.status}" />
                                                    </span>
                                                </td>
                                            </tr>
                                        </c:forEach>
                                        <c:if test="${empty myAttendance}">
                                            <tr>
                                                <td colspan="2" class="text-center text-muted py-3">No attendance records for this course.</td>
                                            </tr>
                                        </c:if>
                                    </tbody>
                                </table>
                            </div>
                        </div>
                    </div>
                </div>
            </c:otherwise>
        </c:choose>
    </main>
</div>

<%@ include file="/common/footer.jsp" %>
