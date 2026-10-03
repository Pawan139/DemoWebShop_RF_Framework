*** Settings ***

Library     SeleniumLibrary


*** Variables ***

${browser}    chrome
${url}    https://demowebshop.tricentis.com/
${Login_Xpath}    //*[text()='Log in']
${Username_Xpath}    //*[@id='Email']
${Password_Xpath}    //*[@id='Password']
${Login_Xpath}    //*[@value='Log in']
${Username_value}    pawan.tyagi1993@gmail.com
${Password_value}    Mukul@786

${expected_title}    xyz
*** Keywords ***
*** Test Cases ***

First Test
    Open Browser    ${url}    ${browser}
    Maximize Browser Window
    Click Element    ${Login_Xpath}
    Sleep    3s
    Input Text    ${Username_Xpath}    ${Username_value}
    Sleep    3s
    Input Text    ${Password_Xpath}    ${Password_value}
    Sleep    3s
    Click Element    ${Login_Xpath}






