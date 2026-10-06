<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<c:set var="pageTitle" value="Dashboard" />
<c:set var="activeNav" value="dashboard" />
<%@ include file="/common/header.jsp" %>
<%@ include file="/common/navbar.jsp" %>

<div class="d-flex">
    <%@ include file="/common/sidebar.jsp" %>
    <main class="app-content">
        <h1 class="page-title mb-3">Dashboard</h1>
        <%@ include file="/common/flash.jsp" %>

        <div class="row g-4">
            <!-- Main Left Column -->
            <div class="col-lg-8">
                <!-- Due Soon Section -->
                <div class="card cc-card">
                    <h2 class="section-title">Due soon</h2>
                    <div class="table-responsive border rounded">
                        <table class="table table-hover align-middle mb-0">
                            <thead>
                                <tr>
                                    <th>Assignment</th>
                                    <th>Course</th>
                                    <th>Due Date</th>
                                    <th>Action</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach var="a" items="${dueSoonList}">
                                    <tr>
                                        <td class="fw-medium"><c:out value="${a.title}" /></td>
                                        <td><span class="code-font fw-semibold"><c:out value="${a.courseCode}" /></span></td>
                                        <td class="text-muted small"><c:out value="${a.dueDate}" /></td>
                                        <td>
                                            <a href="${pageContext.request.contextPath}/student/submission?assignmentId=${a.assignmentId}" class="btn btn-xs btn-primary">
                                                Submit
                                            </a>
                                        </td>
                                    </tr>
                                </c:forEach>
                                <c:if test="${empty dueSoonList}">
                                    <tr>
                                        <td colspan="4" class="text-center text-muted py-3">No upcoming assignments due.</td>
                                    </tr>
                                </c:if>
                            </tbody>
                        </table>
                    </div>
                </div>

                <!-- My Courses Grid (Course Code Tiles) -->
                <div class="card cc-card">
                    <div class="d-flex justify-content-between align-items-center mb-3">
                        <h2 class="section-title mb-0">My enrolled courses</h2>
                        <a href="${pageContext.request.contextPath}/student/catalog" class="btn btn-sm btn-outline-primary">Browse catalog</a>
                    </div>

                    <div class="row g-3">
                        <c:forEach var="e" items="${myEnrollments}">
                            <c:set var="toneIndex" value="${e.courseId % 6}" />
                            <c:set var="toneClass" value="tone-teal" />
                            <c:if test="${toneIndex == 0}"><c:set var="toneClass" value="tone-slate" /></c:if>
                            <c:if test="${toneIndex == 1}"><c:set var="toneClass" value="tone-teal" /></c:if>
                            <c:if test="${toneIndex == 2}"><c:set var="toneClass" value="tone-brown" /></c:if>
                            <c:if test="${toneIndex == 3}"><c:set var="toneClass" value="tone-olive" /></c:if>
                            <c:if test="${toneIndex == 4}"><c:set var="toneClass" value="tone-plum" /></c:if>
                            <c:if test="${toneIndex == 5}"><c:set var="toneClass" value="tone-steel" /></c:if>

                            <div class="col-md-6">
                                <div class="course-tile ${toneClass}">
                                    <div>
                                        <div class="d-flex justify-content-between align-items-start mb-2">
                                            <span class="course-code-badge"><c:out value="${e.courseCode}" /></span>
                                            <span class="cc-chip cc-chip-enrolled"><c:out value="${e.status}" /></span>
                                        </div>
                                        <h3 class="h6 fw-semibold text-dark mb-2"><c:out value="${e.courseTitle}" /></h3>
                                        
                                        <!-- Progress Bar -->
                                        <c:set var="pct" value="${progressMap[e.courseId]}" />
                                        <div class="progress mb-1" style="height: 6px;">
                                            <div class="progress-bar bg-success" role="progressbar" style="width: ${pct}%;" aria-valuenow="${pct}" aria-valuemin="0" aria-valuemax="100"></div>
                                        </div>
                                        <div class="text-muted small mb-3" style="font-size: 11px;">
                                            <c:out value="${pct}" />% assignments submitted
                                        </div>
                                    </div>
                                    <a href="${pageContext.request.contextPath}/student/course?id=${e.courseId}" class="btn btn-sm btn-outline-primary w-100">
                                        Open workspace
                                    </a>
                                </div>
                            </div>
                        </c:forEach>
                        <c:if test="${empty myEnrollments}">
                            <div class="col-12">
                                <div class="text-center py-4 text-muted border rounded bg-white">
                                    You have not enrolled in any courses yet. <a href="${pageContext.request.contextPath}/student/catalog">Browse course catalog</a>
                                </div>
                            </div>
                        </c:if>
                    </div>
                </div>
            </div>

            <!-- Right Column Panel -->
            <div class="col-lg-4">
                <!-- Recent Grades -->
                <div class="card cc-card mb-4">
                    <h2 class="section-title">Recent grades</h2>
                    <div class="list-group list-group-flush border rounded">
                        <c:forEach var="rg" items="${recentGraded}">
                            <div class="list-group-item py-2 px-3">
                                <div class="d-flex justify-content-between align-items-start">
                                    <span class="fw-medium small"><c:out value="${rg.assignmentTitle}" /></span>
                                    <span class="cc-chip cc-chip-graded tabular-nums"><c:out value="${rg.marksObtained}" /> / <c:out value="${rg.maxMarks}" /></span>
                                </div>
                                <div class="text-muted small" style="font-size: 11px;"><c:out value="${rg.courseCode}" /> &bull; <c:out value="${rg.submittedOn}" /></div>
                                <c:if test="${not empty rg.feedback}">
                                    <div class="text-secondary small mt-1 fst-italic" style="font-size: 12px;">"<c:out value="${rg.feedback}" />"</div>
                                </c:if>
                            </div>
                        </c:forEach>
                        <c:if test="${empty recentGraded}">
                            <div class="p-3 text-center text-muted small">No graded submissions yet.</div>
                        </c:if>
                    </div>
                </div>

                <!-- Latest Announcements -->
                <div class="card cc-card">
                    <h2 class="section-title">Announcements</h2>
                    <div class="list-group list-group-flush border rounded">
                        <c:forEach var="anc" items="${announcements}">
                            <div class="list-group-item py-2 px-3">
                                <div class="fw-semibold small"><c:out value="${anc.title}" /></div>
                                <div class="text-secondary small mb-1" style="font-size: 12px;"><c:out value="${anc.message}" /></div>
                                <div class="text-muted small" style="font-size: 10px;">
                                    <c:out value="${anc.global ? 'Global' : anc.courseCode}" /> &bull; <c:out value="${anc.postedOn}" />
                                </div>
                            </div>
                        </c:forEach>
                        <c:if test="${empty announcements}">
                            <div class="p-3 text-center text-muted small">No announcements.</div>
                        </c:if>
                    </div>
                </div>
            </div>
        </div>
    </main>
</div>

<%@ include file="/common/footer.jsp" %>
