*** Settings ***
Library       Browser
Library       Collections
Library       OperatingSystem
Library       ../libraries/order_pdf.py
Variables     ../locators/saucedemo_locators.py
Variables     ../data/saucedemo_data.py

*** Keywords ***
Open SauceDemo
    Set Suite Variable    ${DOWNLOAD_DIR}    ${OUTPUT DIR}${/}downloads
    Set Suite Variable    ${SCREENSHOT_DIR}    ${OUTPUT DIR}${/}screenshots
    Create Directory    ${DOWNLOAD_DIR}
    Create Directory    ${SCREENSHOT_DIR}
    New Browser    chromium    headless=True    downloadsPath=${DOWNLOAD_DIR}
    New Context
    New Page    ${BASE_URL}
    Wait For Elements State    ${LOCATORS}[username]    visible    timeout=20s
    Capture Step Screenshot    01_login_page

Login As Standard User
    Fill Text    ${LOCATORS}[username]    ${SAUCE_USERNAME}
    Capture Step Screenshot    02_username_entered
    Fill Text    ${LOCATORS}[password]    ${SAUCE_PASSWORD}
    Take Screenshot    ${SCREENSHOT_DIR}${/}03_password_entered.png    mask=${LOCATORS}[password]    fullPage=True
    Click    ${LOCATORS}[login_button]
    Wait For Elements State    ${LOCATORS}[products_title]    visible    timeout=15s
    Capture Step Screenshot    04_login_success

Add Product To Cart
    [Arguments]    ${product_name}
    IF    $product_name == $PRODUCT_NAMES[0]
        ${add_button}=    Set Variable    ${LOCATORS}[add_backpack]
    ELSE IF    $product_name == $PRODUCT_NAMES[1]
        ${add_button}=    Set Variable    ${LOCATORS}[add_red_tshirt]
    ELSE
        Fail    No add-to-cart locator is configured for ${product_name}.
    END
    Click    ${add_button}
    Wait For Elements State    ${LOCATORS}[cart_badge]    visible    timeout=5s
    Capture Step Screenshot    add_${product_name}

Open Shopping Cart
    Click    ${LOCATORS}[shopping_cart]
    Wait For Elements State    ${LOCATORS}[cart_title]    visible    timeout=10s
    ${item_count}=    Get Element Count    ${LOCATORS}[cart_items]
    Should Be Equal As Integers    ${item_count}    2
    ${backpack_name}=    Get Text    ${LOCATORS}[cart_backpack_name]
    ${tshirt_name}=    Get Text    ${LOCATORS}[cart_tshirt_name]
    Should Be Equal As Strings    ${backpack_name}    ${PRODUCT_NAMES}[0]
    Should Be Equal As Strings    ${tshirt_name}    ${PRODUCT_NAMES}[1]
    Capture Step Screenshot    shopping_cart

Start Checkout
    Click    ${LOCATORS}[checkout_button]
    Wait For Elements State    ${LOCATORS}[first_name]    visible    timeout=10s
    Capture Step Screenshot    checkout_information

Enter Checkout Information
    Fill Text    ${LOCATORS}[first_name]    ${CHECKOUT_DATA}[first_name]
    Capture Step Screenshot    checkout_first_name_entered
    Fill Text    ${LOCATORS}[last_name]    ${CHECKOUT_DATA}[last_name]
    Capture Step Screenshot    checkout_last_name_entered
    Fill Text    ${LOCATORS}[postal_code]    ${CHECKOUT_DATA}[postal_code]
    Capture Step Screenshot    checkout_postal_code_entered
    ${first_name}=    Get Attribute    ${LOCATORS}[first_name]    value
    ${last_name}=    Get Attribute    ${LOCATORS}[last_name]    value
    ${postal_code}=    Get Attribute    ${LOCATORS}[postal_code]    value
    Should Be Equal As Strings    ${first_name}    ${CHECKOUT_DATA}[first_name]
    Should Be Equal As Strings    ${last_name}    ${CHECKOUT_DATA}[last_name]
    Should Be Equal As Strings    ${postal_code}    ${CHECKOUT_DATA}[postal_code]
    Capture Step Screenshot    checkout_information_verified

Continue To Order Overview
    Click    ${LOCATORS}[continue_button]
    Wait For Elements State    ${LOCATORS}[overview_title]    visible    timeout=10s
    Capture Step Screenshot    order_overview

Verify Order Overview
    ${item_count}=    Get Element Count    ${LOCATORS}[overview_items]
    Should Be Equal As Integers    ${item_count}    2
    ${backpack_name}=    Get Text    ${LOCATORS}[overview_backpack_name]
    ${backpack_price}=    Get Text    ${LOCATORS}[overview_backpack_price]
    ${tshirt_name}=    Get Text    ${LOCATORS}[overview_tshirt_name]
    ${tshirt_price}=    Get Text    ${LOCATORS}[overview_tshirt_price]
    ${payment}=    Get Text    ${LOCATORS}[payment_information]
    ${shipping}=    Get Text    ${LOCATORS}[shipping_information]
    ${subtotal}=    Get Text    ${LOCATORS}[subtotal]
    ${tax}=    Get Text    ${LOCATORS}[tax]
    ${total}=    Get Text    ${LOCATORS}[total]
    Should Be Equal As Strings    ${backpack_name}    ${PRODUCT_NAMES}[0]
    Should Be Equal As Strings    ${backpack_price}    ${PRODUCT_PRICES}[0]
    Should Be Equal As Strings    ${tshirt_name}    ${PRODUCT_NAMES}[1]
    Should Be Equal As Strings    ${tshirt_price}    ${PRODUCT_PRICES}[1]
    Should Be Equal As Strings    ${payment}    ${EXPECTED_PAYMENT}
    Should Be Equal As Strings    ${shipping}    ${EXPECTED_SHIPPING}
    Should Be Equal As Strings    ${subtotal}    ${EXPECTED_SUBTOTAL}
    Should Be Equal As Strings    ${tax}    ${EXPECTED_TAX}
    Should Be Equal As Strings    ${total}    ${EXPECTED_TOTAL}
    Capture Step Screenshot    order_overview_verified
    &{order_details}=    Create Dictionary
    ...    first_name=${CHECKOUT_DATA}[first_name]
    ...    last_name=${CHECKOUT_DATA}[last_name]
    ...    postal_code=${CHECKOUT_DATA}[postal_code]
    ...    backpack_name=${backpack_name}
    ...    backpack_price=${backpack_price}
    ...    tshirt_name=${tshirt_name}
    ...    tshirt_price=${tshirt_price}
    ...    payment=${payment}
    ...    shipping=${shipping}
    ...    subtotal=${subtotal}
    ...    tax=${tax}
    ...    total=${total}
    RETURN    &{order_details}

Finish Order
    Click    ${LOCATORS}[finish_button]
    Wait For Elements State    ${LOCATORS}[complete_title]    visible    timeout=10s
    ${confirmation}=    Get Text    ${LOCATORS}[confirmation_message]
    Should Be Equal As Strings    ${confirmation}    Thank you for your order!
    Capture Step Screenshot    order_completed

Generate Order Receipt PDF
    [Arguments]    ${order_details}
    ${pdf_path}=    Create Order Receipt PDF    ${DOWNLOAD_DIR}    ${order_details}
    File Should Exist    ${pdf_path}
    ${size}=    Get File Size    ${pdf_path}
    Should Be True    ${size} > 0
    Capture Step Screenshot    order_receipt_pdf_created
    RETURN    ${pdf_path}

Verify And Print Order Receipt PDF
    [Arguments]    ${pdf_path}
    ${pdf_text}=    Read PDF Text    ${pdf_path}
    Should Contain    ${pdf_text}    ${CHECKOUT_DATA}[first_name]
    Should Contain    ${pdf_text}    ${CHECKOUT_DATA}[last_name]
    Should Contain    ${pdf_text}    ${CHECKOUT_DATA}[postal_code]
    Should Contain    ${pdf_text}    ${PRODUCT_NAMES}[0]
    Should Contain    ${pdf_text}    ${PRODUCT_NAMES}[1]
    Should Contain    ${pdf_text}    ${PRODUCT_PRICES}[0]
    Should Contain    ${pdf_text}    ${PRODUCT_PRICES}[1]
    Should Contain    ${pdf_text}    ${EXPECTED_PAYMENT}
    Should Contain    ${pdf_text}    ${EXPECTED_SHIPPING}
    Should Contain    ${pdf_text}    ${EXPECTED_SUBTOTAL}
    Should Contain    ${pdf_text}    ${EXPECTED_TAX}
    Should Contain    ${pdf_text}    ${EXPECTED_TOTAL}
    Should Contain    ${pdf_text}    Order status: Complete
    Log To Console    \nPDF receipt: ${pdf_path}\n${pdf_text}

Logout From SauceDemo
    Click    ${LOCATORS}[menu_button]
    Wait For Elements State    ${LOCATORS}[logout_link]    visible    timeout=5s
    Capture Step Screenshot    logout_menu
    Click    ${LOCATORS}[logout_link]
    Wait For Elements State    ${LOCATORS}[username]    visible    timeout=10s
    Capture Step Screenshot    logged_out

Capture Step Screenshot
    [Arguments]    ${step_name}
    Take Screenshot    ${SCREENSHOT_DIR}${/}${step_name}.png    fullPage=True

Close SauceDemo Browser
    Close Browser
