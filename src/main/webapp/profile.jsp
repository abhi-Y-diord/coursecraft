<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<c:set var="pageTitle" value="User Profile" />
<c:set var="activeNav" value="profile" />
<%@ include file="/common/header.jsp" %>
<%@ include file="/common/navbar.jsp" %>

<div class="d-flex">
    <%@ include file="/common/sidebar.jsp" %>
    <main class="app-content">
        <h1 class="page-title mb-3">User profile</h1>
        <%@ include file="/common/flash.jsp" %>

        <div class="row g-4">
            <div class="col-md-6">
                <div class="card cc-card">
                    <h2 class="h6 fw-semibold mb-3">Profile information</h2>
                    <form action="${pageContext.request.contextPath}/profile" method="post">
                        <input type="hidden" name="csrfToken" value="${sessionScope.csrfToken}" />
                        <input type="hidden" name="action" value="updateProfile" />

                        <div class="mb-3">
                            <label class="form-label small fw-medium">User ID</label>
                            <input type="text" class="form-control code-font" value="${sessionScope.user.userId}" disabled>
                        </div>
                        <div class="mb-3">
                            <label class="form-label small fw-medium">Email address</label>
                            <input type="email" class="form-control" value="${sessionScope.user.email}" disabled>
                        </div>
                        <div class="mb-3">
                            <label class="form-label small fw-medium">Role</label>
                            <input type="text" class="form-control" value="${sessionScope.user.role}" disabled>
                        </div>
                        <div class="mb-3">
                            <label for="name" class="form-label small fw-medium">Full name <span class="text-muted">(required)</span></label>
                            <input type="text" id="name" name="name" class="form-control" value="${sessionScope.user.name}" required>
                        </div>
                        <div class="mb-3">
                            <label for="phone" class="form-label small fw-medium">Phone number</label>
                            <input type="tel" id="phone" name="phone" class="form-control" value="${sessionScope.user.phone}">
                        </div>

                        <button type="submit" class="btn btn-sm btn-primary">Save changes</button>
                    </form>
                </div>
            </div>

            <div class="col-md-6">
                <div class="card cc-card">
                    <h2 class="h6 fw-semibold mb-3">Change password</h2>
                    <form action="${pageContext.request.contextPath}/profile" method="post">
                        <input type="hidden" name="csrfToken" value="${sessionScope.csrfToken}" />
                        <input type="hidden" name="action" value="changePassword" />

                        <div class="mb-3">
                            <label for="currentPassword" class="form-label small fw-medium">Current password <span class="text-muted">(required)</span></label>
                            <input type="password" id="currentPassword" name="currentPassword" class="form-control" required>
                        </div>
                        <div class="mb-3">
                            <label for="newPassword" class="form-label small fw-medium">New password <span class="text-muted">(min 6 chars)</span></label>
                            <input type="password" id="newPassword" name="newPassword" class="form-control" minlength="6" required>
                        </div>
                        <div class="mb-3">
                            <label for="confirmPassword" class="form-label small fw-medium">Confirm new password <span class="text-muted">(required)</span></label>
                            <input type="password" id="confirmPassword" name="confirmPassword" class="form-control" minlength="6" required>
                        </div>

                        <button type="submit" class="btn btn-sm btn-primary">Update password</button>
                    </form>
                </div>
            </div>
        </div>
    </main>
</div>

<%@ include file="/common/footer.jsp" %>
