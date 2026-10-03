*** Settings ***

Library     Browser
Library    Dialogs
*** Variables ***

${browser}    chrome

@{browserr}    pawan    tyagi    suresh    sakshi
&{USER}    browser=chromium    headless=False


${url}    https://demowebshop.tricentis.com/
${Login_Xpath}    //*[text()='Log in']
${Username_Xpath}    //*[@id='Email']
${Password_Xpath}    //*[@id='Password']
${Login_Xpath}    //*[@value='Log in']
${Username_value}    pawan.tyagi1993@gmail.com
${Password_value}    Mukul@786

${expected_title}    xyz
*** Keywords ***
Open Browser

    New Browser    ${USER}[browser]     ${USER}[headless]
    New Context
    New Page    ${url}
    Click    ${Login_Xpath}
    Sleep    3s
Enter Username
     Fill Text    ${Username_Xpath}    ${Username_value}
    Sleep    3s
Enter Password
      Fill Secret    ${Password_Xpath}    $Password_value
    Sleep    3s
Enter login
     Click    ${Login_Xpath}
    Sleep    3s
Taking screenshot
    Take Screenshot