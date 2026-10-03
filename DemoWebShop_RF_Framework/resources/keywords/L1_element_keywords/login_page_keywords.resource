*** Settings ***
Documentation    L1 (Element Layer) - one keyword per UI interaction on the Login page.
...              Rule: an L1 keyword touches exactly ONE element and does ONE thing.
...              Never chain multiple actions in an L1 keyword; that belongs in L2.
Resource         ${EXECDIR}/resources/locators/login_locators.resource
Resource         ${EXECDIR}/variables/global_variables.resource
Library          SeleniumLibrary

*** Keywords ***
Open Login Page
    [Documentation]    Navigates directly to the Login page URL.
    Go To    ${LOGIN_URL}
    Wait Until Element Is Visible    ${LOGIN_EMAIL_FIELD}    timeout=${EXPLICIT_TIMEOUT}
    Capture Page Screenshot Step    open_login_page

Enter Login Email
    [Arguments]    ${email}
    [Documentation]    Types the given value into the Email field.
    Wait Until Element Is Visible    ${LOGIN_EMAIL_FIELD}    timeout=${EXPLICIT_TIMEOUT}
    Clear Element Text    ${LOGIN_EMAIL_FIELD}
    Input Text    ${LOGIN_EMAIL_FIELD}    ${email}
    Capture Page Screenshot Step    enter_login_email

Enter Login Password
    [Arguments]    ${password}
    [Documentation]    Types the given value into the Password field.
    Wait Until Element Is Visible    ${LOGIN_PASSWORD_FIELD}    timeout=${EXPLICIT_TIMEOUT}
    Clear Element Text    ${LOGIN_PASSWORD_FIELD}
    Input Text    ${LOGIN_PASSWORD_FIELD}    ${password}
    Capture Page Screenshot Step    enter_login_password

Click Login Button
    [Documentation]    Clicks the "Log in" submit button.
    Wait Until Element Is Enabled    ${LOGIN_BUTTON}    timeout=${EXPLICIT_TIMEOUT}
    Click Element    ${LOGIN_BUTTON}
    Capture Page Screenshot Step    click_login_button

Click Register Link From Login Page
    [Documentation]    Navigates to the Registration page via the header link.
    Wait Until Element Is Visible    ${REGISTER_LINK}    timeout=${EXPLICIT_TIMEOUT}
    Click Element    ${REGISTER_LINK}
    Capture Page Screenshot Step    click_register_link

Get Login Validation Summary Text
    [Documentation]    Returns the text of the top-level validation summary error box.
    Wait Until Element Is Visible    ${LOGIN_VALIDATION_SUMMARY}    timeout=${EXPLICIT_TIMEOUT}
    ${text}=    Get Text    ${LOGIN_VALIDATION_SUMMARY}
    Capture Page Screenshot Step    login_validation_summary
    [Return]    ${text}

Is Logout Link Visible
    [Documentation]    Returns True/False for whether the header shows the logged-in "Log out" link.
    ${visible}=    Run Keyword And Return Status
    ...    Wait Until Element Is Visible    ${HEADER_LOGOUT_LINK}    timeout=${EXPLICIT_TIMEOUT}
    [Return]    ${visible}

Click Header Logout Link
    [Documentation]    Clicks "Log out" in the page header.
    Wait Until Element Is Visible    ${HEADER_LOGOUT_LINK}    timeout=${EXPLICIT_TIMEOUT}
    Click Element    ${HEADER_LOGOUT_LINK}
    Capture Page Screenshot Step    click_logout_link

Capture Page Screenshot Step
    [Arguments]    ${step_name}
    [Documentation]    Standard screenshot-after-every-action helper. Controlled by
    ...                ${SCREENSHOT_ON_ACTION} so it can be globally disabled if needed.
    Run Keyword If    ${SCREENSHOT_ON_ACTION}
    ...    Capture Page Screenshot    ${SCREENSHOT_DIR}${/}{index}_${step_name}.png
