*** Settings ***
Documentation    Centralized locators for the Login page (https://demowebshop.tricentis.com/login).
...              Locators live ONLY here - keywords must never hardcode a selector.
...              If the DOM changes, this is the single file to update.

*** Variables ***
${LOGIN_EMAIL_FIELD}           id:Email
${LOGIN_PASSWORD_FIELD}        id:Password
${LOGIN_BUTTON}                css:input.button-1.login-button
${REMEMBER_ME_CHECKBOX}        id:RememberMe
${FORGOT_PASSWORD_LINK}        css:a.forgot-password
${REGISTER_LINK}               css:a.ico-register
${LOGIN_VALIDATION_SUMMARY}    css:div.validation-summary-errors
${LOGIN_FIELD_VALIDATION_ERROR}    css:span.field-validation-error
${LOGIN_PAGE_TITLE}            css:div.page-title h1

# --- Header elements used to confirm a session state (logged in / logged out) ---
${HEADER_ACCOUNT_LINK}         css:a.account
${HEADER_LOGOUT_LINK}          css:a.ico-logout
${HEADER_LOGIN_LINK}           css:a.ico-login
