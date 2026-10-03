*** Settings ***
Documentation    L1 (Element Layer) - one keyword per UI interaction on the Registration page.
Resource         ${EXECDIR}/resources/locators/registration_locators.resource
Resource         ${EXECDIR}/resources/keywords/L1_element_keywords/login_page_keywords.resource
Resource         ${EXECDIR}/variables/global_variables.resource
Library          SeleniumLibrary

*** Keywords ***
Open Registration Page
    [Documentation]    Navigates directly to the Registration page URL.
    Go To    ${REGISTER_URL}
    Wait Until Element Is Visible    ${REG_FIRST_NAME_FIELD}    timeout=${EXPLICIT_TIMEOUT}
    Capture Page Screenshot Step    open_registration_page

Select Gender
    [Arguments]    ${gender}=Male
    [Documentation]    Selects the Male or Female radio button.
    Run Keyword If    '${gender}' == 'Male'
    ...    Click Element    ${GENDER_MALE_RADIO}
    ...  ELSE
    ...    Click Element    ${GENDER_FEMALE_RADIO}
    Capture Page Screenshot Step    select_gender

Enter First Name
    [Arguments]    ${first_name}
    Input Text    ${REG_FIRST_NAME_FIELD}    ${first_name}
    Capture Page Screenshot Step    enter_first_name

Enter Last Name
    [Arguments]    ${last_name}
    Input Text    ${REG_LAST_NAME_FIELD}    ${last_name}
    Capture Page Screenshot Step    enter_last_name

Enter Registration Email
    [Arguments]    ${email}
    Input Text    ${REG_EMAIL_FIELD}    ${email}
    Capture Page Screenshot Step    enter_registration_email

Enter Registration Password
    [Arguments]    ${password}
    Input Text    ${REG_PASSWORD_FIELD}    ${password}
    Capture Page Screenshot Step    enter_registration_password

Enter Registration Confirm Password
    [Arguments]    ${password}
    Input Text    ${REG_CONFIRM_PASSWORD_FIELD}    ${password}
    Capture Page Screenshot Step    enter_registration_confirm_password

Click Register Button
    [Documentation]    Submits the registration form.
    Click Element    ${REG_BUTTON}
    Wait Until Element Is Visible    ${REG_SUCCESS_MESSAGE}    timeout=${EXPLICIT_TIMEOUT}
    Capture Page Screenshot Step    click_register_button

Get Registration Success Text
    ${text}=    Get Text    ${REG_SUCCESS_MESSAGE}
    [Return]    ${text}
