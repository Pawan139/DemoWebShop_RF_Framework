*** Settings ***
Documentation    Global variables shared across the DemoWebShop automation suite.
...              Centralized here so environment/browser changes never require touching
...              keyword or test files (single point of maintenance).

*** Variables ***
# --- Application URLs ---
${BASE_URL}              https://demowebshop.tricentis.com
${LOGIN_URL}              ${BASE_URL}/login
${REGISTER_URL}           ${BASE_URL}/register

# --- Browser Configuration ---
${BROWSER}                 chrome
${BROWSER_OPTIONS}         add_argument("--start-maximized");add_argument("--disable-notifications")
${IMPLICIT_WAIT}           10s
${EXPLICIT_TIMEOUT}        15s

# --- Screenshot Configuration ---
${SCREENSHOT_DIR}          ${EXECDIR}${/}results${/}screenshots
${SCREENSHOT_ON_ACTION}    ${TRUE}

# --- Test Data (dynamically overridden at runtime for registration) ---
${GENDER}                  Male
${FIRST_NAME}               Pawan
${LAST_NAME}                 QA
${VALID_PASSWORD}            Test@12345
${INVALID_PASSWORD}          WrongPass@999
