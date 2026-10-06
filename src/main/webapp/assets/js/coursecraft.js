/* CourseCraft JavaScript Helpers */

document.addEventListener('DOMContentLoaded', function () {
    // Confirm Dialog Helper
    const confirmModalEl = document.getElementById('globalConfirmModal');
    if (confirmModalEl) {
        const confirmModal = new bootstrap.Modal(confirmModalEl);
        const modalMessage = document.getElementById('globalConfirmMessage');
        const modalForm = document.getElementById('globalConfirmForm');

        document.querySelectorAll('[data-confirm-message]').forEach(function (element) {
            element.addEventListener('click', function (e) {
                e.preventDefault();
                const message = this.getAttribute('data-confirm-message');
                const action = this.getAttribute('data-confirm-action');

                modalMessage.textContent = message;
                modalForm.setAttribute('action', action);

                // Transfer CSRF token input
                const csrfInput = modalForm.querySelector('input[name="csrfToken"]');
                const sourceCsrf = document.querySelector('input[name="csrfToken"]');
                if (csrfInput && sourceCsrf) {
                    csrfInput.value = sourceCsrf.value;
                }

                confirmModal.show();
            });
        });
    }

    // Remember last active tab across reloads
    const activeTab = new URLSearchParams(window.location.search).get('tab');
    if (activeTab) {
        const tabTrigger = document.querySelector(`[data-bs-target="#${activeTab}"]`);
        if (tabTrigger) {
            const tab = new bootstrap.Tab(tabTrigger);
            tab.show();
        }
    }
});
