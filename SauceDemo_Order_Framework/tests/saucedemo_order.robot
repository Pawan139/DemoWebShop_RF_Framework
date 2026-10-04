*** Settings ***
Documentation    End-to-end SauceDemo checkout, order receipt PDF, and logout flow.
Resource         ../resources/order_keywords.resource
Suite Teardown   Close SauceDemo Browser

*** Test Cases ***
Place Order And Verify PDF Receipt
    [Documentation]    Logs in as standard_user, orders two products, validates checkout,
    ...                completes the order, creates and reads a PDF receipt, then logs out.
    [Tags]    saucedemo    checkout    smoke
    Open SauceDemo
    Login As Standard User
    Add Product To Cart    Sauce Labs Backpack
    Add Product To Cart    Test.allTheThings() T-Shirt (Red)
    Open Shopping Cart
    Start Checkout
    Enter Checkout Information
    Continue To Order Overview
    ${order_details}=    Verify Order Overview
    Finish Order
    ${pdf_path}=    Generate Order Receipt PDF    ${order_details}
    Verify And Print Order Receipt PDF    ${pdf_path}
    Logout From SauceDemo
