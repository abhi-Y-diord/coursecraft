<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<div class="modal fade" id="globalConfirmModal" tabindex="-1" aria-labelledby="globalConfirmModalLabel" aria-hidden="true">
    <div class="modal-dialog modal-dialog-centered">
        <div class="modal-content">
            <div class="modal-header">
                <h1 class="modal-title fs-6" id="globalConfirmModalLabel">Confirm Action</h1>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <div class="modal-body">
                <p id="globalConfirmMessage" class="mb-0">Are you sure you want to perform this action?</p>
            </div>
            <div class="modal-footer">
                <form id="globalConfirmForm" method="post" action="">
                    <input type="hidden" name="csrfToken" value="${sessionScope.csrfToken}" />
                    <button type="button" class="btn btn-sm btn-outline-secondary" data-bs-dismiss="modal">Cancel</button>
                    <button type="submit" class="btn btn-sm btn-danger">Confirm</button>
                </form>
            </div>
        </div>
    </div>
</div>
