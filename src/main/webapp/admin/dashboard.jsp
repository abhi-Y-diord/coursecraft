<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<c:set var="pageTitle" value="Admin Dashboard" />
<c:set var="activeNav" value="dashboard" />
<%@ include file="/common/header.jsp" %>
<%@ include file="/common/navbar.jsp" %>

<div class="d-flex">
    <%@ include file="/common/sidebar.jsp" %>
    <main class="app-content">
        <h1 class="page-title mb-3">Admin Dashboard</h1>
        <%@ include file="/common/flash.jsp" %>

        <!-- Summary Strip (Plain numbers, vertical rules, no icons) -->
        <div class="summary-strip">
            <a href="${pageContext.request.contextPath}/admin/students" class="summary-item">
                <span class="summary-label">Students</span>
                <span class="summary-number tabular-nums"><c:out value="${totalStudents}" /></span>
            </a>
            <a href="${pageContext.request.contextPath}/admin/faculty" class="summary-item">
                <span class="summary-label">Faculty</span>
                <span class="summary-number tabular-nums"><c:out value="${totalFaculty}" /></span>
            </a>
            <a href="${pageContext.request.contextPath}/admin/courses" class="summary-item">
                <span class="summary-label">Courses</span>
                <span class="summary-number tabular-nums"><c:out value="${totalCourses}" /></span>
            </a>
            <a href="${pageContext.request.contextPath}/admin/enrollments" class="summary-item">
                <span class="summary-label">Active Enrollments</span>
                <span class="summary-number tabular-nums"><c:out value="${activeEnrollments}" /></span>
            </a>
        </div>

        <!-- Needs Attention Panel -->
        <div class="card cc-card">
            <h2 class="section-title">Needs attention</h2>
            
            <c:if test="${not empty pendingFaculty}">
                <div class="mb-3">
                    <div class="fw-medium text-dark small mb-2">Pending faculty registration approvals</div>
                    <div class="table-responsive border rounded">
                        <table class="table table-sm align-middle mb-0">
                            <thead>
                                <tr>
                                    <th>Name</th>
                                    <th>Email</th>
                                    <th>Phone</th>
                                    <th>Registered</th>
                                    <th>Action</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach var="f" items="${pendingFaculty}">
                                    <tr>
                                        <td class="fw-medium"><c:out value="${f.name}" /></td>
                                        <td><c:out value="${f.email}" /></td>
                                        <td class="code-font"><c:out value="${f.phone}" /></td>
                                        <td class="text-muted small"><c:out value="${f.createdAt}" /></td>
                                        <td>
                                            <form action="${pageContext.request.contextPath}/admin/faculty" method="post" class="d-inline">
                                                <input type="hidden" name="csrfToken" value="${sessionScope.csrfToken}" />
                                                <input type="hidden" name="action" value="updateStatus" />
                                                <input type="hidden" name="userId" value="${f.userId}" />
                                                <input type="hidden" name="status" value="ACTIVE" />
                                                <button type="submit" class="btn btn-xs btn-outline-success">Approve</button>
                                            </form>
                                            <form action="${pageContext.request.contextPath}/admin/faculty" method="post" class="d-inline ms-1">
                                                <input type="hidden" name="csrfToken" value="${sessionScope.csrfToken}" />
                                                <input type="hidden" name="action" value="updateStatus" />
                                                <input type="hidden" name="userId" value="${f.userId}" />
                                                <input type="hidden" name="status" value="DISABLED" />
                                                <button type="submit" class="btn btn-xs btn-outline-danger">Reject</button>
                                            </form>
                                        </td>
                                    </tr>
                                </c:forEach>
                            </tbody>
                        </table>
                    </div>
                </div>
            </c:if>

            <c:if test="${not empty unassignedCourses}">
                <div class="mb-3">
                    <div class="fw-medium text-dark small mb-2">Courses without assigned faculty</div>
                    <div class="table-responsive border rounded">
                        <table class="table table-sm align-middle mb-0">
                            <thead>
                                <tr>
                                    <th>Code</th>
                                    <th>Title</th>
                                    <th>Category</th>
                                    <th>Action</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach var="uc" items="${unassignedCourses}">
                                    <tr>
                                        <td class="code-font fw-semibold"><c:out value="${uc.courseCode}" /></td>
                                        <td><c:out value="${uc.title}" /></td>
                                        <td class="text-muted"><c:out value="${uc.categoryName}" /></td>
                                        <td>
                                            <a href="${pageContext.request.contextPath}/admin/courses?action=edit&id=${uc.courseId}" class="btn btn-xs btn-outline-primary">Assign faculty</a>
                                        </td>
                                    </tr>
                                </c:forEach>
                            </tbody>
                        </table>
                    </div>
                </div>
            </c:if>

            <c:if test="${empty pendingFaculty and empty unassignedCourses}">
                <p class="text-muted small mb-0">No pending approvals or unassigned courses requiring attention.</p>
            </c:if>
        </div>

        <!-- Analytics Charts (Maximum 2 honest, labelled charts) -->
        <div class="row g-4 mb-4">
            <div class="col-md-6">
                <div class="card cc-card">
                    <h2 class="section-title">Enrolments per month, last 6 months</h2>
                    <div style="height: 220px;">
                        <canvas id="enrolmentChart"></canvas>
                    </div>
                </div>
            </div>
            <div class="col-md-6">
                <div class="card cc-card">
                    <h2 class="section-title">Seat utilisation per course</h2>
                    <div style="height: 220px;">
                        <canvas id="utilisationChart"></canvas>
                    </div>
                </div>
            </div>
        </div>

        <!-- Recent Enrollments -->
        <div class="card cc-card">
            <div class="d-flex justify-content-between align-items-center mb-3">
                <h2 class="section-title mb-0">Recent enrollments</h2>
                <a href="${pageContext.request.contextPath}/admin/enrollments" class="btn btn-sm btn-outline-primary">View all enrollments</a>
            </div>
            <div class="table-responsive border rounded">
                <table class="table table-sm align-middle mb-0">
                    <thead>
                        <tr>
                            <th>Student</th>
                            <th>Email</th>
                            <th>Course Code</th>
                            <th>Course Title</th>
                            <th>Date</th>
                            <th>Status</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="e" items="${recentEnrollments}">
                            <tr>
                                <td class="fw-medium"><c:out value="${e.studentName}" /></td>
                                <td class="text-muted small"><c:out value="${e.studentEmail}" /></td>
                                <td class="code-font"><c:out value="${e.courseCode}" /></td>
                                <td><c:out value="${e.courseTitle}" /></td>
                                <td class="text-muted small"><c:out value="${e.enrolledOn}" /></td>
                                <td><span class="cc-chip cc-chip-enrolled"><c:out value="${e.status}" /></span></td>
                            </tr>
                        </c:forEach>
                        <c:if test="${empty recentEnrollments}">
                            <tr>
                                <td colspan="6" class="text-center text-muted py-3">No enrollments recorded.</td>
                            </tr>
                        </c:if>
                    </tbody>
                </table>
            </div>
        </div>
    </main>
</div>

<script>
document.addEventListener('DOMContentLoaded', function() {
    fetch('${pageContext.request.contextPath}/admin/api/stats')
        .then(response => response.json())
        .then(data => {
            // Enrolment Bar Chart
            const ctx1 = document.getElementById('enrolmentChart').getContext('2d');
            new Chart(ctx1, {
                type: 'bar',
                data: {
                    labels: data.enrolmentsPerMonth.labels,
                    datasets: [{
                        label: 'Enrolments',
                        data: data.enrolmentsPerMonth.counts,
                        backgroundColor: '#0F5F63'
                    }]
                },
                options: {
                    responsive: true,
                    maintainAspectRatio: false,
                    plugins: { legend: { display: false } },
                    scales: {
                        y: { beginAtZero: true, ticks: { stepSize: 1 } }
                    }
                }
            });

            // Seat Utilisation Horizontal Bar Chart
            const ctx2 = document.getElementById('utilisationChart').getContext('2d');
            new Chart(ctx2, {
                type: 'bar',
                data: {
                    labels: data.seatUtilisation.labels,
                    datasets: [
                        {
                            label: 'Enrolled',
                            data: data.seatUtilisation.enrolled,
                            backgroundColor: '#0F5F63'
                        },
                        {
                            label: 'Capacity',
                            data: data.seatUtilisation.capacity,
                            backgroundColor: '#D9DEE3'
                        }
                    ]
                },
                options: {
                    indexAxis: 'y',
                    responsive: true,
                    maintainAspectRatio: false,
                    plugins: { legend: { position: 'bottom' } },
                    scales: {
                        x: { beginAtZero: true }
                    }
                }
            });
        });
});
</script>

<%@ include file="/common/footer.jsp" %>
