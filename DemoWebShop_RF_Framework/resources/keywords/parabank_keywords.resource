*** Settings ***
Library       Browser
Library       OperatingSystem
Library       String
Variables     ../locators/parabank_locators.py
Variables     ../data/parabank_test_data.py

*** Keywords ***
Open ParaBank
    New Browser    browser=chromium    headless=False    channel=msedge    args=["--start-maximized"]
    New Context
    Set Browser Timeout    20s
    New Page    ${BASE_URL}    wait_until=domcontentloaded
    Wait For Elements State    ${XPATH_HOME_USERNAME}    visible    timeout=15s

Close ParaBank
    Close Browser

Open Registration Page
    Click    ${XPATH_HOME_REGISTER_LINK}
    Wait For Elements State    ${XPATH_REGISTER_FORM}    visible    timeout=10s

Fill Registration Form
    [Arguments]    ${username}    ${password}    ${confirmation}
    Fill Text    ${XPATH_REGISTER_FIRST_NAME}    ${FIRST_NAME}
    Fill Text    ${XPATH_REGISTER_LAST_NAME}    ${LAST_NAME}
    Fill Text    ${XPATH_REGISTER_ADDRESS}    ${ADDRESS}
    Fill Text    ${XPATH_REGISTER_CITY}    ${CITY}
    Fill Text    ${XPATH_REGISTER_STATE}    ${STATE}
    Fill Text    ${XPATH_REGISTER_ZIP}    ${ZIP_CODE}
    Fill Text    ${XPATH_REGISTER_PHONE}    ${PHONE}
    Fill Text    ${XPATH_REGISTER_SSN}    ${SSN}
    Fill Text    ${XPATH_REGISTER_USERNAME}    ${username}
    Fill Text    ${XPATH_REGISTER_PASSWORD}    ${password}
    Fill Text    ${XPATH_REGISTER_CONFIRM_PASSWORD}    ${confirmation}

Register New Test Customer
    ${suffix}=    Generate Random String    10    [LOWER]
    ${username}=    Set Variable    ${USERNAME_PREFIX}${suffix}
    Open Registration Page
    Fill Registration Form    ${username}    ${TEST_PASSWORD}    ${TEST_PASSWORD}
    Click    ${XPATH_REGISTER_BUTTON}
    Wait For Elements State    ${XPATH_NAV_OVERVIEW}    visible    timeout=15s
    Set Suite Variable    ${PARABANK_TEST_USERNAME}    ${username}
    Set Suite Variable    ${PARABANK_TEST_PASSWORD}    ${TEST_PASSWORD}
    RETURN    ${username}

Ensure Test Customer
    IF    $PARABANK_TEST_USERNAME == ''
        Register New Test Customer
        Logout ParaBank
    END
    RETURN    ${PARABANK_TEST_USERNAME}

Login With Credentials
    [Arguments]    ${username}    ${password}
    Fill Text    ${XPATH_HOME_USERNAME}    ${username}
    Fill Text    ${XPATH_HOME_PASSWORD}    ${password}
    Click    ${XPATH_HOME_LOGIN_BUTTON}
    Wait For Elements State    ${XPATH_NAV_OVERVIEW}    visible    timeout=15s

Login As Test Customer
    ${username}=    Ensure Test Customer
    Login With Credentials    ${username}    ${PARABANK_TEST_PASSWORD}
    RETURN    ${username}

Logout ParaBank
    Click    ${XPATH_NAV_LOGOUT}
    Wait For Elements State    ${XPATH_HOME_USERNAME}    visible    timeout=10s

Open Account Overview
    Click    ${XPATH_NAV_OVERVIEW}
    Wait For Elements State    ${XPATH_ACCOUNT_TABLE}    visible    timeout=10s

Open Extra Account
    [Arguments]    ${account_type}
    Click    ${XPATH_NAV_OPEN_ACCOUNT}
    Wait For Elements State    ${XPATH_OPEN_ACCOUNT_TYPE}    visible    timeout=10s
    Select Options By    ${XPATH_OPEN_ACCOUNT_TYPE}    label    ${account_type}
    Select Options By    ${XPATH_OPEN_ACCOUNT_FROM}    index    0
    Click    ${XPATH_OPEN_ACCOUNT_BUTTON}
    Wait For Elements State    ${XPATH_NEW_ACCOUNT_ID}    visible    timeout=15s
    ${account_id}=    Get Text    ${XPATH_NEW_ACCOUNT_ID}
    RETURN    ${account_id}

Ensure Two Accounts
    Login As Test Customer
    Click    ${XPATH_NAV_TRANSFER}
    Wait For Elements State    ${XPATH_TRANSFER_FROM}    visible    timeout=10s
    ${account_count}=    Get Element Count    ${XPATH_TRANSFER_ACCOUNT_OPTIONS}
    IF    ${account_count} < 2
        Open Extra Account    SAVINGS
        Click    ${XPATH_NAV_TRANSFER}
        ${account_count}=    Get Element Count    ${XPATH_TRANSFER_ACCOUNT_OPTIONS}
        IF    ${account_count} < 2
            Open Extra Account    CHECKING
        END
    END

Fill Bill Pay Form
    Fill Text    ${XPATH_BILL_NAME}    ${PAYEE_NAME}
    Fill Text    ${XPATH_BILL_ADDRESS}    ${PAYEE_ADDRESS}
    Fill Text    ${XPATH_BILL_CITY}    ${PAYEE_CITY}
    Fill Text    ${XPATH_BILL_STATE}    ${PAYEE_STATE}
    Fill Text    ${XPATH_BILL_ZIP}    ${PAYEE_ZIP_CODE}
    Fill Text    ${XPATH_BILL_PHONE}    ${PAYEE_PHONE}
    Fill Text    ${XPATH_BILL_ACCOUNT}    ${PAYEE_ACCOUNT_NUMBER}
    Fill Text    ${XPATH_BILL_CONFIRM_ACCOUNT}    ${PAYEE_ACCOUNT_NUMBER}
    Fill Text    ${XPATH_BILL_AMOUNT}    ${PAYMENT_AMOUNT}
    Select Options By    ${XPATH_BILL_FROM_ACCOUNT}    index    0

Open Find Transactions
    Click    ${XPATH_NAV_FIND_TRANSACTIONS}
    Wait For Elements State    ${XPATH_FIND_ACCOUNT}    visible    timeout=10s
