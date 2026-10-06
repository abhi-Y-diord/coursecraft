<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<c:set var="pageTitle" value="Course Management" />
<c:set var="activeNav" value="courses" />
<%@ include file="/common/header.jsp" %>
<%@ include file="/common/navbar.jsp" %>

<div class="d-flex">
    <%@ include file="/common/sidebar.jsp" %>
    <main class="app-content">
        <div class="d-flex justify-content-between align-items-center mb-3">
            <h1 class="page-title">Course Management</h1>
            <button class="btn btn-sm btn-primary" data-bs-toggle="modal" data-bs-target="#addCourseModal">Add new course</button>
        </div>
        <%@ include file="/common/flash.jsp" %>

        <!-- Filter Bar -->
        <div class="card cc-card py-2 mb-3">
            <form action="${pageContext.request.contextPath}/admin/courses" method="get" class="row g-2 align-items-center">
                <div class="col-md-5">
                    <input type="text" name="q" class="form-control form-control-sm" placeholder="Search course code, title..." value="${param.q}">
                </div>
                <div class="col-md-3">
                    <select name="cat" class="form-select form-select-sm">
                        <option value="">All categories</option>
                        <c:forEach var="cat" items="${categories}">
                            <option value="${cat.categoryId}" ${param.cat == cat.categoryId ? 'selected' : ''}><c:out value="${cat.name}" /></option>
                        </c:forEach>
                    </select>
                </div>
                <div class="col-md-2">
                    <button type="submit" class="btn btn-sm btn-outline-secondary w-100">Filter</button>
                </div>
                <div class="col-md-2">
                    <a href="${pageContext.request.contextPath}/admin/courses" class="btn btn-sm btn-link text-secondary w-100">Clear</a>
                </div>
            </form>
        </div>

        <!-- Course Table -->
        <div class="table-responsive bg-white border rounded">
            <table class="table table-hover align-middle mb-0">
                <thead>
                    <tr>
                        <th>Code</th>
                        <th>Title</th>
                        <th>Category</th>
                        <th>Instructor</th>
                        <th>Capacity</th>
                        <th>Enrolled</th>
                        <th>Duration</th>
                        <th>Actions</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach var="c" items="${pageObj.items}">
                        <tr>
                            <td class="code-font fw-semibold"><c:out value="${c.courseCode}" /></td>
                            <td class="fw-medium"><c:out value="${c.title}" /></td>
                            <td class="text-muted small"><c:out value="${c.categoryName}" /></td>
                            <td><c:out value="${c.facultyName != null ? c.facultyName : 'Unassigned'}" /></td>
                            <td class="tabular-nums"><c:out value="${c.capacity}" /></td>
                            <td class="tabular-nums fw-medium"><c:out value="${c.enrolledCount}" /></td>
                            <td class="tabular-nums text-muted small"><c:out value="${c.durationWeeks}" /> weeks</td>
                            <td>
                                <button type="button" class="btn btn-xs btn-outline-secondary btn-edit-course"
                                        data-id="${c.courseId}"
                                        data-code="${c.courseCode}"
                                        data-title="${c.title}"
                                        data-desc="${c.description}"
                                        data-cat="${c.categoryId}"
                                        data-fac="${c.facultyId}"
                                        data-cap="${c.capacity}"
                                        data-dur="${c.durationWeeks}"
                                        data-bs-toggle="modal" data-bs-target="#editCourseModal">
                                    Edit
                                </button>
                                <button type="button" class="btn btn-xs btn-outline-danger ms-1"
                                        data-confirm-message="Delete course ${c.courseCode}? This removes 24 enrolments and all assignments."
                                        data-confirm-action="${pageContext.request.contextPath}/admin/courses?action=delete&courseId=${c.courseId}">
                                    Delete
                                </button>
                            </td>
                        </tr>
                    </c:forEach>
                    <c:if test="${empty pageObj.items}">
                        <tr>
                            <td colspan="8" class="text-center text-muted py-4">No courses found.</td>
                        </tr>
                    </c:if>
                </tbody>
            </table>
        </div>

        <%@ include file="/common/pagination.jsp" %>
    </main>
</div>

<!-- Add Course Modal -->
<div class="modal fade" id="addCourseModal" tabindex="-1" aria-labelledby="addCourseModalLabel" aria-hidden="true">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <h1 class="modal-title fs-6" id="addCourseModalLabel">Add new course</h1>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <form action="${pageContext.request.contextPath}/admin/courses" method="post">
                <input type="hidden" name="csrfToken" value="${sessionScope.csrfToken}" />
                <input type="hidden" name="action" value="add" />
                <div class="modal-body">
                    <div class="mb-3">
                        <label for="acode" class="form-label small fw-medium">Course code <span class="text-muted">(required, e.g. CS201)</span></label>
                        <input type="text" id="acode" name="courseCode" class="form-control code-font" required placeholder="CS201">
                    </div>
                    <div class="mb-3">
                        <label for="atitle" class="form-label small fw-medium">Course title <span class="text-muted">(required)</span></label>
                        <input type="text" id="atitle" name="title" class="form-control" required>
                    </div>
                    <div class="mb-3">
                        <label for="adesc" class="form-label small fw-medium">Description</label>
                        <textarea id="adesc" name="description" class="form-control" rows="3"></textarea>
                    </div>
                    <div class="row g-2 mb-3">
                        <div class="col-6">
                            <label for="acat" class="form-label small fw-medium">Category</label>
                            <select id="acat" name="categoryId" class="form-select">
                                <option value="">Select category</option>
                                <c:forEach var="cat" items="${categories}">
                                    <option value="${cat.categoryId}"><c:out value="${cat.name}" /></option>
                                </c:forEach>
                            </select>
                        </div>
                        <div class="col-6">
                            <label for="afac" class="form-label small fw-medium">Assigned faculty</label>
                            <select id="afac" name="facultyId" class="form-select">
                                <option value="">Select faculty</option>
                                <c:forEach var="f" items="${facultyList}">
                                    <c:if test="${f.status == 'ACTIVE'}">
                                        <option value="${f.userId}"><c:out value="${f.name}" /></option>
                                    </c:if>
                                </c:forEach>
                            </select>
                        </div>
                    </div>
                    <div class="row g-2 mb-3">
                        <div class="col-6">
                            <label for="acap" class="form-label small fw-medium">Seat capacity</label>
                            <input type="number" id="acap" name="capacity" class="form-control" value="30" min="1">
                        </div>
                        <div class="col-6">
                            <label for="adur" class="form-label small fw-medium">Duration (weeks)</label>
                            <input type="number" id="adur" name="durationWeeks" class="form-control" value="8" min="1">
                        </div>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-sm btn-outline-secondary" data-bs-dismiss="modal">Cancel</button>
                    <button type="submit" class="btn btn-sm btn-primary">Save course</button>
                </div>
            </form>
        </div>
    </div>
</div>

<!-- Edit Course Modal -->
<div class="modal fade" id="editCourseModal" tabindex="-1" aria-labelledby="editCourseModalLabel" aria-hidden="true">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <h1 class="modal-title fs-6" id="editCourseModalLabel">Edit course</h1>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <form action="${pageContext.request.contextPath}/admin/courses" method="post">
                <input type="hidden" name="csrfToken" value="${sessionScope.csrfToken}" />
                <input type="hidden" name="action" value="edit" />
                <input type="hidden" id="ecodeId" name="courseId" />
                <div class="modal-body">
                    <div class="mb-3">
                        <label for="ecode" class="form-label small fw-medium">Course code <span class="text-muted">(required)</span></label>
                        <input type="text" id="ecode" name="courseCode" class="form-control code-font" required>
                    </div>
                    <div class="mb-3">
                        <label for="etitle" class="form-label small fw-medium">Course title <span class="text-muted">(required)</span></label>
                        <input type="text" id="etitle" name="title" class="form-control" required>
                    </div>
                    <div class="mb-3">
                        <label for="edesc" class="form-label small fw-medium">Description</label>
                        <textarea id="edesc" name="description" class="form-control" rows="3"></textarea>
                    </div>
                    <div class="row g-2 mb-3">
                        <div class="col-6">
                            <label for="ecat" class="form-label small fw-medium">Category</label>
                            <select id="ecat" name="categoryId" class="form-select">
                                <option value="">Select category</option>
                                <c:forEach var="cat" items="${categories}">
                                    <option value="${cat.categoryId}"><c:out value="${cat.name}" /></option>
                                </c:forEach>
                            </select>
                        </div>
                        <div class="col-6">
                            <label for="efac" class="form-label small fw-medium">Assigned faculty</label>
                            <select id="efac" name="facultyId" class="form-select">
                                <option value="">Select faculty</option>
                                <c:forEach var="f" items="${facultyList}">
                                    <c:if test="${f.status == 'ACTIVE'}">
                                        <option value="${f.userId}"><c:out value="${f.name}" /></option>
                                    </c:if>
                                </c:forEach>
                            </select>
                        </div>
                    </div>
                    <div class="row g-2 mb-3">
                        <div class="col-6">
                            <label for="ecap" class="form-label small fw-medium">Seat capacity</label>
                            <input type="number" id="ecap" name="capacity" class="form-control" min="1">
                        </div>
                        <div class="col-6">
                            <label for="edur" class="form-label small fw-medium">Duration (weeks)</label>
                            <input type="number" id="edur" name="durationWeeks" class="form-control" min="1">
                        </div>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-sm btn-outline-secondary" data-bs-dismiss="modal">Cancel</button>
                    <button type="submit" class="btn btn-sm btn-primary">Save changes</button>
                </div>
            </form>
        </div>
    </div>
</div>

<script>
document.addEventListener('DOMContentLoaded', function() {
    document.querySelectorAll('.btn-edit-course').forEach(function(btn) {
        btn.addEventListener('click', function() {
            document.getElementById('ecodeId').value = this.getAttribute('data-id');
            document.getElementById('ecode').value = this.getAttribute('data-code');
            document.getElementById('etitle').value = this.getAttribute('data-title');
            document.getElementById('edesc').value = this.getAttribute('data-desc');
            document.getElementById('ecat').value = this.getAttribute('data-cat') || '';
            document.getElementById('efac').value = this.getAttribute('data-fac') || '';
            document.getElementById('ecap').value = this.getAttribute('data-cap');
            document.getElementById('edur').value = this.getAttribute('data-dur');
        });
    });
});
</script>

<%@ include file="/common/confirmModal.jsp" %>
<%@ include file="/common/footer.jsp" %>
