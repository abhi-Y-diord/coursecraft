<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<div class="text-center py-4 my-2 border rounded bg-white">
    <p class="text-muted mb-2"><c:out value="${emptyMessage != null ? emptyMessage : 'No records found.'}" /></p>
    <c:if test="${not empty emptyActionUrl and not empty emptyActionText}">
        <a href="${emptyActionUrl}" class="btn btn-sm btn-outline-primary"><c:out value="${emptyActionText}" /></a>
    </c:if>
</div>
