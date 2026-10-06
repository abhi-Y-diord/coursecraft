<%@ page contentType="text/html;charset=UTF-8" language="java" isErrorPage="true" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<c:set var="pageTitle" value="Error" />
<%@ include file="/common/header.jsp" %>
<%@ include file="/common/navbar.jsp" %>

<main class="container py-5 text-center" style="max-width: 600px;">
    <div class="card cc-card py-4">
        <h1 class="display-6 fw-semibold text-danger code-font mb-2">
            <c:out value="${pageContext.errorData.statusCode != 0 ? pageContext.errorData.statusCode : 'Error'}" />
        </h1>
        <p class="text-secondary mb-4">
            <c:choose>
                <c:when test="${pageContext.errorData.statusCode == 404}">
                    404. This page does not exist. Return to dashboard.
                </c:when>
                <c:when test="${pageContext.errorData.statusCode == 403}">
                    403. Access denied. You do not have permission to view this resource.
                </c:when>
                <c:otherwise>
                    The request could not be completed. Try again, or return to the dashboard.
                </c:otherwise>
            </c:choose>
        </p>
        <div>
            <a href="${pageContext.request.contextPath}/" class="btn btn-sm btn-primary">Return to home</a>
        </div>
    </div>
</main>

<%@ include file="/common/footer.jsp" %>
