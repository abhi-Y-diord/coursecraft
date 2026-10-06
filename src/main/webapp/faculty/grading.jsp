<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<c:set var="pageTitle" value="Evaluation & Grading" />
<c:set var="activeNav" value="dashboard" />
<%@ include file="/common/header.jsp" %>
<%@ include file="/common/navbar.jsp" %>

<div class="container-fluid py-3 px-4">
    <div class="d-flex justify-content-between align-items-center mb-3">
        <div>
            <a href="${pageContext.request.contextPath}/faculty/course?id=${assignment.courseId}&tab=classwork" class="text-secondary small text-decoration-none me-2">
                <i class="bi bi-arrow-left"></i> Back to workspace
            </a>
            <span class="page-title h5"><c:out value="${assignment.courseCode}" />: <c:out value="${assignment.title}" /></span>
        </div>
        <div class="text-muted small">
            Due date: <c:out value="${assignment.dueDate}" /> &bull; Max marks: <c:out value="${assignment.maxMarks}" />
        </div>
    </div>

    <c:if test="${param.saved == 'true'}">
        <div class="inline-alert inline-alert-success py-2 mb-3">Grade and feedback saved successfully.</div>
    </c:if>

    <div class="row g-3">
        <!-- Left Pane (35%): Submissions List -->
        <div class="col-md-4 col-lg-4">
            <div class="card cc-card p-3 mb-0" style="min-height: 520px;">
                <div class="fw-semibold text-dark mb-2">Submissions (<c:out value="${submissions.size()}" />)</div>
                
                <div class="list-group list-group-flush border rounded overflow-auto" style="max-height: 440px;">
                    <c:forEach var="sub" items="${submissions}" varStatus="status">
                        <a href="${pageContext.request.contextPath}/faculty/grading?assignmentId=${assignment.assignmentId}&studentId=${sub.studentId}"
                           class="list-group-item list-group-item-action ${currentSubmission != null and currentSubmission.submissionId == sub.submissionId ? 'active' : ''}">
                            <div class="d-flex justify-content-between align-items-start mb-1">
                                <span class="fw-medium small"><c:out value="${sub.studentName}" /></span>
                                <c:choose>
                                    <c:when test="${sub.graded}">
                                        <span class="cc-chip cc-chip-graded"><c:out value="${sub.marksObtained}" /> / <c:out value="${assignment.maxMarks}" /></span>
                                    </c:when>
                                    <c:otherwise>
                                        <span class="cc-chip cc-chip-pending">Needs grading</span>
                                    </c:otherwise>
                                </c:choose>
                            </div>
                            <div class="d-flex justify-content-between align-items-center text-muted small" style="font-size: 11px;">
                                <span><c:out value="${sub.submittedOn}" /></span>
                                <c:if test="${sub.late}">
                                    <span class="cc-chip cc-chip-late" style="font-size: 10px;">Late</span>
                                </c:if>
                            </div>
                        </a>
                    </c:forEach>
                    <c:if test="${empty submissions}">
                        <div class="p-3 text-center text-muted small">No submissions uploaded yet for this assignment.</div>
                    </c:if>
                </div>
            </div>
        </div>

        <!-- Right Pane (65%): Submission Viewer & Evaluation Form -->
        <div class="col-md-8 col-lg-8">
            <div class="card cc-card p-4" style="min-height: 520px;">
                <c:choose>
                    <c:when test="${not empty currentSubmission}">
                        <!-- Determine next student in list -->
                        <c:set var="nextId" value="0" />
                        <c:forEach var="sub" items="${submissions}" varStatus="loop">
                            <c:if test="${sub.submissionId == currentSubmission.submissionId and not loop.last}">
                                <c:set var="nextId" value="${submissions[loop.index + 1].studentId}" />
                            </c:if>
                        </c:forEach>

                        <div class="d-flex justify-content-between align-items-start border-bottom pb-3 mb-3">
                            <div>
                                <h2 class="h6 fw-bold mb-1"><c:out value="${currentSubmission.studentName}" /></h2>
                                <div class="text-muted small"><c:out value="${currentSubmission.studentEmail}" /></div>
                            </div>
                            <div class="text-end">
                                <div class="small text-muted mb-1">Submitted on <c:out value="${currentSubmission.submittedOn}" /></div>
                                <c:if test="${currentSubmission.late}">
                                    <span class="cc-chip cc-chip-late">Submitted past due date</span>
                                </c:if>
                            </div>
                        </div>

                        <!-- Submission File / Link -->
                        <div class="p-3 bg-light border rounded mb-4">
                            <div class="fw-medium small mb-2 text-secondary">Submitted File</div>
                            <c:choose>
                                <c:when test="${not empty currentSubmission.filePath}">
                                    <a href="${pageContext.request.contextPath}/uploads/${currentSubmission.filePath}" target="_blank" class="btn btn-sm btn-outline-primary">
                                        <i class="bi bi-download me-1"></i>Download submission file (<c:out value="${currentSubmission.filePath}" />)
                                    </a>
                                </c:when>
                                <c:otherwise>
                                    <span class="text-muted small">No file attached.</span>
                                </c:otherwise>
                            </c:choose>
                        </div>

                        <!-- Grading Form -->
                        <form id="gradingForm" action="${pageContext.request.contextPath}/faculty/grading" method="post">
                            <input type="hidden" name="csrfToken" value="${sessionScope.csrfToken}" />
                            <input type="hidden" name="submissionId" value="${currentSubmission.submissionId}" />
                            <input type="hidden" name="assignmentId" value="${assignment.assignmentId}" />
                            <input type="hidden" name="nextStudentId" id="nextStudentIdInput" value="${nextId}" />

                            <div class="row g-3 mb-3">
                                <div class="col-md-4">
                                    <label for="marksObtained" class="form-label small fw-medium">Marks obtained <span class="text-muted">(0 to <c:out value="${assignment.maxMarks}" />)</span></label>
                                    <input type="number" id="marksObtained" name="marksObtained" class="form-control tabular-nums"
                                           min="0" max="${assignment.maxMarks}" value="${currentSubmission.marksObtained}" required autofocus>
                                </div>
                            </div>

                            <div class="mb-3">
                                <label for="feedback" class="form-label small fw-medium">Feedback comment <span class="text-muted">(visible to student)</span></label>
                                <textarea id="feedback" name="feedback" class="form-control" rows="4" placeholder="Provide constructive feedback..."><c:out value="${currentSubmission.feedback}" /></textarea>
                            </div>

                            <div class="d-flex justify-content-between align-items-center pt-2 border-top">
                                <span class="text-muted small">Keyboard shortcut: <code>Ctrl + Enter</code> = Save & Next</span>
                                <div>
                                    <button type="submit" onclick="document.getElementById('nextStudentIdInput').value='0';" class="btn btn-sm btn-outline-secondary me-2">Save</button>
                                    <button type="submit" onclick="document.getElementById('nextStudentIdInput').value='${nextId}';" class="btn btn-sm btn-primary">Save & Next</button>
                                </div>
                            </div>
                        </form>
                    </c:when>
                    <c:otherwise>
                        <div class="text-center py-5 text-muted">Select a submission from the list to evaluate.</div>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>
    </div>
</div>

<script>
document.addEventListener('keydown', function(e) {
    if (e.ctrlKey && e.key === 'Enter') {
        const form = document.getElementById('gradingForm');
        if (form) {
            e.preventDefault();
            form.submit();
        }
    }
});
</script>

<%@ include file="/common/footer.jsp" %>
