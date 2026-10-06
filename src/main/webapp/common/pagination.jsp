<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<c:if test="${not empty pageObj and pageObj.totalPages > 1}">
    <nav aria-label="Page navigation" class="mt-4">
        <ul class="pagination pagination-sm justify-content-center">
            <li class="page-item ${!pageObj.hasPrevious() ? 'disabled' : ''}">
                <a class="page-link" href="${baseUrl}?page=${pageObj.page - 1}&q=${param.q}&status=${param.status}&cat=${param.cat}">Previous</a>
            </li>
            <c:forEach var="i" begin="1" end="${pageObj.totalPages}">
                <li class="page-item ${pageObj.page == i ? 'active' : ''}">
                    <a class="page-link" href="${baseUrl}?page=${i}&q=${param.q}&status=${param.status}&cat=${param.cat}">${i}</a>
                </li>
            </c:forEach>
            <li class="page-item ${!pageObj.hasNext() ? 'disabled' : ''}">
                <a class="page-link" href="${baseUrl}?page=${pageObj.page + 1}&q=${param.q}&status=${param.status}&cat=${param.cat}">Next</a>
            </li>
        </ul>
    </nav>
</c:if>
