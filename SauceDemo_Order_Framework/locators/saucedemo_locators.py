LOCATORS = {
    "username": "xpath=//input[@id='user-name']",
    "password": "xpath=//input[@id='password']",
    "login_button": "xpath=//input[@id='login-button']",
    "products_title": "xpath=//span[@class='title' and normalize-space()='Products']",
    "add_backpack": (
        "xpath=//div[contains(@class,'inventory_item')][.//div[normalize-space()='Sauce Labs Backpack']]"
        "//button[starts-with(@id,'add-to-cart-')]"
    ),
    "add_red_tshirt": (
        "xpath=//div[contains(@class,'inventory_item')]"
        "[.//div[normalize-space()='Test.allTheThings() T-Shirt (Red)']]"
        "//button[starts-with(@id,'add-to-cart-')]"
    ),
    "cart_badge": "xpath=//span[@class='shopping_cart_badge']",
    "shopping_cart": "xpath=//a[@class='shopping_cart_link']",
    "cart_title": "xpath=//span[@class='title' and normalize-space()='Your Cart']",
    "cart_items": "xpath=//div[@class='cart_item']",
    "cart_backpack_name": (
        "xpath=//div[@class='cart_item'][.//div[normalize-space()='Sauce Labs Backpack']]"
        "//div[@class='inventory_item_name']"
    ),
    "cart_tshirt_name": (
        "xpath=//div[@class='cart_item']"
        "[.//div[normalize-space()='Test.allTheThings() T-Shirt (Red)']]"
        "//div[@class='inventory_item_name']"
    ),
    "checkout_button": "xpath=//button[@id='checkout']",
    "first_name": "xpath=//input[@id='first-name']",
    "last_name": "xpath=//input[@id='last-name']",
    "postal_code": "xpath=//input[@id='postal-code']",
    "continue_button": "xpath=//input[@id='continue']",
    "overview_title": "xpath=//span[@class='title' and normalize-space()='Checkout: Overview']",
    "overview_items": "xpath=//div[@class='cart_item']",
    "overview_backpack_name": (
        "xpath=//div[@class='cart_item'][.//div[normalize-space()='Sauce Labs Backpack']]"
        "//div[@class='inventory_item_name']"
    ),
    "overview_backpack_price": (
        "xpath=//div[@class='cart_item'][.//div[normalize-space()='Sauce Labs Backpack']]"
        "//div[@class='inventory_item_price']"
    ),
    "overview_tshirt_name": (
        "xpath=//div[@class='cart_item']"
        "[.//div[normalize-space()='Test.allTheThings() T-Shirt (Red)']]"
        "//div[@class='inventory_item_name']"
    ),
    "overview_tshirt_price": (
        "xpath=//div[@class='cart_item']"
        "[.//div[normalize-space()='Test.allTheThings() T-Shirt (Red)']]"
        "//div[@class='inventory_item_price']"
    ),
    "payment_information": "xpath=//div[@class='summary_value_label'][1]",
    "shipping_information": "xpath=//div[@class='summary_value_label'][2]",
    "subtotal": "xpath=//div[@class='summary_subtotal_label']",
    "tax": "xpath=//div[@class='summary_tax_label']",
    "total": "xpath=//div[@class='summary_total_label']",
    "finish_button": "xpath=//button[@id='finish']",
    "complete_title": "xpath=//span[@class='title' and normalize-space()='Checkout: Complete!']",
    "confirmation_message": "xpath=//h2[@class='complete-header']",
    "menu_button": "xpath=//button[@id='react-burger-menu-btn']",
    "logout_link": "xpath=//a[@id='logout_sidebar_link']",
}
