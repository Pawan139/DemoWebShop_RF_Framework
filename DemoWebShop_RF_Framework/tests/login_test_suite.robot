*** Settings ***
Documentation    Test suite covering the Login page of DemoWebShop
...              (https://demowebshop.tricentis.com/login).
...
...              Design: strict L1 (element) / L2 (business) / L3 (test case) layering.
...              Test cases below call ONLY L2/L1 keywords - never a raw SeleniumLibrary
...              keyword or a hardcoded locator - keeping this file readable as
...              plain-English business steps.
...
...              Test Case 02 registers a fresh account so Test Case 03 has a
...              guaranteed-valid login (DemoWebShop requires a registered account;
...              there is no fixed set of valid demo credentials).
Resource         ${EXECDIR}/resources/keywords/L1_element_keywords/login_page_keywords.resource
Resource         ${EXECDIR}/resources/keywords/L2_business_keywords/account_business_keywords.resource
Resource         ${EXECDIR}/variables/global_variables.resource
Library          SeleniumLibrary
Suite Setup      Open Browser To Application
Suite Teardown   Close All Browsers
Test Teardown    Run Keyword If Test Failed    Capture Page Screenshot Step    TEST_FAILURE

*** Variables ***
${REGISTERED_EMAIL}    ${EMPTY}

*** Test Cases ***
TC01 - Login Page Loads With All Required Elements
    [Documentation]    Verifies the Login page renders with the fields and controls
    ...                a user needs: Email, Password, Log in button, Register link.
    [Tags]    smoke    login    ui
    Open Login Page
    Element Should Be Visible    id:Email
    Element Should Be Visible    id:Password
    Element Should Be Visible    css:input.button-1.login-button
    Element Should Be Visible    css:a.ico-register

TC02 - Register A New Customer For Login Testing
    [Documentation]    Setup test: creates a brand-new, uniquely-emailed account.
    ...                The generated email is stored as a suite variable and reused
    ...                by TC03. Ends by logging out so TC03 performs a real login.
    [Tags]    setup    registration
    ${email}=    Register A New Customer And Return Credentials
    Set Suite Variable    ${REGISTERED_EMAIL}    ${email}
    Logout Current User

TC03 - Successful Login With Valid Registered Credentials
    [Documentation]    Logs in using the account created in TC02 and verifies the
    ...                header switches to a logged-in state ("Log out" link visible).
    [Tags]    smoke    login    positive
    Skip If    '${REGISTERED_EMAIL}' == '${EMPTY}'    msg=TC02 must run first to create a valid account.
    Login With Valid Credentials    ${REGISTERED_EMAIL}    ${VALID_PASSWORD}
    Verify User Is Logged In
    Logout Current User

TC04 - Login Fails With Incorrect Password
    [Documentation]    Attempts to log in with a valid-format email but a wrong
    ...                password and verifies the correct validation error appears.
    [Tags]    login    negative
    Login With Invalid Credentials    someone.not.real@example.com    ${INVALID_PASSWORD}
    Verify Login Error Message Displayed    The credentials provided are incorrect

TC05 - Login Fails With Empty Email And Password
    [Documentation]    Submits the login form with both fields blank and verifies
    ...                the form does not proceed and shows a validation message.
    [Tags]    login    negative    validation
    Attempt Login With Empty Credentials
    Verify Login Error Message Displayed    Login was unsuccessful

*** Keywords ***
Open Browser To Application
    [Documentation]    Suite-level browser bring-up, run once before all test cases.
    Open Browser    ${BASE_URL}    ${BROWSER}
    Set Selenium Implicit Wait    ${IMPLICIT_WAIT}
    Maximize Browser Window
