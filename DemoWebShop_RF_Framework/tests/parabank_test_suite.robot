*** Settings ***
Documentation    25 XPath-only end-to-end tests for the ParaBank public demo application.
Resource         ../resources/keywords/parabank_keywords.resource
Test Setup       Open ParaBank
Test Teardown    Close ParaBank

*** Variables ***
${PARABANK_TEST_USERNAME}    ${EMPTY}
${PARABANK_TEST_PASSWORD}    ${EMPTY}

*** Test Cases ***
TC_PB_001 Home Page Shows Guest Login
    [Documentation]    Verify the ParaBank home page loads with username, password, login, registration, and recovery controls.
    Wait For Elements State    ${XPATH_HOME_USERNAME}    visible
    Wait For Elements State    ${XPATH_HOME_PASSWORD}    visible
    Wait For Elements State    ${XPATH_HOME_LOGIN_BUTTON}    visible
    Wait For Elements State    ${XPATH_HOME_REGISTER_LINK}    visible
    Wait For Elements State    ${XPATH_HOME_FORGOT_LINK}    visible
    ${title}=    Get Title
    Should Contain    ${title}    ParaBank

TC_PB_002 Login Rejects Empty Credentials
    [Documentation]    Submit the guest login form without username or password and verify the login is rejected.
    Click    ${XPATH_HOME_LOGIN_BUTTON}
    Wait For Elements State    ${XPATH_ERROR_MESSAGE}    visible    timeout=10s
    ${error}=    Get Text    ${XPATH_ERROR_MESSAGE}
    Should Not Be Empty    ${error}
    Wait For Elements State    ${XPATH_HOME_USERNAME}    visible

TC_PB_003 Login Rejects Invalid Credentials
    [Documentation]    Submit an unregistered username and invalid password; verify the site displays its login error.
    Fill Text    ${XPATH_HOME_USERNAME}    unknown_para_user_92831
    Fill Text    ${XPATH_HOME_PASSWORD}    ${INVALID_PASSWORD}
    Click    ${XPATH_HOME_LOGIN_BUTTON}
    Wait For Elements State    ${XPATH_ERROR_MESSAGE}    visible    timeout=10s
    ${error}=    Get Text    ${XPATH_ERROR_MESSAGE}
    Should Contain    ${error}    could not be verified

TC_PB_004 Forgot Login Page Shows Lookup Form
    [Documentation]    Open customer lookup and verify the identity fields and find-login action are present.
    [Tags]    Smoke
    Click    ${XPATH_HOME_FORGOT_LINK}
    Wait For Elements State    ${XPATH_LOOKUP_FIRST_NAME}    visible
    Wait For Elements State    ${XPATH_LOOKUP_LAST_NAME}    visible
    Wait For Elements State    ${XPATH_LOOKUP_SSN}    visible
    Wait For Elements State    ${XPATH_LOOKUP_BUTTON}    visible

TC_PB_005 Registration Page Shows Required Fields
    [Documentation]    Navigate to registration and check the required customer identity and credential inputs.
    Open Registration Page
    Wait For Elements State    ${XPATH_REGISTER_FIRST_NAME}    visible
    Wait For Elements State    ${XPATH_REGISTER_LAST_NAME}    visible
    Wait For Elements State    ${XPATH_REGISTER_ADDRESS}    visible
    Wait For Elements State    ${XPATH_REGISTER_PHONE}    visible
    Wait For Elements State    ${XPATH_REGISTER_SSN}    visible
    Wait For Elements State    ${XPATH_REGISTER_USERNAME}    visible
    Wait For Elements State    ${XPATH_REGISTER_PASSWORD}    visible
    Wait For Elements State    ${XPATH_REGISTER_CONFIRM_PASSWORD}    visible

TC_PB_006 Register New Customer Successfully
    [Documentation]    Register a unique demo customer and verify the authenticated account navigation is displayed.
    ${username}=    Register New Test Customer
    Should Contain    ${username}    ${USERNAME_PREFIX}
    Wait For Elements State    ${XPATH_NAV_OVERVIEW}    visible
    Wait For Elements State    ${XPATH_NAV_LOGOUT}    visible

TC_PB_007 Registration Rejects Empty Form
    [Documentation]    Submit the registration form empty and verify the customer form remains available for correction.
    Open Registration Page
    Click    ${XPATH_REGISTER_BUTTON}
    Wait For Elements State    ${XPATH_REGISTER_FORM}    visible    timeout=10s
    Wait For Elements State    ${XPATH_REGISTER_USERNAME}    visible

TC_PB_008 Registration Rejects Mismatched Passwords
    [Documentation]    Submit valid customer information with mismatched passwords and verify registration is rejected.
    [Tags]    Smoke
    ${suffix}=    Generate Random String    8    [LOWER]
    ${username}=    Set Variable    ${USERNAME_PREFIX}${suffix}
    Open Registration Page
    Fill Registration Form    ${username}    ${TEST_PASSWORD}    Wrong@123
    Click    ${XPATH_REGISTER_BUTTON}
    Wait For Elements State    ${XPATH_REGISTER_FORM}    visible    timeout=10s
    ${page_text}=    Get Text    ${XPATH_RIGHT_PANEL}
    Should Contain    ${page_text}    Passwords did not match

TC_PB_009 Registration Rejects Duplicate Username
    [Documentation]    Reuse the registered username with otherwise valid fields and verify duplicate account creation is rejected.
    ${username}=    Ensure Test Customer
    Open Registration Page
    Fill Registration Form    ${username}    ${TEST_PASSWORD}    ${TEST_PASSWORD}
    Click    ${XPATH_REGISTER_BUTTON}
    Wait For Elements State    ${XPATH_REGISTER_FORM}    visible    timeout=10s
    ${page_text}=    Get Text    ${XPATH_RIGHT_PANEL}
    Should Contain    ${page_text}    This username already exists

TC_PB_010 Login Accepts Registered Credentials
    [Documentation]    Authenticate with the customer created by this suite and verify account navigation is available.
    [Tags]    Smoke
    ${username}=    Ensure Test Customer
    Login With Credentials    ${username}    ${PARABANK_TEST_PASSWORD}
    Wait For Elements State    ${XPATH_NAV_OVERVIEW}    visible
    Wait For Elements State    ${XPATH_NAV_LOGOUT}    visible

TC_PB_011 Logout Ends Authenticated Session
    [Documentation]    Log in with the registered customer, log out, and verify guest login controls return.
    Login As Test Customer
    Logout ParaBank
    Wait For Elements State    ${XPATH_HOME_USERNAME}    visible
    Wait For Elements State    ${XPATH_HOME_LOGIN_BUTTON}    visible

TC_PB_012 Account Overview Lists Customer Accounts
    [Documentation]    Open the account overview and verify at least one account row is displayed.
    Login As Test Customer
    Open Account Overview
    ${overview}=    Get Text    ${XPATH_RIGHT_PANEL}
    Should Contain    ${overview}    Account
    Should Contain    ${overview}    Balance
    Should Contain    ${overview}    Available Amount

TC_PB_013 Open A New Savings Account
    [Documentation]    Open a savings account from the existing customer account and verify an account number is returned.
    [Tags]    Smoke
    Login As Test Customer
    ${account_id}=    Open Extra Account    SAVINGS
    Should Not Be Empty    ${account_id}
    Open Account Overview
    Wait For Elements State    ${XPATH_ACCOUNT_TABLE}    visible

TC_PB_014 Open A New Checking Account
    [Documentation]    Open a checking account and verify the application returns the newly created account number.
    Login As Test Customer
    ${account_id}=    Open Extra Account    CHECKING
    Should Not Be Empty    ${account_id}
    Wait For Elements State    ${XPATH_NEW_ACCOUNT_ID}    visible

TC_PB_015 Transfer Funds Between Accounts
    [Documentation]    Ensure two accounts exist, transfer a valid amount, and verify the transfer result is displayed.
    Ensure Two Accounts
    Click    ${XPATH_NAV_TRANSFER}
    Wait For Elements State    ${XPATH_TRANSFER_AMOUNT}    visible
    Fill Text    ${XPATH_TRANSFER_AMOUNT}    ${TRANSFER_AMOUNT}
    Select Options By    ${XPATH_TRANSFER_FROM}    index    0
    Select Options By    ${XPATH_TRANSFER_TO}    index    1
    Click    ${XPATH_TRANSFER_BUTTON}
    Wait For Elements State    ${XPATH_TRANSFER_RESULT}    visible    timeout=15s
    ${result}=    Get Text    ${XPATH_TRANSFER_RESULT}
    Should Contain    ${result}    Transfer Complete

TC_PB_016 Transfer Rejects Non-Numeric Amount
    [Documentation]    Enter non-numeric transfer input and verify no successful transfer confirmation is shown.
    Ensure Two Accounts
    Click    ${XPATH_NAV_TRANSFER}
    Fill Text    ${XPATH_TRANSFER_AMOUNT}    ${INVALID_AMOUNT}
    Select Options By    ${XPATH_TRANSFER_FROM}    index    0
    Select Options By    ${XPATH_TRANSFER_TO}    index    1
    Click    ${XPATH_TRANSFER_BUTTON}
    ${result}=    Get Text    ${XPATH_RIGHT_PANEL}
    Should Not Contain    ${result}    Transfer Complete

TC_PB_017 Bill Payment Form Shows Required Controls
    [Documentation]    Navigate to Bill Pay and verify payee, account, amount, and submit controls are present.
    Login As Test Customer
    Click    ${XPATH_NAV_BILL_PAY}
    Wait For Elements State    ${XPATH_BILL_NAME}    visible
    Wait For Elements State    ${XPATH_BILL_ADDRESS}    visible
    Wait For Elements State    ${XPATH_BILL_ACCOUNT}    visible
    Wait For Elements State    ${XPATH_BILL_CONFIRM_ACCOUNT}    visible
    Wait For Elements State    ${XPATH_BILL_AMOUNT}    visible
    Wait For Elements State    ${XPATH_BILL_BUTTON}    visible

TC_PB_018 Bill Payment Requires Payee Details
    [Documentation]    Submit an empty bill payment and verify the form remains visible for correction.
    [Tags]    Smoke
    Login As Test Customer
    Click    ${XPATH_NAV_BILL_PAY}
    Click    ${XPATH_BILL_BUTTON}
    Wait For Elements State    ${XPATH_BILL_NAME}    visible    timeout=10s
    ${page_text}=    Get Text    ${XPATH_RIGHT_PANEL}
    Should Not Contain    ${page_text}    Bill Payment Complete

TC_PB_019 Submit A Bill Payment
    [Documentation]    Complete the bill payment form with demo payee data and verify payment confirmation.
    Login As Test Customer
    Click    ${XPATH_NAV_BILL_PAY}
    Fill Bill Pay Form
    Click    ${XPATH_BILL_BUTTON}
    Wait For Elements State    ${XPATH_BILL_RESULT}    visible    timeout=15s
    ${result}=    Get Text    ${XPATH_BILL_RESULT}
    Should Contain    ${result}    Bill Payment Complete

TC_PB_020 Update Customer Contact Information
    [Documentation]    Update the customer address and phone number, then verify the update confirmation.
    Login As Test Customer
    Click    ${XPATH_NAV_UPDATE_PROFILE}
    Wait For Elements State    ${XPATH_PROFILE_FIRST_NAME}    visible
    Fill Text    ${XPATH_PROFILE_FIRST_NAME}    ${FIRST_NAME}
    Fill Text    ${XPATH_PROFILE_LAST_NAME}    ${LAST_NAME}
    Fill Text    ${XPATH_PROFILE_ADDRESS}    ${ADDRESS}
    Fill Text    ${XPATH_PROFILE_CITY}    ${CITY}
    Fill Text    ${XPATH_PROFILE_STATE}    ${STATE}
    Fill Text    ${XPATH_PROFILE_ZIP}    ${ZIP_CODE}
    Fill Text    ${XPATH_PROFILE_PHONE}    ${PHONE}
    Click    ${XPATH_PROFILE_UPDATE_BUTTON}
    ${updated_first_name}=    Get Property    ${XPATH_PROFILE_FIRST_NAME}    value
    Should Be Equal As Strings    ${updated_first_name}    ${FIRST_NAME}

TC_PB_021 Request Loan Page Shows Application Fields
    [Documentation]    Open the loan request page and verify loan amount, down payment, account selector, and submit control.
    Login As Test Customer
    Click    ${XPATH_NAV_REQUEST_LOAN}
    Wait For Elements State    ${XPATH_LOAN_AMOUNT}    visible
    Wait For Elements State    ${XPATH_LOAN_DOWN_PAYMENT}    visible
    Wait For Elements State    ${XPATH_LOAN_FROM_ACCOUNT}    visible
    Wait For Elements State    ${XPATH_LOAN_BUTTON}    visible

TC_PB_022 Loan Request Rejects Invalid Amount
    [Documentation]    Submit a negative loan amount and verify it is not reported as an approved loan.
    Login As Test Customer
    Click    ${XPATH_NAV_REQUEST_LOAN}
    Fill Text    ${XPATH_LOAN_AMOUNT}    -10
    Fill Text    ${XPATH_LOAN_DOWN_PAYMENT}    0
    Select Options By    ${XPATH_LOAN_FROM_ACCOUNT}    index    0
    Click    ${XPATH_LOAN_BUTTON}
    ${page_text}=    Get Text    ${XPATH_RIGHT_PANEL}
    Should Not Contain    ${page_text}    Loan Processor Approved

TC_PB_023 Find Transactions Page Shows Search Options
    [Documentation]    Open transaction search and verify account, transaction ID, date, and amount search controls are available.
    Login As Test Customer
    Open Find Transactions
    Wait For Elements State    ${XPATH_FIND_TRANSACTION_ID}    visible
    Wait For Elements State    ${XPATH_FIND_DATE}    visible
    Wait For Elements State    ${XPATH_FIND_FROM_DATE}    visible
    Wait For Elements State    ${XPATH_FIND_TO_DATE}    visible
    Wait For Elements State    ${XPATH_FIND_AMOUNT}    visible

TC_PB_024 Find Transactions By Date
    [Documentation]    Search the customer's first account using a valid transaction date and verify a result area is displayed.
    Login As Test Customer
    Open Find Transactions
    Select Options By    ${XPATH_FIND_ACCOUNT}    index    0
    Fill Text    ${XPATH_FIND_DATE}    ${TEST_DATE}
    Click    ${XPATH_FIND_BY_DATE_BUTTON}
    Wait For Elements State    ${XPATH_TRANSACTION_TABLE}    visible    timeout=15s

TC_PB_025 Navigate To About Services And Contact
    [Documentation]    Visit the About, Services, and Contact pages from the global navigation and verify each loads.
    Click    ${XPATH_GLOBAL_ABOUT_LINK}
    Wait For Elements State    ${XPATH_RIGHT_PANEL}    visible
    ${about_url}=    Get Url
    Should Contain    ${about_url}    about.htm
    Go To    ${BASE_URL}
    Click    ${XPATH_GLOBAL_SERVICES_LINK}
    Wait For Elements State    ${XPATH_RIGHT_PANEL}    visible
    ${services_url}=    Get Url
    Should Contain    ${services_url}    services.htm
    Go To    ${BASE_URL}
    Click    ${XPATH_GLOBAL_CONTACT_LINK}
    Wait For Elements State    ${XPATH_RIGHT_PANEL}    visible
    ${contact_url}=    Get Url
    Should Contain    ${contact_url}    contact.htm
