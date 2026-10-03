*** Settings ***
Documentation    Centralized locators for the Registration page (https://demowebshop.tricentis.com/register).

*** Variables ***
${GENDER_MALE_RADIO}           id:gender-male
${GENDER_FEMALE_RADIO}         id:gender-female
${REG_FIRST_NAME_FIELD}        id:FirstName
${REG_LAST_NAME_FIELD}         id:LastName
${REG_EMAIL_FIELD}             id:Email
${REG_PASSWORD_FIELD}          id:Password
${REG_CONFIRM_PASSWORD_FIELD}  id:ConfirmPassword
${REG_BUTTON}                  id:register-button
${REG_SUCCESS_MESSAGE}         css:div.result
${REG_VALIDATION_SUMMARY}      css:div.validation-summary-errors
