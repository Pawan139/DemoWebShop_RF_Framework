# DemoWebShop Login Automation - Robot Framework

Automation suite for the Login flow of **https://demowebshop.tricentis.com/login**,
built with **Robot Framework + SeleniumLibrary**, using a strict **L1 / L2 / L3
Page Object Model** layering.

## Folder Structure

```
DemoWebShop_RF_Framework/
├── resources/
│   ├── locators/
│   │   ├── login_locators.resource          # All Login page selectors
│   │   └── registration_locators.resource    # All Registration page selectors
│   └── keywords/
│       ├── L1_element_keywords/              # One keyword = one element action
│       │   ├── login_page_keywords.resource
│       │   └── registration_page_keywords.resource
│       └── L2_business_keywords/             # Composite, reusable business flows
│           └── account_business_keywords.resource
├── variables/
│   └── global_variables.resource             # URLs, browser config, timeouts, test data
├── tests/
│   └── login_test_suite.robot                # L3 - the 5 test cases
├── results/
│   └── screenshots/                          # Screenshot evidence, one per action
├── requirements.txt
└── README.md
```

## Why This Layering (POM + Keyword-Driven Hybrid)

The two most widely used design patterns in Robot Framework projects are:

1. **Page Object Model (POM)** - locators and page interactions are isolated per
   page, so a UI change only requires updating one locator file, never the tests.
2. **Keyword-Driven Testing** - Robot Framework's native strength. Test cases read
   as plain-English business steps instead of code, so non-technical stakeholders
   can follow them.

This framework combines both as three explicit layers:

| Layer | Folder | Responsibility |
|---|---|---|
| **L1 - Element** | `L1_element_keywords/` | One keyword per UI action (click, type, read). No business logic. |
| **L2 - Business** | `L2_business_keywords/` | Combines L1 keywords into a meaningful flow (e.g. "Login With Valid Credentials"). |
| **L3 - Test Case** | `tests/*.robot` | Calls only L2/L1 keywords. Reads like a test script, not code. |

Every L1 action keyword also captures a screenshot (`Capture Page Screenshot Step`),
so every run leaves a full visual trail in `results/screenshots/`.

## Setup

```bash
pip install -r requirements.txt
```

You'll also need a matching browser driver on PATH (e.g. `chromedriver`), or use
`webdriver-manager` (already in requirements.txt) to fetch it automatically -
add this once near the top of `login_test_suite.robot`'s `Open Browser To
Application` keyword if you want it fully automatic:

```robot
Open Browser To Application
    ${driver_path}=    Evaluate    __import__('webdriver_manager.chrome', fromlist=['ChromeDriverManager']).ChromeDriverManager().install()
    Open Browser    ${BASE_URL}    ${BROWSER}    executable_path=${driver_path}
```

## Running the Suite

```bash
robot --outputdir results tests/login_test_suite.robot
```

Run only smoke tests:
```bash
robot --outputdir results --include smoke tests/login_test_suite.robot
```

Results (`report.html`, `log.html`, `output.xml`) land in `results/`.

## Test Cases

| ID | Name | Type | What it Verifies |
|---|---|---|---|
| TC01 | Login Page Loads With All Required Elements | Smoke / UI | Email field, Password field, Log in button, Register link all render. |
| TC02 | Register A New Customer For Login Testing | Setup | Creates a fresh, uniquely-emailed account (DemoWebShop requires a real registered account to log in) and hands the credentials to TC03 via a suite variable. |
| TC03 | Successful Login With Valid Registered Credentials | Positive | Logs in with the account from TC02; confirms the header shows "Log out" (i.e. an authenticated session). |
| TC04 | Login Fails With Incorrect Password | Negative | Wrong password against a valid-format email; verifies the "credentials incorrect" validation message. |
| TC05 | Login Fails With Empty Email And Password | Negative / Validation | Submits the form blank; verifies the "Login was unsuccessful" validation message. |

**Note on TC02/TC03 dependency:** DemoWebShop is a public demo site with no fixed
valid login account - every account must be registered first. TC02 registers one
and stores its email as `${REGISTERED_EMAIL}` (a suite variable) so TC03 can log in
with it. TC03 has a `Skip If` guard in case TC02 didn't run or failed.

## Extending the Framework

- **New page** → add a locator file under `resources/locators/`, an L1 keyword
  file under `L1_element_keywords/`, and (if there's a multi-step flow) an L2
  file under `L2_business_keywords/`.
- **New test case** → add it to `tests/login_test_suite.robot` (or a new
  `.robot` file under `tests/`) calling only L1/L2 keywords - never a raw
  SeleniumLibrary keyword or hardcoded locator directly in a test case.
