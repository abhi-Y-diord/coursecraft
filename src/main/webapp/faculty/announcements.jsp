<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<c:set var="pageTitle" value="Announcements" />
<c:set var="activeNav" value="announcements" />
<%@ include file="/common/header.jsp" %>
<%@ include file="/common/navbar.jsp" %>

<div class="d-flex">
    <%@ include file="/common/sidebar.jsp" %>
    <main class="app-content">
        <div class="d-flex justify-content-between align-items-center mb-3">
            <h1 class="page-title">Course announcements</h1>
            <button class="btn btn-sm btn-primary" data-bs-toggle="modal" data-bs-target="#addAnnouncementModal">Post announcement</button>
        </div>
        <%@ include file="/common/flash.jsp" %>

        <div class="table-responsive bg-white border rounded">
            <table class="table table-hover align-middle mb-0">
                <thead>
                    <tr>
                        <th>Title</th>
                        <th>Course</th>
                        <th>Posted By</th>
                        <th>Date Posted</th>
                        <th>Action</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach var="a" items="${announcements}">
                        <tr>
                            <td class="fw-medium">
                                <div class="fw-semibold"><c:out value="${a.title}" /></div>
                                <div class="text-secondary small" style="font-size: 13px;"><c:out value="${a.message}" /></div>
                            </td>
                            <td>
                                <span class="code-font fw-semibold"><c:out value="${a.courseCode}" /></span>
                                <span class="text-muted small"> - <c:out value="${a.courseTitle}" /></span>
                            </td>
                            <td><c:out value="${a.postedByName}" /></td>
                            <td class="text-muted small"><c:out value="${a.postedOn}" /></td>
                            <td>
                                <button type="button" class="btn btn-xs btn-outline-danger"
                                        data-confirm-message="Delete announcement '${a.title}'?"
                                        data-confirm-action="${pageContext.request.contextPath}/faculty/announcements?action=delete&announcementId=${a.announcementId}">
                                    Delete
                                </button>
                            </td>
                        </tr>
                    </c:forEach>
                    <c:if test="${empty announcements}">
                        <tr>
                            <td colspan="5" class="text-center text-muted py-4">No announcements posted for your courses yet.</td>
                        </tr>
                    </c:if>
                </tbody>
            </table>
        </div>
    </main>
</div>

<div class="modal fade" id="addAnnouncementModal" tabindex="-1" aria-labelledby="addAnnouncementModalLabel" aria-hidden="true">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <h1 class="modal-title fs-6" id="addAnnouncementModalLabel">Post announcement</h1>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <form action="${pageContext.request.contextPath}/faculty/announcements" method="post">
                <input type="hidden" name="csrfToken" value="${sessionScope.csrfToken}" />
                <input type="hidden" name="action" value="add" />
                <div class="modal-body">
                    <div class="mb-3">
                        <label for="atitle" class="form-label small fw-medium">Title <span class="text-muted">(required)</span></label>
                        <input type="text" id="atitle" name="title" class="form-control" required>
                    </div>
                    <div class="mb-3">
                        <label for="acourse" class="form-label small fw-medium">Course <span class="text-muted">(required)</span></label>
                        <select id="acourse" name="courseId" class="form-select" required>
                            <c:forEach var="c" items="${courses}">
                                <option value="${c.courseId}"><c:out value="${c.courseCode}" /> - <c:out value="${c.title}" /></option>
                            </c:forEach>
                        </select>
                    </div>
                    <div class="mb-3">
                        <label for="amessage" class="form-label small fw-medium">Message text <span class="text-muted">(required)</span></label>
                        <textarea id="amessage" name="message" class="form-control" rows="4" required></textarea>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-sm btn-outline-secondary" data-bs-dismiss="modal">Cancel</button>
                    <button type="submit" class="btn btn-sm btn-primary">Post announcement</button>
                </div>
            </form>
        </div>
    </div>
</div>

<%@ include file="/common/confirmModal.jsp" %>
<%@ include file="/common/footer.jsp" %>
