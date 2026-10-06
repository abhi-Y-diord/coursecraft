<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<c:set var="pageTitle" value="Student Management" />
<c:set var="activeNav" value="students" />
<%@ include file="/common/header.jsp" %>
<%@ include file="/common/navbar.jsp" %>

<div class="d-flex">
    <%@ include file="/common/sidebar.jsp" %>
    <main class="app-content">
        <div class="d-flex justify-content-between align-items-center mb-3">
            <h1 class="page-title">Student Accounts</h1>
            <button class="btn btn-sm btn-primary" data-bs-toggle="modal" data-bs-target="#addStudentModal">Add student account</button>
        </div>
        <%@ include file="/common/flash.jsp" %>

        <!-- Filter Bar -->
        <div class="card cc-card py-2 mb-3">
            <form action="${pageContext.request.contextPath}/admin/students" method="get" class="row g-2 align-items-center">
                <div class="col-md-5">
                    <input type="text" name="q" class="form-control form-control-sm" placeholder="Search name, email or phone..." value="${param.q}">
                </div>
                <div class="col-md-3">
                    <select name="status" class="form-select form-select-sm">
                        <option value="">All statuses</option>
                        <option value="ACTIVE" ${param.status == 'ACTIVE' ? 'selected' : ''}>ACTIVE</option>
                        <option value="DISABLED" ${param.status == 'DISABLED' ? 'selected' : ''}>DISABLED</option>
                    </select>
                </div>
                <div class="col-md-2">
                    <button type="submit" class="btn btn-sm btn-outline-secondary w-100">Filter</button>
                </div>
                <div class="col-md-2">
                    <a href="${pageContext.request.contextPath}/admin/students" class="btn btn-sm btn-link text-secondary w-100">Clear</a>
                </div>
            </form>
        </div>

        <!-- Student Table -->
        <div class="table-responsive bg-white border rounded">
            <table class="table table-hover align-middle mb-0">
                <thead>
                    <tr>
                        <th>ID</th>
                        <th>Name</th>
                        <th>Email</th>
                        <th>Phone</th>
                        <th>Status</th>
                        <th>Registered</th>
                        <th>Actions</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach var="s" items="${pageObj.items}">
                        <tr>
                            <td class="code-font text-muted"><c:out value="${s.userId}" /></td>
                            <td class="fw-medium"><c:out value="${s.name}" /></td>
                            <td><c:out value="${s.email}" /></td>
                            <td class="code-font"><c:out value="${s.phone}" /></td>
                            <td>
                                <span class="cc-chip ${s.status == 'ACTIVE' ? 'cc-chip-active' : 'cc-chip-disabled'}">
                                    <c:out value="${s.status}" />
                                </span>
                            </td>
                            <td class="text-muted small"><c:out value="${s.createdAt}" /></td>
                            <td>
                                <form action="${pageContext.request.contextPath}/admin/students" method="post" class="d-inline">
                                    <input type="hidden" name="csrfToken" value="${sessionScope.csrfToken}" />
                                    <input type="hidden" name="action" value="updateStatus" />
                                    <input type="hidden" name="userId" value="${s.userId}" />
                                    <input type="hidden" name="status" value="${s.status == 'ACTIVE' ? 'DISABLED' : 'ACTIVE'}" />
                                    <button type="submit" class="btn btn-xs btn-outline-secondary">
                                        <c:out value="${s.status == 'ACTIVE' ? 'Disable' : 'Enable'}" />
                                    </button>
                                </form>
                                <button type="button" class="btn btn-xs btn-outline-danger ms-1"
                                        data-confirm-message="Delete student account ${s.name}? This will remove all their enrollments and submissions."
                                        data-confirm-action="${pageContext.request.contextPath}/admin/students?action=delete&userId=${s.userId}">
                                    Delete
                                </button>
                            </td>
                        </tr>
                    </c:forEach>
                    <c:if test="${empty pageObj.items}">
                        <tr>
                            <td colspan="7" class="text-center text-muted py-4">No student accounts found.</td>
                        </tr>
                    </c:if>
                </tbody>
            </table>
        </div>

        <%@ include file="/common/pagination.jsp" %>
    </main>
</div>

<!-- Add Student Modal -->
<div class="modal fade" id="addStudentModal" tabindex="-1" aria-labelledby="addStudentModalLabel" aria-hidden="true">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <h1 class="modal-title fs-6" id="addStudentModalLabel">Add student account</h1>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <form action="${pageContext.request.contextPath}/admin/students" method="post">
                <input type="hidden" name="csrfToken" value="${sessionScope.csrfToken}" />
                <input type="hidden" name="action" value="add" />
                <div class="modal-body">
                    <div class="mb-3">
                        <label for="sname" class="form-label small fw-medium">Full name <span class="text-muted">(required)</span></label>
                        <input type="text" id="sname" name="name" class="form-control" required>
                    </div>
                    <div class="mb-3">
                        <label for="semail" class="form-label small fw-medium">Email address <span class="text-muted">(required)</span></label>
                        <input type="email" id="semail" name="email" class="form-control" placeholder="user@coursecraft.edu" required>
                    </div>
                    <div class="mb-3">
                        <label for="sphone" class="form-label small fw-medium">Phone number</label>
                        <input type="tel" id="sphone" name="phone" class="form-control">
                    </div>
                    <div class="mb-3">
                        <label for="spassword" class="form-label small fw-medium">Initial password <span class="text-muted">(required)</span></label>
                        <input type="password" id="spassword" name="password" class="form-control" minlength="6" required>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-sm btn-outline-secondary" data-bs-dismiss="modal">Cancel</button>
                    <button type="submit" class="btn btn-sm btn-primary">Create student account</button>
                </div>
            </form>
        </div>
    </div>
</div>

<%@ include file="/common/confirmModal.jsp" %>
<%@ include file="/common/footer.jsp" %>
