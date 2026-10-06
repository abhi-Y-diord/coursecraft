<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<c:set var="pageTitle" value="Course Catalog" />
<c:set var="activeNav" value="catalog" />
<%@ include file="/common/header.jsp" %>
<%@ include file="/common/navbar.jsp" %>

<div class="d-flex">
    <%@ include file="/common/sidebar.jsp" %>
    <main class="app-content">
        <h1 class="page-title mb-3">Course Catalog</h1>
        <%@ include file="/common/flash.jsp" %>

        <div class="row g-4">
            <!-- Left Filter Panel -->
            <div class="col-md-3">
                <div class="card cc-card p-3">
                    <h2 class="h6 fw-semibold mb-3">Filter courses</h2>
                    <form action="${pageContext.request.contextPath}/student/catalog" method="get">
                        <div class="mb-3">
                            <label for="searchKeyword" class="form-label small fw-medium">Search</label>
                            <input type="text" id="searchKeyword" name="q" class="form-control form-control-sm" placeholder="Title or code..." value="${param.q}">
                        </div>

                        <div class="mb-3">
                            <label for="catSelect" class="form-label small fw-medium">Category</label>
                            <select id="catSelect" name="cat" class="form-select form-select-sm">
                                <option value="">All categories</option>
                                <c:forEach var="c" items="${categories}">
                                    <option value="${c.categoryId}" ${param.cat == c.categoryId ? 'selected' : ''}><c:out value="${c.name}" /></option>
                                </c:forEach>
                            </select>
                        </div>

                        <div class="mb-3">
                            <label for="availSelect" class="form-label small fw-medium">Availability</label>
                            <select id="availSelect" name="avail" class="form-select form-select-sm">
                                <option value="">All courses</option>
                                <option value="open" ${param.avail == 'open' ? 'selected' : ''}>Open seats only</option>
                                <option value="full" ${param.avail == 'full' ? 'selected' : ''}>Full courses</option>
                            </select>
                        </div>

                        <div class="mb-3">
                            <label for="sortSelect" class="form-label small fw-medium">Sort by</label>
                            <select id="sortSelect" name="sort" class="form-select form-select-sm">
                                <option value="code_asc" ${param.sort == 'code_asc' ? 'selected' : ''}>Course code (A-Z)</option>
                                <option value="title_asc" ${param.sort == 'title_asc' ? 'selected' : ''}>Course title (A-Z)</option>
                                <option value="seats_desc" ${param.sort == 'seats_desc' ? 'selected' : ''}>Most seats available</option>
                                <option value="duration_asc" ${param.sort == 'duration_asc' ? 'selected' : ''}>Shortest duration</option>
                            </select>
                        </div>

                        <button type="submit" class="btn btn-sm btn-primary w-100 mb-2">Apply filters</button>
                        <a href="${pageContext.request.contextPath}/student/catalog" class="btn btn-sm btn-outline-secondary w-100">Clear filters</a>
                    </form>
                </div>
            </div>

            <!-- Course Cards Grid -->
            <div class="col-md-9">
                <div class="d-flex justify-content-between align-items-center mb-3">
                    <span class="text-muted small">Showing <c:out value="${pageObj.items.size()}" /> of <c:out value="${pageObj.totalItems}" /> courses</span>
                </div>

                <div class="row g-3">
                    <c:forEach var="course" items="${pageObj.items}">
                        <div class="col-md-6 col-lg-4">
                            <%@ include file="/common/courseCard.jsp" %>
                        </div>
                    </c:forEach>
                </div>

                <c:if test="${empty pageObj.items}">
                    <c:set var="emptyMessage" value="No courses match the selected filters. Try clearing your filters or changing search terms." />
                    <c:set var="emptyActionUrl" value="${pageContext.request.contextPath}/student/catalog" />
                    <c:set var="emptyActionText" value="Clear filters" />
                    <%@ include file="/common/emptyState.jsp" %>
                </c:if>

                <%@ include file="/common/pagination.jsp" %>
            </div>
        </div>
    </main>
</div>

<%@ include file="/common/footer.jsp" %>
