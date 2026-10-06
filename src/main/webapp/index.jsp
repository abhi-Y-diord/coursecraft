<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<c:set var="pageTitle" value="CourseCraft LMS" />
<%@ include file="/common/header.jsp" %>
<%@ include file="/common/navbar.jsp" %>

<main class="container py-4" style="max-width: 1000px;">
    <%@ include file="/common/flash.jsp" %>

    <div class="mb-4 text-start">
        <h1 class="h3 fw-semibold text-dark">Department of Computer Science</h1>
        <p class="text-secondary" style="font-size: 15px;">
            CourseCraft is the course management system for student enrollment, course material distribution, assignment submission, and grade tracking.
        </p>
    </div>

    <c:if test="${not empty globalAnnouncement}">
        <div class="inline-alert inline-alert-info mb-4">
            <div class="fw-semibold mb-1"><c:out value="${globalAnnouncement.title}" /></div>
            <div><c:out value="${globalAnnouncement.message}" /></div>
            <div class="text-muted small mt-1" style="font-size: 12px;">Posted on <c:out value="${globalAnnouncement.postedOn}" /> by System Administration</div>
        </div>
    </c:if>

    <div class="d-flex justify-content-between align-items-center mb-3">
        <h2 class="h5 fw-semibold mb-0">Currently open courses</h2>
        <a href="${pageContext.request.contextPath}/student/catalog" class="btn btn-sm btn-outline-primary">View full catalog</a>
    </div>

    <div class="table-responsive bg-white border rounded mb-4">
        <table class="table table-hover mb-0">
            <thead>
                <tr>
                    <th>Code</th>
                    <th>Course Title</th>
                    <th>Category</th>
                    <th>Instructor</th>
                    <th>Duration</th>
                    <th>Seats Available</th>
                    <th>Action</th>
                </tr>
            </thead>
            <tbody>
                <c:forEach var="c" items="${openCourses}">
                    <tr>
                        <td class="code-font fw-semibold"><c:out value="${c.courseCode}" /></td>
                        <td class="fw-medium"><c:out value="${c.title}" /></td>
                        <td class="text-muted"><c:out value="${c.categoryName}" /></td>
                        <td><c:out value="${c.facultyName != null ? c.facultyName : 'Unassigned'}" /></td>
                        <td class="tabular-nums"><c:out value="${c.durationWeeks}" /> weeks</td>
                        <td class="tabular-nums fw-medium"><c:out value="${c.seatsLeft}" /> of <c:out value="${c.capacity}" /></td>
                        <td>
                            <a href="${pageContext.request.contextPath}/login" class="btn btn-sm btn-outline-primary">Sign in to enrol</a>
                        </td>
                    </tr>
                </c:forEach>
                <c:if test="${empty openCourses}">
                    <tr>
                        <td colspan="7" class="text-center text-muted py-3">No courses currently open for enrollment.</td>
                    </tr>
                </c:if>
            </tbody>
        </table>
    </div>
</main>

<%@ include file="/common/footer.jsp" %>
