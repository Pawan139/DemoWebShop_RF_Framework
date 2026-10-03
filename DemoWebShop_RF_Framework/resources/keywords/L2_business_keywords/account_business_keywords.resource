*** Settings ***
Documentation    L2 (Business Layer) - meaningful, reusable business flows composed of
...              multiple L1 keywords. Test cases (L3) should call ONLY L2 keywords
...              wherever a business flow exists; they drop to L1 only for page-specific
...              single checks that have no business meaning of their own.
Resource         ${EXECDIR}/resources/keywords/L1_element_keywords/login_page_keywords.resource
Resource         ${EXECDIR}/resources/keywords/L1_element_keywords/registration_page_keywords.resource
Resource         ${EXECDIR}/variables/global_variables.resource
Library          SeleniumLibrary
Library          String

*** Keywords ***
Register A New Customer And Return Credentials
    [Documentation]    Registers a brand-new, uniquely-emailed customer on DemoWebShop
    ...                so later tests have a guaranteed-valid login account.
    ...                Returns the generated email so it can be reused by login tests.
    ${random_string}=    Generate Random String    8    [LOWER]
    ${unique_email}=    Set Variable    pawan.qa.${random_string}@example.com
    Open Registration Page
    Select Gender    ${GENDER}
    Enter First Name    ${FIRST_NAME}
    Enter Last Name    ${LAST_NAME}
    Enter Registration Email    ${unique_email}
    Enter Registration Password    ${VALID_PASSWORD}
    Enter Registration Confirm Password    ${VALID_PASSWORD}
    Click Register Button
    ${confirmation}=    Get Registration Success Text
    Should Contain    ${confirmation}    Your registration completed
    [Return]    ${unique_email}

Login With Valid Credentials
    [Arguments]    ${email}    ${password}
    [Documentation]    Full login flow: opens the login page and submits credentials.
    Open Login Page
    Enter Login Email    ${email}
    Enter Login Password    ${password}
    Click Login Button

Login With Invalid Credentials
    [Arguments]    ${email}    ${password}
    [Documentation]    Same flow as a valid login attempt, semantically named for
    ...                negative test cases so intent is clear from the test case itself.
    Open Login Page
    Enter Login Email    ${email}
    Enter Login Password    ${password}
    Click Login Button

Attempt Login With Empty Credentials
    [Documentation]    Submits the login form with both fields left blank.
    Open Login Page
    Click Login Button

Verify User Is Logged In
    [Documentation]    Confirms a successful login by checking the header shows "Log out".
    ${logged_in}=    Is Logout Link Visible
    Should Be True    ${logged_in}    msg=Expected user to be logged in but "Log out" link was not found.

Verify Login Error Message Displayed
    [Arguments]    ${expected_text}
    [Documentation]    Confirms the login validation summary is shown with expected text.
    ${actual_text}=    Get Login Validation Summary Text
    Should Contain    ${actual_text}    ${expected_text}

Logout Current User
    [Documentation]    Logs the current session out, used to reset state between tests.
    ${logged_in}=    Is Logout Link Visible
    Run Keyword If    ${logged_in}    Click Header Logout Link
