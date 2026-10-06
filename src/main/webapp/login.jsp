<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<c:set var="pageTitle" value="Sign in" />
<%@ include file="/common/header.jsp" %>
<%@ include file="/common/navbar.jsp" %>

<main class="container py-5" style="max-width: 900px;">
    <div class="row g-0 border rounded bg-white overflow-hidden">
        <!-- Left Solid Panel -->
        <div class="col-md-5 p-4 text-white d-flex flex-column justify-content-between" style="background-color: var(--cc-accent);">
            <div>
                <h2 class="h4 fw-bold mb-3 text-white">CourseCraft</h2>
                <p class="small text-white-50">
                    Online Course Management System for the Department of Computer Science.
                </p>
            </div>
            <div class="small text-white-50">
                Authorized access only. All actions are logged.
            </div>
        </div>

        <!-- Right Form Panel -->
        <div class="col-md-7 p-4">
            <h3 class="h5 fw-semibold mb-3">Sign in to your account</h3>
            <%@ include file="/common/flash.jsp" %>

            <form action="${pageContext.request.contextPath}/login" method="post">
                <input type="hidden" name="csrfToken" value="${sessionScope.csrfToken}" />
                
                <div class="mb-3">
                    <label for="email" class="form-label small fw-medium">Email address <span class="text-muted">(required)</span></label>
                    <input type="email" id="email" name="email" class="form-control" value="${email}" required autofocus>
                </div>

                <div class="mb-3">
                    <label for="password" class="form-label small fw-medium">Password <span class="text-muted">(required)</span></label>
                    <div class="input-group">
                        <input type="password" id="password" name="password" class="form-control" required>
                        <button class="btn btn-outline-secondary" type="button" id="togglePass" aria-label="Toggle password visibility">
                            <i class="bi bi-eye" id="togglePassIcon"></i>
                        </button>
                    </div>
                </div>

                <button type="submit" class="btn btn-primary w-100 mb-3">Sign in</button>
                <div class="text-center small text-muted">
                    Do not have an account? <a href="${pageContext.request.contextPath}/register">Register here</a>
                </div>
            </form>

            <!-- Demo Credentials Box -->
            <div class="mt-4 p-3 border rounded bg-light">
                <div class="fw-semibold small mb-2 text-secondary">Demo accounts for evaluation</div>
                <div class="d-flex flex-wrap gap-2">
                    <button type="button" class="btn btn-xs btn-outline-secondary btn-demo" data-email="admin@coursecraft.edu" data-pass="admin123">
                        Admin
                    </button>
                    <button type="button" class="btn btn-xs btn-outline-secondary btn-demo" data-email="meera.iyer@coursecraft.edu" data-pass="faculty123">
                        Faculty
                    </button>
                    <button type="button" class="btn btn-xs btn-outline-secondary btn-demo" data-email="ananya.gupta@coursecraft.edu" data-pass="student123">
                        Student
                    </button>
                </div>
            </div>
        </div>
    </div>
</main>

<script>
document.addEventListener('DOMContentLoaded', function() {
    const passInput = document.getElementById('password');
    const toggleBtn = document.getElementById('togglePass');
    const toggleIcon = document.getElementById('togglePassIcon');

    if (toggleBtn && passInput) {
        toggleBtn.addEventListener('click', function() {
            const isPass = passInput.type === 'password';
            passInput.type = isPass ? 'text' : 'password';
            toggleIcon.className = isPass ? 'bi bi-eye-slash' : 'bi bi-eye';
        });
    }

    document.querySelectorAll('.btn-demo').forEach(function(btn) {
        btn.addEventListener('click', function() {
            document.getElementById('email').value = this.getAttribute('data-email');
            document.getElementById('password').value = this.getAttribute('data-pass');
        });
    });
});
</script>

<%@ include file="/common/footer.jsp" %>
