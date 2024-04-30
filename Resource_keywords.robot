*** Settings ***
Library           SeleniumLibrary
Library           String
Library           Collections
Resource          Resource_variable.robot

*** Keywords ***
Login_To_Amazon
    [Arguments]    ${ID}    ${Password}
    Wait Until Element Is Visible    ${Xpath_for_Signing_in}
    click element    ${Xpath_for_Signing_in}
    input text    ${Xpath_for_ID}    ${ID}
    click element    ${Xpath_for_Sign_in_Continue_post_id}
    input text    ${Xpath_for_password}    ${Password}
    click element    ${Xpath_for_sign_in_button}

Add_Price_Filter
    [Arguments]    ${min_value}    ${max_value}
    Wait Until Element Is Visible    ${Xpath_min_filter}    timeout=30s
    Click Element    ${Xpath_min_filter}
    Input Text    ${Xpath_min_filter}    ${min_value}
    Input Text    ${Xpath_Max_filter}    ${max_value}
    Press Keys    ${Xpath_Max_filter}    ENTER

Looking for
    [Arguments]    ${catergoryofPurchase}
    Wait Until Element Is Visible    ${Xpath_for_Amazon_search_bar}    timeout=30s
    Click Element    ${Xpath_for_Amazon_search_bar}
    Input Text    ${Xpath_for_Amazon_search_bar}    ${catergoryofPurchase}
    Press Keys    ${Xpath_for_Amazon_search_bar}    ENTER

Validate_Price_filter
    [Arguments]    ${min_value}    ${max_value}
    @{elements}    Get WebElements    ${Xpath_for_getting_Price_of_Product}
    @{text_list}=    Create List
    FOR    ${element}    IN    @{elements}
        ${text}=    Get text    ${element}
        ${inttext}=    Evaluate    "${text}".replace(",","")
        ${text}=    Convert To Number    ${inttext}
        Run Keyword IF    ${text}>30000    log    Filter Functionality is working correctly
        Run Keyword IF    ${text}<50000    log    Filter Functionality is working correctly
        Run Keyword IF    not ${text}>30000    LOg    They might be an issue with Filter functionality
        Run Keyword IF    not ${text}<50000    LOg    They might be an issue with Filter functionality
        Append to List    ${text_list}    ${text}
    END
    Log    Text from page :${text_list}
    Go_TO_PAGE    2
    @{elements}    Get WebElements    ${Xpath_for_getting_Price_of_Product}
    @{text_list}=    Create List
    FOR    ${element}    IN    @{elements}
        ${text}=    Get text    ${element}
        ${inttext}=    Evaluate    "${text}".replace(",","")
        ${text}=    Convert To Number    ${inttext}
        Run Keyword IF    ${text}>30000    log    Filter Functionality is working correctly
        Run Keyword IF    ${text}<50000    log    Filter Functionality is working correctly
        Run Keyword IF    not ${text}>30000    LOg    They might be an issue with Filter functionality
        Run Keyword IF    not ${text}<50000    LOg    They might be an issue with Filter functionality
        Append to List    ${text_list}    ${text}
    END
    Log    Text from page :${text_list}
    Go_TO_PAGE    1

Go_TO_PAGE
    [Arguments]    ${PAGE_NO}
    Wait Until Element Is Visible    //a[text()=${PAGE_NO}]
    Click element    //a[text()=${PAGE_NO}]
    sleep    30s

Get_Print_Product_with_Ratings
    [Arguments]    ${Rating}
    @{elements}    Get WebElements    //*[text()="${Rating} out of 5 stars"]/../../../../../../preceding-sibling::div
    @{text_list}=    Create List
    FOR    ${element}    IN    @{elements}
        ${text}=    Get text    ${element}
        Append to List    ${text_list}    ${text}
    END
    Log    ${text_list}
    Go_TO_PAGE    2
    @{elements}    Get WebElements    //*[text()="${Rating} out of 5 stars"]/../../../../../../preceding-sibling::div
    FOR    ${element}    IN    @{elements}
        ${text}=    Get text    ${element}
        Append to List    ${text_list}    ${text}
    END
    log    ${text_list}
    Go_TO_PAGE    1
    RETURN    ${text_list}

Getting First product from the List
    [Arguments]    ${products}
    #Printing First
    ${selectedLappi}=    Set Variable    ${products[0]}
    Log    Selected Laptop is :${selectedLappi}
    ${selectedLappi}=    Split String    ${selectedLappi}    ,
    log    ${selectedLappi[0]}
    ${selectedLappi2}=    Split String    ${products[1]}    ,
    log    ${selectedLappi2[0]}
    ${element1IsPresent}=    Run keyword and return status    Page Should Contain Element    //*[contains(text(),"${selectedLappi[0]}")]
    ${element2IsPresent}=    Run keyword and return status    Page Should Contain Element    //*[contains(text(),"${selectedLappi2[0]}")]
    Run Keyword If    ${element1IsPresent}    click element    //*[contains(text(),"${selectedLappi[0]}")]
    Run Keyword Unless    ${element1IsPresent}    click element    //*[contains(text(),"${selectedLappi2[0]}")]
    switch window    locator=NEW    timeout=30s
    ${title}=    get title
    log    ${title}
    RETURN    ${selectedLappi}

Navigating to the product window
    [Arguments]    ${product}
    Comment    Click Element    //*[contains(text(),"${product[0]}")]
    Comment    Switch Window    locator=NEW    timeout=10s
    Comment    ${title}=    get title
    Comment    log    ${title}

AddingProductToWishList
    [Arguments]    ${product}
    Wait Until Element Is Visible    //*[@id="wishListMainButton"]
    Click Element    //*[@id="wishListMainButton"]
    sleep    10s
    Comment    Click Element    //*[@id="atwl-dd-create-list"]
    Comment    Press Keys    ENTER

Verifying_wishList_With_Latest_product
    [Arguments]    ${product}
    Click Element    //*[text()="View Your List"]
    ${element_present}=    Run Keyword and return status    Wait Until Page Contains Element    //*[contains(text(),"${product}")]    timeout=10s
    Run Keyword If    ${element_present}    Log    Product is added to the wish list
    Run Keyword If    not ${element_present}    Log    Product is not added to the wish list

Search_in_Google_print_Result_and_Navigate_to_amazon
    [Arguments]    ${site}
    Input Text    //*[@class="gLFyf"]    ${SEARCH_TERM}
    Press Keys    //*[@class="gLFyf"]    ENTER
    @{elements}    Get WebElements    //div[@class="ULSxyf"]
    @{text_list}=    Create List
    FOR    ${element}    IN    @{elements}
        ${text}=    Get text    ${element}
        Append to List    ${text_list}    ${text}
    END
    Log    ${text_list}
    Click Element    //*[@data-dtld="amazon.in"]
    Title Should Be    Online Shopping site in India: Shop Online for Mobiles, Books, Watches, Shoes and More - Amazon.in
    RETURN    ${text_list}
