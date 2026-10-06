<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<c:set var="pageTitle" value="Submit Assignment" />
<c:set var="activeNav" value="dashboard" />
<%@ include file="/common/header.jsp" %>
<%@ include file="/common/navbar.jsp" %>

<div class="container py-4" style="max-width: 900px;">
    <div class="mb-3">
        <a href="${pageContext.request.contextPath}/student/course?id=${assignment.courseId}" class="text-secondary small text-decoration-none">
            <i class="bi bi-arrow-left me-1"></i>Back to course workspace
        </a>
    </div>

    <%@ include file="/common/flash.jsp" %>

    <div class="row g-4">
        <!-- Left Pane: Assignment Details -->
        <div class="col-md-6">
            <div class="card cc-card p-4">
                <span class="course-code-badge h6 mb-1 d-inline-block"><c:out value="${assignment.courseCode}" /></span>
                <h1 class="page-title h4 mb-2"><c:out value="${assignment.title}" /></h1>
                
                <div class="d-flex gap-3 text-muted small mb-3">
                    <span>Due: <c:out value="${assignment.dueDate}" /></span>
                    <span>Max marks: <c:out value="${assignment.maxMarks}" /></span>
                </div>

                <div class="p-3 border rounded bg-light mb-3">
                    <div class="fw-semibold small text-secondary mb-1">Instructions</div>
                    <p class="text-secondary small mb-0"><c:out value="${assignment.description}" /></p>
                </div>
            </div>
        </div>

        <!-- Right Pane: Submission Form / Status -->
        <div class="col-md-6">
            <div class="card cc-card p-4">
                <h2 class="h6 fw-semibold mb-3">Your submission</h2>

                <c:choose>
                    <c:when test="${not empty submission}">
                        <div class="p-3 border rounded mb-3 bg-light">
                            <div class="d-flex justify-content-between align-items-start mb-2">
                                <span class="fw-medium small">Status:
                                    <c:choose>
                                        <c:when test="${submission.graded}">
                                            <span class="cc-chip cc-chip-graded">Graded</span>
                                        </c:when>
                                        <c:otherwise>
                                            <span class="cc-chip cc-chip-submitted">Submitted</span>
                                        </c:otherwise>
                                    </c:choose>
                                </span>
                                <c:if test="${submission.late}">
                                    <span class="cc-chip cc-chip-late">Late submission</span>
                                </c:if>
                            </div>

                            <div class="text-muted small mb-2" style="font-size: 11px;">
                                Submitted on <c:out value="${submission.submittedOn}" />
                            </div>

                            <div class="mb-2">
                                <a href="${pageContext.request.contextPath}/uploads/${submission.filePath}" target="_blank" class="btn btn-xs btn-outline-primary">
                                    <i class="bi bi-download me-1"></i>Download submitted file
                                </a>
                            </div>

                            <c:if test="${submission.graded}">
                                <hr class="my-2">
                                <div class="fw-semibold small text-dark mb-1">Marks: <c:out value="${submission.marksObtained}" /> / <c:out value="${assignment.maxMarks}" /></div>
                                <c:if test="${not empty submission.feedback}">
                                    <div class="text-secondary small fst-italic">Feedback: "<c:out value="${submission.feedback}" />"</div>
                                </c:if>
                            </c:if>
                        </div>

                        <c:if test="${!submission.graded}">
                            <div class="text-muted small mb-2">You may re-upload your file below to update your submission before grading:</div>
                        </c:if>
                    </c:when>
                    <c:otherwise>
                        <div class="inline-alert inline-alert-info mb-3">No submission uploaded yet for this assignment.</div>
                    </c:otherwise>
                </c:choose>

                <c:if test="${empty submission or !submission.graded}">
                    <form action="${pageContext.request.contextPath}/student/submission" method="post" enctype="multipart/form-data">
                        <input type="hidden" name="csrfToken" value="${sessionScope.csrfToken}" />
                        <input type="hidden" name="assignmentId" value="${assignment.assignmentId}" />

                        <div class="mb-3">
                            <label for="subFile" class="form-label small fw-medium">Select file to submit <span class="text-muted">(PDF, ZIP, Doc, Java)</span></label>
                            <input type="file" id="subFile" name="file" class="form-control" required>
                        </div>

                        <button type="submit" class="btn btn-sm btn-primary w-100">
                            <c:out value="${not empty submission ? 'Re-upload submission' : 'Submit assignment'}" />
                        </button>
                    </form>
                </c:if>
            </div>
        </div>
    </div>
</div>

<%@ include file="/common/footer.jsp" %>
