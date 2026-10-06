<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<c:if test="${not empty successMessage}">
    <div class="inline-alert inline-alert-success" role="alert">
        <c:out value="${successMessage}" />
    </div>
</c:if>

<c:if test="${not empty errorMessage}">
    <div class="inline-alert inline-alert-danger" role="alert">
        <c:out value="${errorMessage}" />
    </div>
</c:if>

<c:if test="${not empty infoMessage}">
    <div class="inline-alert inline-alert-info" role="alert">
        <c:out value="${infoMessage}" />
    </div>
</c:if>

<c:if test="${not empty sessionScope.successMessage}">
    <div class="inline-alert inline-alert-success" role="alert">
        <c:out value="${sessionScope.successMessage}" />
    </div>
    <c:remove var="successMessage" scope="session" />
</c:if>

<c:if test="${not empty sessionScope.errorMessage}">
    <div class="inline-alert inline-alert-danger" role="alert">
        <c:out value="${sessionScope.errorMessage}" />
    </div>
    <c:remove var="errorMessage" scope="session" />
</c:if>
