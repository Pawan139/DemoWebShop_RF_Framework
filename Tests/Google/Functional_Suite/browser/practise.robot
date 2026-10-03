*** Settings ***
Documentation    
Library          Collections
Library          String

*** Variables ***
@{mobilephones}    apple nokia    samsung    oppo    vivo    lava    oneplus

*** Test Cases ***
Example Test
        FOR    ${mobilephone}    IN    @{mobilephones}
        Log    values are : ${mobilephone}
                Log To Console    values are : ${mobilephone}
        IF    '${mobilephone}' == 'samsung'

             Exit For Loop If    '${mobilephone}'=='samsung'
        END
        END

*** Keywords ***



