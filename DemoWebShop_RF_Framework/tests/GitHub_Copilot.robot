*** Settings ***
Documentation    20 DemoWebShop end-to-end tests using Robot Framework Browser and XPath selectors.
Library          Browser
Library          Collections
Library          OperatingSystem
Library          String
Test Setup       Open DemoWebShop
Test Teardown    Finish Test

*** Variables ***
${BASE_URL}                https://demowebshop.tricentis.com
${TEST_PASSWORD}           Test@1234
${FIRST_NAME}              John
${LAST_NAME}               Tester
${ZIP_CODE}                201301
${CITY}                    Noida
${ADDRESS}                 Sector 62
${PHONE}                   9999999999
${REGISTERED_EMAIL}        ${EMPTY}
${SCREENSHOT_DIRECTORY}    ${OUTPUT DIR}${/}screenshots

*** Test Cases ***
TC_DWS_001 Register With Valid Details
    ${email}=    Register Unique Customer
    Should Contain    ${email}    @example.com
    Verify Logged In    ${email}
    Capture Step    TC_DWS_001_registered

TC_DWS_002 Register With An Already Registered Email
    ${email}=    Ensure Registered Customer
    Open Registration Page
    Fill Registration Form    ${email}    ${TEST_PASSWORD}    ${TEST_PASSWORD}
    Click    xpath=//input[@id='register-button']
    Wait For Elements State    xpath=//li[contains(normalize-space(.),'The specified email already exists')]    visible    timeout=10s
    Capture Step    TC_DWS_002_duplicate_email

TC_DWS_003 Empty Registration Form Validation
    Open Registration Page
    Click    xpath=//input[@id='register-button']
    ${first_name_error}=    Get Text    xpath=//span[@data-valmsg-for='FirstName']
    ${last_name_error}=    Get Text    xpath=//span[@data-valmsg-for='LastName']
    ${email_error}=    Get Text    xpath=//span[@data-valmsg-for='Email']
    ${password_error}=    Get Text    xpath=//span[@data-valmsg-for='Password']
    ${confirm_error}=    Get Text    xpath=//span[@data-valmsg-for='ConfirmPassword']
    Should Contain    ${first_name_error}    First name is required
    Should Contain    ${last_name_error}    Last name is required
    Should Contain    ${email_error}    Email is required
    Should Contain    ${password_error}    Password is required
    Should Contain    ${confirm_error}    Password is required
    Capture Step    TC_DWS_003_empty_registration

TC_DWS_004 Registration Password Mismatch
    ${email}=    Generate Unique Email
    Open Registration Page
    Fill Registration Form    ${email}    Test@1234    Test@9999
    Click    xpath=//input[@id='register-button']
    Wait For Elements State    xpath=//span[@data-valmsg-for='ConfirmPassword' and contains(normalize-space(.),'do not match')]    visible    timeout=10s
    Capture Step    TC_DWS_004_password_mismatch

TC_DWS_005 Registration Password Too Short
    ${email}=    Generate Unique Email
    Open Registration Page
    Fill Registration Form    ${email}    Ab@12    Ab@12
    Click    xpath=//input[@id='register-button']
    ${error}=    Get Text    xpath=//span[@data-valmsg-for='Password']
    Should Contain    ${error}    6 characters
    Capture Step    TC_DWS_005_short_password

TC_DWS_006 Registration Invalid Email
    Open Registration Page
    Fill Registration Form    abc.com    ${TEST_PASSWORD}    ${TEST_PASSWORD}
    Click    xpath=//input[@id='register-button']
    ${error}=    Get Text    xpath=//span[@data-valmsg-for='Email']
    Should Contain    ${error}    Wrong email
    Capture Step    TC_DWS_006_invalid_email

TC_DWS_007 Login With Valid Credentials
    ${email}=    Ensure Registered Customer
    Login As    ${email}    ${TEST_PASSWORD}
    Verify Logged In    ${email}

TC_DWS_008 Login With Incorrect Password
    ${email}=    Ensure Registered Customer
    Open Login Page
    Fill Text    xpath=//input[@id='Email']    ${email}
    Fill Text    xpath=//input[@id='Password']    Wrong@999
    Click    xpath=//input[contains(@class,'login-button')]
    ${error}=    Get Text    xpath=//div[contains(@class,'validation-summary-errors')]
    Should Contain    ${error}    The credentials provided are incorrect
    Capture Step    TC_DWS_008_invalid_password

TC_DWS_009 Login With Unregistered Email
    Open Login Page
    ${email}=    Generate Unique Email
    Fill Text    xpath=//input[@id='Email']    ${email}
    Fill Text    xpath=//input[@id='Password']    ${TEST_PASSWORD}
    Click    xpath=//input[contains(@class,'login-button')]
    ${error}=    Get Text    xpath=//div[contains(@class,'validation-summary-errors')]
    Should Contain    ${error}    No customer account found
    Capture Step    TC_DWS_009_unregistered_email

TC_DWS_010 Login With Empty Fields
    Open Login Page
    Click    xpath=//input[contains(@class,'login-button')]
    ${error}=    Get Text    xpath=//div[contains(@class,'validation-summary-errors')]
    Should Contain    ${error}    Login was unsuccessful
    Capture Step    TC_DWS_010_empty_login

TC_DWS_011 Logout And Verify Session Ends
    ${email}=    Ensure Registered Customer
    Login As    ${email}    ${TEST_PASSWORD}
    Click    xpath=//a[contains(@class,'ico-logout')]
    Wait For Elements State    xpath=//a[contains(@class,'ico-login')]    visible    timeout=10s
    Wait For Elements State    xpath=//a[contains(@class,'ico-register')]    visible    timeout=10s
    Go Back
    Wait For Elements State    xpath=//a[contains(@class,'ico-login')]    visible    timeout=10s
    Capture Step    TC_DWS_011_logged_out

TC_DWS_012 Search For Matching Product
    Search For    laptop
    Wait For Elements State    xpath=//div[contains(@class,'search-results')]//h2/a[normalize-space()='14.1-inch Laptop']    visible    timeout=10s
    ${results}=    Get Text    xpath=//div[contains(@class,'search-results')]
    Should Contain    ${results}    Laptop
    Capture Step    TC_DWS_012_search_laptop

TC_DWS_013 Search With No Matches
    Search For    zzzxyz123
    Wait For Elements State    xpath=//strong[contains(@class,'result') and contains(normalize-space(.),'No products were found that matched your criteria')]    visible    timeout=10s
    Capture Step    TC_DWS_013_no_search_results

TC_DWS_014 Search Term Shorter Than Minimum
    Search For    ab
    Wait For Elements State    xpath=//strong[contains(@class,'warning') and contains(normalize-space(.),'Search term minimum length is 3 characters')]    visible    timeout=10s
    Capture Step    TC_DWS_014_short_search_term

TC_DWS_015 Advanced Search By Category
    Go To    ${BASE_URL}/search
    Fill Text    xpath=//input[@id='Q']    build your own
    Check Checkbox    xpath=//input[@id='As']
    Select Options By    xpath=//select[@id='Cid']    label    Computers
    Check Checkbox    xpath=//input[@id='Isc']
    Click    xpath=//input[contains(@class,'search-button')]
    ${results}=    Get Text    xpath=//div[contains(@class,'search-results')]
    Should Contain    ${results}    Build your own
    Capture Step    TC_DWS_015_advanced_search

TC_DWS_016 Navigate To Notebooks Category
    Hover    xpath=(//ul[contains(@class,'top-menu')]//a[normalize-space()='Computers'])[1]
    Wait For Elements State    xpath=(//ul[contains(@class,'top-menu')]//a[normalize-space()='Notebooks'])[1]    visible    timeout=5s
    Click    xpath=(//ul[contains(@class,'top-menu')]//a[normalize-space()='Notebooks'])[1]
    Wait For Elements State    xpath=//div[contains(@class,'page-title')]//h1[normalize-space()='Notebooks']    visible    timeout=10s
    Capture Step    TC_DWS_016_notebooks

TC_DWS_017 Sort Books By Price Low To High
    Go To    ${BASE_URL}/books
    Select Options By    xpath=//select[@id='products-orderby']    label    Price: Low to High
    Wait For Load State    networkidle
    ${selected_sort}=    Get Attribute    xpath=//select[@id='products-orderby']/option[@selected]    value
    Should Contain    ${selected_sort}    orderby=10
    ${product_count}=    Get Element Count    xpath=//div[contains(@class,'product-item')]
    Should Be True    ${product_count} > 0
    ${prices}=    Create List
    FOR    ${index}    IN RANGE    ${product_count}
        ${position}=    Evaluate    ${index} + 1
        ${raw_price}=    Get Text    xpath=(//div[contains(@class,'product-item')]//span[contains(@class,'price')])[${position}]
        ${price}=    Evaluate    float($raw_price.replace('$', '').replace(',', '').strip())
        Append To List    ${prices}    ${price}
    END
    ${sorted_prices}=    Evaluate    sorted($prices)
    Lists Should Be Equal    ${prices}    ${sorted_prices}
    Capture Step    TC_DWS_017_books_price_sorted

TC_DWS_018 Change Product Display Count
    Go To    ${BASE_URL}/books
    Select Options By    xpath=//select[@id='products-pagesize']    label    4
    ${four_count}=    Get Element Count    xpath=//div[contains(@class,'product-item')]
    Should Be True    ${four_count} > 0 and ${four_count} <= 4
    Select Options By    xpath=//select[@id='products-pagesize']    label    12
    Wait For Load State    domcontentloaded
    ${twelve_count}=    Get Element Count    xpath=//div[contains(@class,'product-item')]
    Should Be True    ${twelve_count} > 0 and ${twelve_count} <= 12
    Capture Step    TC_DWS_018_display_count

TC_DWS_019 Switch Between Grid And List
    Go To    ${BASE_URL}/books
    Select Options By    xpath=//select[@id='products-viewmode']    label    List
    Wait For Elements State    xpath=//div[contains(@class,'product-list')]    visible    timeout=10s
    ${list_count}=    Get Element Count    xpath=//div[contains(@class,'product-list')]//div[contains(@class,'product-item')]
    Select Options By    xpath=//select[@id='products-viewmode']    label    Grid
    Wait For Elements State    xpath=//div[contains(@class,'product-grid')]    visible    timeout=10s
    ${grid_count}=    Get Element Count    xpath=//div[contains(@class,'product-grid')]//div[contains(@class,'product-item')]
    Should Be Equal As Integers    ${list_count}    ${grid_count}
    Capture Step    TC_DWS_019_grid_and_list

TC_DWS_020 Verify Product Detail Page
    Open Laptop Product
    Wait For Elements State    xpath=//h1[normalize-space()='14.1-inch Laptop']    visible    timeout=10s
    Wait For Elements State    xpath=//span[@itemprop='price']    visible    timeout=10s
    Wait For Elements State    xpath=//input[@id='addtocart_31_EnteredQuantity']    visible    timeout=10s
    Wait For Elements State    xpath=//input[@id='add-to-cart-button-31']    visible    timeout=10s
    Wait For Elements State    xpath=//input[contains(@class,'add-to-compare-list-button')]    visible    timeout=10s
    Wait For Elements State    xpath=//input[contains(@class,'email-a-friend-button')]    visible    timeout=10s
    Capture Step    TC_DWS_020_product_details

*** Keywords ***
Open DemoWebShop
    Create Directory    ${SCREENSHOT_DIRECTORY}
    New Browser    chromium    headless=False
    New Context
    Set Browser Timeout    60s
    New Page    ${BASE_URL}    wait_until=domcontentloaded

Finish Test
    IF    '${TEST STATUS}' == 'FAIL'
        Capture Step    failure
    END
    Close Browser

Capture Step
    [Arguments]    ${step_name}
    ${safe_name}=    Replace String    ${step_name}    ${SPACE}    _
    Take Screenshot    ${SCREENSHOT_DIRECTORY}${/}${TEST NAME}_${safe_name}.png    timeout=30s

Generate Unique Email
    ${suffix}=    Generate Random String    10    [LOWER]
    RETURN    pawan.qa.${suffix}@example.com

Open Registration Page
    Go To    ${BASE_URL}/register
    Wait For Elements State    xpath=//input[@id='register-button']    visible    timeout=10s
    Capture Step    registration_page

Fill Registration Form
    [Arguments]    ${email}    ${password}    ${confirmation}
    Check Checkbox    xpath=//input[@id='gender-male']
    Fill Text    xpath=//input[@id='FirstName']    ${FIRST_NAME}
    Fill Text    xpath=//input[@id='LastName']    ${LAST_NAME}
    Fill Text    xpath=//input[@id='Email']    ${email}
    Fill Text    xpath=//input[@id='Password']    ${password}
    Fill Text    xpath=//input[@id='ConfirmPassword']    ${confirmation}
    Capture Step    registration_form_filled

Register Unique Customer
    ${email}=    Generate Unique Email
    Open Registration Page
    Fill Registration Form    ${email}    ${TEST_PASSWORD}    ${TEST_PASSWORD}
    Click    xpath=//input[@id='register-button']
    Wait For Elements State    xpath=//div[contains(@class,'result') and normalize-space(.)='Your registration completed']    visible    timeout=15s
    Set Suite Variable    ${REGISTERED_EMAIL}    ${email}
    Capture Step    registration_success
    Click    xpath=//input[@value='Continue']
    Wait For Elements State    xpath=//a[contains(@class,'ico-logout')]    visible    timeout=10s
    RETURN    ${email}

Ensure Registered Customer
    IF    $REGISTERED_EMAIL == ''
        ${email}=    Register Unique Customer
        Click    xpath=//a[contains(@class,'ico-logout')]
        Wait For Elements State    xpath=//a[contains(@class,'ico-login')]    visible    timeout=10s
    ELSE
        ${email}=    Set Variable    ${REGISTERED_EMAIL}
    END
    RETURN    ${email}

Open Login Page
    Go To    ${BASE_URL}/login
    Wait For Elements State    xpath=//input[@id='Email']    visible    timeout=10s
    Capture Step    login_page

Login As
    [Arguments]    ${email}    ${password}
    Open Login Page
    Fill Text    xpath=//input[@id='Email']    ${email}
    Fill Text    xpath=//input[@id='Password']    ${password}
    Capture Step    login_credentials_entered
    Click    xpath=//input[contains(@class,'login-button')]
    Wait For Load State    domcontentloaded
    Capture Step    login_submitted

Verify Logged In
    [Arguments]    ${email}
    Wait For Elements State    xpath=//a[contains(@class,'ico-logout')]    visible    timeout=10s
    ${account}=    Get Text    xpath=(//div[contains(@class,'header-links')]//a[contains(@class,'account')])[1]
    Should Be Equal As Strings    ${account}    ${email}
    Capture Step    logged_in

Search For
    [Arguments]    ${term}
    Fill Text    xpath=//input[@id='small-searchterms']    ${term}
    Capture Step    search_term_entered
    Click    xpath=//input[contains(@class,'search-box-button')]
    Wait For Load State    domcontentloaded

Open Laptop Product
    Go To    ${BASE_URL}/141-inch-laptop
    Wait For Elements State    xpath=//h1[normalize-space()='14.1-inch Laptop']    visible    timeout=10s
    Capture Step    laptop_product
