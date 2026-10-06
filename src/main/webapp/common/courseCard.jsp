<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<c:set var="toneIndex" value="${course.courseId % 6}" />
<c:set var="toneClass" value="tone-teal" />
<c:if test="${toneIndex == 0}"><c:set var="toneClass" value="tone-slate" /></c:if>
<c:if test="${toneIndex == 1}"><c:set var="toneClass" value="tone-teal" /></c:if>
<c:if test="${toneIndex == 2}"><c:set var="toneClass" value="tone-brown" /></c:if>
<c:if test="${toneIndex == 3}"><c:set var="toneClass" value="tone-olive" /></c:if>
<c:if test="${toneIndex == 4}"><c:set var="toneClass" value="tone-plum" /></c:if>
<c:if test="${toneIndex == 5}"><c:set var="toneClass" value="tone-steel" /></c:if>

<div class="course-tile ${toneClass}">
    <div>
        <div class="d-flex justify-content-between align-items-start mb-2">
            <span class="course-code-badge"><c:out value="${course.courseCode}" /></span>
            <span class="cc-chip ${course.full ? 'cc-chip-full' : 'cc-chip-open'}">
                <c:choose>
                    <c:when test="${course.full}">Full</c:when>
                    <c:otherwise><c:out value="${course.seatsLeft}" /> seats left</c:otherwise>
                </c:choose>
            </span>
        </div>
        <h3 class="h6 fw-semibold text-dark mb-1"><c:out value="${course.title}" /></h3>
        <p class="text-muted small mb-2" style="font-size: 13px;">
            Instructor: <c:out value="${course.facultyName != null ? course.facultyName : 'Unassigned'}" />
        </p>
        <p class="text-secondary small mb-3" style="font-size: 13px; display: -webkit-box; -webkit-line-clamp: 2; -webkit-box-orient: vertical; overflow: hidden;">
            <c:out value="${course.description}" />
        </p>
    </div>
    
    <div>
        <div class="d-flex justify-content-between align-items-center text-muted small mb-3" style="font-size: 12px;">
            <span><c:out value="${course.durationWeeks}" /> weeks</span>
            <span><c:out value="${course.categoryName}" /></span>
        </div>

        <c:choose>
            <c:when test="${sessionScope.user.role == 'STUDENT'}">
                <a href="${pageContext.request.contextPath}/student/course?id=${course.courseId}" class="btn btn-sm btn-outline-primary w-100">View course</a>
            </c:when>
            <c:when test="${sessionScope.user.role == 'FACULTY'}">
                <a href="${pageContext.request.contextPath}/faculty/course?id=${course.courseId}" class="btn btn-sm btn-outline-primary w-100">Manage course</a>
            </c:when>
            <c:otherwise>
                <a href="${pageContext.request.contextPath}/student/course?id=${course.courseId}" class="btn btn-sm btn-outline-primary w-100">Course details</a>
            </c:otherwise>
        </c:choose>
    </div>
</div>
