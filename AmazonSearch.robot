*** Settings ***
Library           SeleniumLibrary    # Import SeleniumLibrary for browser automation
Library           OperatingSystem    # For potential screenshot capture (optional)
Library           Collections    # For list related functions
Resource          Resource_variable.robot
Resource          Resource_keywords.robot
Library           Decimal
Library           String

*** Test Cases ***
Add_DellLaptop_to_WishList
    Open Browser    ${amazon_url}    ${browser}
    Maximize browser window
    Search_in_Google_print_Result_and_Navigate_to_amazon    ${SEARCH_TERM}
    Login_To_Amazon    ${ID}    ${PASSWORD}
    Looking for    Dell Laptops
    Add_Price_Filter    ${MIN_PRICE}    ${MAX_PRICE}
    Validate_Price_filter    ${MIN_PRICE}    ${MAX_PRICE}
    ${products}    Get_Print_Product_with_Ratings    3.5
    ${selectedLappi}    Getting First product from the List    ${products}
    Navigating to the product window    ${selectedLappi}
    AddingProductToWishList    ${selectedLappi}
    Verifying_wishList_With_Latest_product    ${selectedLappi}
