<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<c:set var="pageTitle" value="${course.courseCode} - Course Workspace" />
<c:set var="activeNav" value="dashboard" />
<%@ include file="/common/header.jsp" %>
<%@ include file="/common/navbar.jsp" %>

<div class="d-flex">
    <%@ include file="/common/sidebar.jsp" %>
    <main class="app-content">
        <!-- Course Header -->
        <div class="card cc-card p-3 mb-3">
            <div class="d-flex justify-content-between align-items-start">
                <div>
                    <span class="course-code-badge h6 mb-1 d-inline-block"><c:out value="${course.courseCode}" /></span>
                    <h1 class="page-title h4 mb-1"><c:out value="${course.title}" /></h1>
                    <div class="text-muted small">
                        Instructor: <c:out value="${course.facultyName}" /> &bull; <c:out value="${course.categoryName}" /> &bull; <c:out value="${course.durationWeeks}" /> weeks
                    </div>
                </div>
                <div>
                    <span class="cc-chip cc-chip-enrolled"><c:out value="${course.enrolledCount}" /> / <c:out value="${course.capacity}" /> enrolled</span>
                </div>
            </div>
        </div>

        <%@ include file="/common/flash.jsp" %>

        <!-- Workspace Navigation Tabs -->
        <ul class="nav nav-tabs mb-4" id="workspaceTabs" role="tablist">
            <li class="nav-item" role="presentation">
                <button class="nav-link active" id="stream-tab" data-bs-toggle="tab" data-bs-target="#stream" type="button" role="tab">Stream</button>
            </li>
            <li class="nav-item" role="presentation">
                <button class="nav-link" id="classwork-tab" data-bs-toggle="tab" data-bs-target="#classwork" type="button" role="tab">Classwork</button>
            </li>
            <li class="nav-item" role="presentation">
                <button class="nav-link" id="people-tab" data-bs-toggle="tab" data-bs-target="#people" type="button" role="tab">People</button>
            </li>
            <li class="nav-item" role="presentation">
                <button class="nav-link" id="grades-tab" data-bs-toggle="tab" data-bs-target="#grades" type="button" role="tab">Grades</button>
            </li>
        </ul>

        <div class="tab-content" id="workspaceTabContent">
            <!-- 1. STREAM TAB -->
            <div class="tab-pane fade show active" id="stream" role="tabpanel">
                <!-- Post Announcement Composer -->
                <div class="card cc-card p-3 mb-4">
                    <h2 class="h6 fw-semibold mb-2">Post announcement to class</h2>
                    <form action="${pageContext.request.contextPath}/admin/announcements" method="post">
                        <input type="hidden" name="csrfToken" value="${sessionScope.csrfToken}" />
                        <input type="hidden" name="action" value="add" />
                        <input type="hidden" name="courseId" value="${course.courseId}" />
                        <div class="mb-2">
                            <input type="text" name="title" class="form-control form-control-sm" placeholder="Title" required>
                        </div>
                        <div class="mb-2">
                            <textarea name="message" class="form-control form-control-sm" rows="3" placeholder="Share an update or notice with your students..." required></textarea>
                        </div>
                        <div class="text-end">
                            <button type="submit" class="btn btn-sm btn-primary">Post announcement</button>
                        </div>
                    </form>
                </div>

                <!-- Feed -->
                <c:forEach var="a" items="${announcements}">
                    <div class="card cc-card p-3 mb-3">
                        <div class="d-flex justify-content-between align-items-start mb-2">
                            <div>
                                <span class="fw-semibold text-dark"><c:out value="${a.title}" /></span>
                                <div class="text-muted small" style="font-size: 11px;">Posted by <c:out value="${a.postedByName}" /> &bull; <c:out value="${a.postedOn}" /></div>
                            </div>
                            <button type="button" class="btn btn-xs btn-outline-danger"
                                    data-confirm-message="Delete announcement?"
                                    data-confirm-action="${pageContext.request.contextPath}/admin/announcements?action=delete&announcementId=${a.announcementId}">
                                Delete
                            </button>
                        </div>
                        <p class="text-secondary small mb-0"><c:out value="${a.message}" /></p>
                    </div>
                </c:forEach>
                <c:if test="${empty announcements}">
                    <div class="text-center py-4 text-muted small bg-white border rounded">No announcements posted for this course.</div>
                </c:if>
            </div>

            <!-- 2. CLASSWORK TAB -->
            <div class="tab-pane fade" id="classwork" role="tabpanel">
                <div class="d-flex justify-content-between align-items-center mb-3">
                    <h2 class="h6 fw-semibold mb-0">Course materials & assignments</h2>
                    <div class="d-flex gap-2">
                        <button class="btn btn-sm btn-outline-primary" data-bs-toggle="modal" data-bs-target="#addMaterialModal">
                            <i class="bi bi-plus-lg me-1"></i>Add Material
                        </button>
                        <button class="btn btn-sm btn-primary" data-bs-toggle="modal" data-bs-target="#addAssignmentModal">
                            <i class="bi bi-plus-lg me-1"></i>Create Assignment
                        </button>
                    </div>
                </div>

                <!-- Materials Section -->
                <div class="card cc-card mb-4">
                    <h3 class="h6 fw-semibold text-secondary mb-3">Learning Materials</h3>
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
                                                    <a href="${m.filePath}" target="_blank" class="btn btn-xs btn-outline-secondary me-1">Open link</a>
                                                </c:when>
                                                <c:otherwise>
                                                    <a href="${pageContext.request.contextPath}/uploads/${m.filePath}" target="_blank" class="btn btn-xs btn-outline-secondary me-1">Download</a>
                                                </c:otherwise>
                                            </c:choose>
                                            <form action="${pageContext.request.contextPath}/faculty/material" method="post" class="d-inline">
                                                <input type="hidden" name="csrfToken" value="${sessionScope.csrfToken}" />
                                                <input type="hidden" name="action" value="delete" />
                                                <input type="hidden" name="courseId" value="${course.courseId}" />
                                                <input type="hidden" name="materialId" value="${m.materialId}" />
                                                <button type="submit" class="btn btn-xs btn-outline-danger">Delete</button>
                                            </form>
                                        </td>
                                    </tr>
                                </c:forEach>
                                <c:if test="${empty materials}">
                                    <tr>
                                        <td colspan="5" class="text-center text-muted py-3">No materials uploaded yet.</td>
                                    </tr>
                                </c:if>
                            </tbody>
                        </table>
                    </div>
                </div>

                <!-- Assignments Section -->
                <div class="card cc-card">
                    <h3 class="h6 fw-semibold text-secondary mb-3">Assignments</h3>
                    <div class="table-responsive border rounded">
                        <table class="table table-hover align-middle mb-0">
                            <thead>
                                <tr>
                                    <th>Week</th>
                                    <th>Title</th>
                                    <th>Due Date</th>
                                    <th>Max Marks</th>
                                    <th>Actions</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach var="as" items="${assignments}">
                                    <tr>
                                        <td class="tabular-nums fw-medium">Week <c:out value="${as.weekNo}" /></td>
                                        <td class="fw-medium"><c:out value="${as.title}" /></td>
                                        <td class="text-muted small"><c:out value="${as.dueDate}" /></td>
                                        <td class="tabular-nums"><c:out value="${as.maxMarks}" /></td>
                                        <td>
                                            <a href="${pageContext.request.contextPath}/faculty/grading?assignmentId=${as.assignmentId}" class="btn btn-xs btn-outline-primary">Evaluate submissions</a>
                                            <form action="${pageContext.request.contextPath}/faculty/assignment" method="post" class="d-inline ms-1">
                                                <input type="hidden" name="csrfToken" value="${sessionScope.csrfToken}" />
                                                <input type="hidden" name="action" value="delete" />
                                                <input type="hidden" name="courseId" value="${course.courseId}" />
                                                <input type="hidden" name="assignmentId" value="${as.assignmentId}" />
                                                <button type="submit" class="btn btn-xs btn-outline-danger">Delete</button>
                                            </form>
                                        </td>
                                    </tr>
                                </c:forEach>
                                <c:if test="${empty assignments}">
                                    <tr>
                                        <td colspan="5" class="text-center text-muted py-3">No assignments created yet.</td>
                                    </tr>
                                </c:if>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>

            <!-- 3. PEOPLE TAB -->
            <div class="tab-pane fade" id="people" role="tabpanel">
                <div class="card cc-card">
                    <h2 class="h6 fw-semibold mb-3">Enrolled Students (<c:out value="${enrollments.size()}" />)</h2>
                    <div class="table-responsive border rounded">
                        <table class="table table-hover align-middle mb-0">
                            <thead>
                                <tr>
                                    <th>Student ID</th>
                                    <th>Student Name</th>
                                    <th>Email</th>
                                    <th>Enrolled Date</th>
                                    <th>Status</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach var="e" items="${enrollments}">
                                    <tr>
                                        <td class="code-font text-muted"><c:out value="${e.studentId}" /></td>
                                        <td class="fw-medium"><c:out value="${e.studentName}" /></td>
                                        <td class="text-muted small"><c:out value="${e.studentEmail}" /></td>
                                        <td class="text-muted small"><c:out value="${e.enrolledOn}" /></td>
                                        <td><span class="cc-chip cc-chip-enrolled"><c:out value="${e.status}" /></span></td>
                                    </tr>
                                </c:forEach>
                                <c:if test="${empty enrollments}">
                                    <tr>
                                        <td colspan="5" class="text-center text-muted py-4">No students enrolled in this course.</td>
                                    </tr>
                                </c:if>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>

            <!-- 4. GRADES TAB (Gradebook Grid) -->
            <div class="tab-pane fade" id="grades" role="tabpanel">
                <div class="card cc-card">
                    <div class="d-flex justify-content-between align-items-center mb-3">
                        <h2 class="h6 fw-semibold mb-0">Course Gradebook Grid</h2>
                        <a href="${pageContext.request.contextPath}/admin/reports?export=csv&type=enrollment" class="btn btn-sm btn-outline-secondary">
                            <i class="bi bi-download me-1"></i>Export CSV
                        </a>
                    </div>

                    <div class="table-responsive border rounded">
                        <table class="table table-bordered table-hover align-middle mb-0">
                            <thead>
                                <tr>
                                    <th>Student Name</th>
                                    <c:forEach var="as" items="${assignments}">
                                        <th class="text-center"><c:out value="${as.title}" /><br><span class="fw-normal text-muted" style="font-size: 11px;">Max: <c:out value="${as.maxMarks}" /></span></th>
                                    </c:forEach>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach var="e" items="${enrollments}">
                                    <tr>
                                        <td class="fw-medium"><c:out value="${e.studentName}" /></td>
                                        <c:forEach var="as" items="${assignments}">
                                            <c:set var="subFound" value="false" />
                                            <c:set var="subMarks" value="-" />
                                            <c:forEach var="sub" items="${submissions}">
                                                <c:if test="${sub.assignmentId == as.assignmentId and sub.studentId == e.studentId}">
                                                    <c:set var="subFound" value="true" />
                                                    <c:set var="subMarks" value="${sub.graded ? sub.marksObtained : 'Needs grading'}" />
                                                </c:if>
                                            </c:forEach>
                                            <td class="text-center tabular-nums">
                                                <c:choose>
                                                    <c:when test="${subFound}">
                                                        <a href="${pageContext.request.contextPath}/faculty/grading?assignmentId=${as.assignmentId}&studentId=${e.studentId}" class="text-decoration-none fw-semibold ${subMarks == 'Needs grading' ? 'text-warning' : 'text-success'}">
                                                            <c:out value="${subMarks}" />
                                                        </a>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <span class="text-muted" style="font-size: 12px;">Not submitted</span>
                                                    </c:otherwise>
                                                </c:choose>
                                            </td>
                                        </c:forEach>
                                    </tr>
                                </c:forEach>
                                <c:if test="${empty enrollments}">
                                    <tr>
                                        <td colspan="${assignments.size() + 1}" class="text-center text-muted py-4">No grades available.</td>
                                    </tr>
                                </c:if>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>
        </div>
    </main>
</div>

<!-- Add Material Modal -->
<div class="modal fade" id="addMaterialModal" tabindex="-1" aria-hidden="true">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <h1 class="modal-title fs-6">Add Learning Material</h1>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <form action="${pageContext.request.contextPath}/faculty/material" method="post" enctype="multipart/form-data">
                <input type="hidden" name="csrfToken" value="${sessionScope.csrfToken}" />
                <input type="hidden" name="action" value="add" />
                <input type="hidden" name="courseId" value="${course.courseId}" />
                <div class="modal-body">
                    <div class="mb-3">
                        <label for="mtitle" class="form-label small fw-medium">Title <span class="text-muted">(required)</span></label>
                        <input type="text" id="mtitle" name="title" class="form-control" required>
                    </div>
                    <div class="row g-2 mb-3">
                        <div class="col-6">
                            <label for="mtype" class="form-label small fw-medium">Material Type</label>
                            <select id="mtype" name="type" class="form-select" onchange="document.getElementById('fileBox').style.display = this.value==='FILE'?'block':'none'; document.getElementById('linkBox').style.display = this.value==='LINK'?'block':'none';">
                                <option value="FILE">File Upload (PDF/Doc)</option>
                                <option value="LINK">External Link</option>
                            </select>
                        </div>
                        <div class="col-6">
                            <label for="mweek" class="form-label small fw-medium">Week Number</label>
                            <input type="number" id="mweek" name="weekNo" class="form-control" value="1" min="1">
                        </div>
                    </div>
                    <div class="mb-3" id="fileBox">
                        <label for="mfile" class="form-label small fw-medium">Select file</label>
                        <input type="file" id="mfile" name="file" class="form-control">
                    </div>
                    <div class="mb-3" id="linkBox" style="display: none;">
                        <label for="mlink" class="form-label small fw-medium">URL link</label>
                        <input type="url" id="mlink" name="linkUrl" class="form-control" placeholder="https://...">
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-sm btn-outline-secondary" data-bs-dismiss="modal">Cancel</button>
                    <button type="submit" class="btn btn-sm btn-primary">Add material</button>
                </div>
            </form>
        </div>
    </div>
</div>

<!-- Add Assignment Modal -->
<div class="modal fade" id="addAssignmentModal" tabindex="-1" aria-hidden="true">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <h1 class="modal-title fs-6">Create Assignment</h1>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <form action="${pageContext.request.contextPath}/faculty/assignment" method="post">
                <input type="hidden" name="csrfToken" value="${sessionScope.csrfToken}" />
                <input type="hidden" name="action" value="add" />
                <input type="hidden" name="courseId" value="${course.courseId}" />
                <div class="modal-body">
                    <div class="mb-3">
                        <label for="astitle" class="form-label small fw-medium">Assignment title <span class="text-muted">(required)</span></label>
                        <input type="text" id="astitle" name="title" class="form-control" required>
                    </div>
                    <div class="mb-3">
                        <label for="asdesc" class="form-label small fw-medium">Instructions / Description</label>
                        <textarea id="asdesc" name="description" class="form-control" rows="3"></textarea>
                    </div>
                    <div class="row g-2 mb-3">
                        <div class="col-4">
                            <label for="asdue" class="form-label small fw-medium">Due date <span class="text-muted">(required)</span></label>
                            <input type="date" id="asdue" name="dueDate" class="form-control" required>
                        </div>
                        <div class="col-4">
                            <label for="asmarks" class="form-label small fw-medium">Max marks</label>
                            <input type="number" id="asmarks" name="maxMarks" class="form-control" value="100" min="1">
                        </div>
                        <div class="col-4">
                            <label for="asweek" class="form-label small fw-medium">Week</label>
                            <input type="number" id="asweek" name="weekNo" class="form-control" value="1" min="1">
                        </div>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-sm btn-outline-secondary" data-bs-dismiss="modal">Cancel</button>
                    <button type="submit" class="btn btn-sm btn-primary">Create assignment</button>
                </div>
            </form>
        </div>
    </div>
</div>

<%@ include file="/common/confirmModal.jsp" %>
<%@ include file="/common/footer.jsp" %>
