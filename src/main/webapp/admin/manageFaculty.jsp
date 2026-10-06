<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<c:set var="pageTitle" value="Faculty Management" />
<c:set var="activeNav" value="faculty" />
<%@ include file="/common/header.jsp" %>
<%@ include file="/common/navbar.jsp" %>

<div class="d-flex">
    <%@ include file="/common/sidebar.jsp" %>
    <main class="app-content">
        <div class="d-flex justify-content-between align-items-center mb-3">
            <h1 class="page-title">Faculty Accounts</h1>
            <button class="btn btn-sm btn-primary" data-bs-toggle="modal" data-bs-target="#addFacultyModal">Add faculty member</button>
        </div>
        <%@ include file="/common/flash.jsp" %>

        <!-- Toolbar Filter Form -->
        <div class="card cc-card py-2 mb-3">
            <form action="${pageContext.request.contextPath}/admin/faculty" method="get" class="row g-2 align-items-center">
                <div class="col-md-5">
                    <input type="text" name="q" class="form-control form-control-sm" placeholder="Search name, email or phone..." value="${param.q}">
                </div>
                <div class="col-md-3">
                    <select name="status" class="form-select form-select-sm">
                        <option value="">All statuses</option>
                        <option value="ACTIVE" ${param.status == 'ACTIVE' ? 'selected' : ''}>ACTIVE</option>
                        <option value="PENDING" ${param.status == 'PENDING' ? 'selected' : ''}>PENDING</option>
                        <option value="DISABLED" ${param.status == 'DISABLED' ? 'selected' : ''}>DISABLED</option>
                    </select>
                </div>
                <div class="col-md-2">
                    <button type="submit" class="btn btn-sm btn-outline-secondary w-100">Filter</button>
                </div>
                <div class="col-md-2">
                    <a href="${pageContext.request.contextPath}/admin/faculty" class="btn btn-sm btn-link text-secondary w-100">Clear</a>
                </div>
            </form>
        </div>

        <!-- Faculty Table -->
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
                    <c:forEach var="f" items="${pageObj.items}">
                        <tr>
                            <td class="code-font text-muted"><c:out value="${f.userId}" /></td>
                            <td class="fw-medium"><c:out value="${f.name}" /></td>
                            <td><c:out value="${f.email}" /></td>
                            <td class="code-font"><c:out value="${f.phone}" /></td>
                            <td>
                                <span class="cc-chip ${f.status == 'ACTIVE' ? 'cc-chip-active' : (f.status == 'PENDING' ? 'cc-chip-pending' : 'cc-chip-disabled')}">
                                    <c:out value="${f.status}" />
                                </span>
                            </td>
                            <td class="text-muted small"><c:out value="${f.createdAt}" /></td>
                            <td>
                                <c:if test="${f.status == 'PENDING'}">
                                    <form action="${pageContext.request.contextPath}/admin/faculty" method="post" class="d-inline">
                                        <input type="hidden" name="csrfToken" value="${sessionScope.csrfToken}" />
                                        <input type="hidden" name="action" value="updateStatus" />
                                        <input type="hidden" name="userId" value="${f.userId}" />
                                        <input type="hidden" name="status" value="ACTIVE" />
                                        <button type="submit" class="btn btn-xs btn-outline-success">Approve</button>
                                    </form>
                                </c:if>
                                <c:if test="${f.status == 'ACTIVE'}">
                                    <form action="${pageContext.request.contextPath}/admin/faculty" method="post" class="d-inline">
                                        <input type="hidden" name="csrfToken" value="${sessionScope.csrfToken}" />
                                        <input type="hidden" name="action" value="updateStatus" />
                                        <input type="hidden" name="userId" value="${f.userId}" />
                                        <input type="hidden" name="status" value="DISABLED" />
                                        <button type="submit" class="btn btn-xs btn-outline-warning">Disable</button>
                                    </form>
                                </c:if>
                                <button type="button" class="btn btn-xs btn-outline-danger ms-1"
                                        data-confirm-message="Delete faculty member ${f.name}? This action cannot be undone."
                                        data-confirm-action="${pageContext.request.contextPath}/admin/faculty?action=delete&userId=${f.userId}">
                                    Delete
                                </button>
                            </td>
                        </tr>
                    </c:forEach>
                    <c:if test="${empty pageObj.items}">
                        <tr>
                            <td colspan="7" class="text-center text-muted py-4">No faculty members found.</td>
                        </tr>
                    </c:if>
                </tbody>
            </table>
        </div>

        <%@ include file="/common/pagination.jsp" %>
    </main>
</div>

<!-- Add Faculty Modal -->
<div class="modal fade" id="addFacultyModal" tabindex="-1" aria-labelledby="addFacultyModalLabel" aria-hidden="true">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <h1 class="modal-title fs-6" id="addFacultyModalLabel">Add faculty member</h1>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <form action="${pageContext.request.contextPath}/admin/faculty" method="post">
                <input type="hidden" name="csrfToken" value="${sessionScope.csrfToken}" />
                <input type="hidden" name="action" value="add" />
                <div class="modal-body">
                    <div class="mb-3">
                        <label for="name" class="form-label small fw-medium">Full name <span class="text-muted">(required)</span></label>
                        <input type="text" id="name" name="name" class="form-control" required>
                    </div>
                    <div class="mb-3">
                        <label for="email" class="form-label small fw-medium">Email address <span class="text-muted">(required)</span></label>
                        <input type="email" id="email" name="email" class="form-control" placeholder="user@coursecraft.edu" required>
                    </div>
                    <div class="mb-3">
                        <label for="phone" class="form-label small fw-medium">Phone number</label>
                        <input type="tel" id="phone" name="phone" class="form-control">
                    </div>
                    <div class="mb-3">
                        <label for="password" class="form-label small fw-medium">Initial password <span class="text-muted">(required)</span></label>
                        <input type="password" id="password" name="password" class="form-control" minlength="6" required>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-sm btn-outline-secondary" data-bs-dismiss="modal">Cancel</button>
                    <button type="submit" class="btn btn-sm btn-primary">Create faculty account</button>
                </div>
            </form>
        </div>
    </div>
</div>

<%@ include file="/common/confirmModal.jsp" %>
<%@ include file="/common/footer.jsp" %>
