<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<c:set var="pageTitle" value="Register" />
<%@ include file="/common/header.jsp" %>
<%@ include file="/common/navbar.jsp" %>

<main class="container py-5" style="max-width: 600px;">
    <div class="card cc-card">
        <h2 class="h5 fw-semibold mb-3">Create an account</h2>
        <%@ include file="/common/flash.jsp" %>

        <form action="${pageContext.request.contextPath}/register" method="post">
            <input type="hidden" name="csrfToken" value="${sessionScope.csrfToken}" />

            <div class="mb-3">
                <label class="form-label small fw-medium">I am registering as <span class="text-muted">(required)</span></label>
                <div class="row g-2">
                    <div class="col-6">
                        <input type="radio" class="btn-check" name="role" id="roleStudent" value="STUDENT" ${empty role or role == 'STUDENT' ? 'checked' : ''}>
                        <label class="btn btn-outline-secondary w-100 py-2 text-center" for="roleStudent">
                            <div class="fw-semibold">Student</div>
                            <div class="small text-muted" style="font-size: 11px;">Immediate access</div>
                        </label>
                    </div>
                    <div class="col-6">
                        <input type="radio" class="btn-check" name="role" id="roleFaculty" value="FACULTY" ${role == 'FACULTY' ? 'checked' : ''}>
                        <label class="btn btn-outline-secondary w-100 py-2 text-center" for="roleFaculty">
                            <div class="fw-semibold">Faculty</div>
                            <div class="small text-muted" style="font-size: 11px;">Requires admin approval</div>
                        </label>
                    </div>
                </div>
            </div>

            <div class="mb-3">
                <label for="name" class="form-label small fw-medium">Full name <span class="text-muted">(required)</span></label>
                <input type="text" id="name" name="name" class="form-control" value="${name}" required>
            </div>

            <div class="mb-3">
                <label for="email" class="form-label small fw-medium">Institutional email address <span class="text-muted">(required)</span></label>
                <input type="email" id="email" name="email" class="form-control" value="${email}" placeholder="user@coursecraft.edu" required>
            </div>

            <div class="mb-3">
                <label for="phone" class="form-label small fw-medium">Phone number</label>
                <input type="tel" id="phone" name="phone" class="form-control" value="${phone}">
            </div>

            <div class="mb-3">
                <label for="password" class="form-label small fw-medium">Password <span class="text-muted">(required, min 6 chars)</span></label>
                <input type="password" id="password" name="password" class="form-control" minlength="6" required>
            </div>

            <button type="submit" class="btn btn-primary w-100 mb-3">Submit registration</button>
            <div class="text-center small text-muted">
                Already registered? <a href="${pageContext.request.contextPath}/login">Sign in</a>
            </div>
        </form>
    </div>
</main>

<%@ include file="/common/footer.jsp" %>
