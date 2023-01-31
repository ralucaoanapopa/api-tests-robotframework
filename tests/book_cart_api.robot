*** Settings ***
Documentation    Tests for BookCartAPI
Resource        ../variables.robot
Resource        ../book_cart_keywords.robot
Library         REST
Suite Setup      Setup before running Suite
Force Tags    book-cart-api

*** Test Cases ***
GET /Book, 200, when list all books
    [Tags]    book
    List all books
    Integer     response status                200
    Output
    Array       response body
    Integer     response body 0 bookId         2
    String      response body 0 title          HP2
    String      response body 0 author         JKR
    String      response body 0 category       Mystery
    Number      response body 0 price          235.0
    String      response body 0 coverFileName

GET /Book/{book_id}, 200, when read one book
    [Tags]    book
    Read one book    ${book_id}
    Integer     response status                200
    Output
    Verify response book model
    Integer     response body bookId           ${book_id}
    String      response body title            ${book_title}
    String      response body author           ${book_author}
    String      response body category         ${book_category}

GET /Book/GetCategoriesList, 200, when list all categories
    [Tags]    book
    List all categories
    Integer     response status                200
    Verify response list categories

GET /Book/GetSimilarBooks/{book_id}, 200, when list similar books
    [Tags]    book
    List similar books    ${book_id}
    Integer     response status                200
    Verify response similar books

GET /User/validateUserName/{username}, 200, when check username availability (does not exist)
    [Tags]    user
    Check user availability    ${user_name_not}
    Integer     response status                200
    Boolean     response body                  ${false}

POST /User, 200, when register a new user
    [Tags]    user
    Register new user
    Integer     response status                200

GET /User/validateUserName/{username}, 200, when check username availability (user exists)
    [Tags]    user
    Register new user
    Integer     response status                200
    Check user availability    ${user_name_new}
    Integer     response status                200
    Boolean     response body                  ${true}

GET /User/{user_id}, 200, when read the count of items in the shopping cart
    [Tags]    user
    Get number of items from shopping cart for a user   ${user_id}
    Integer     response status                200
    Integer     response body                  0

GET /Wishlist, 200, when list items from a user's wishlist
    [Tags]    wishlist
    List wishlist for a user    ${user_id}
    Integer     response status                200
    Array       response body                  minItems=0    maxItems=0

POST /Wishlist/ToggleWishlist/{user_id}/{book_id}, 200, when toggle item (add item)
    [Tags]    wishlist
    [Documentation]    Toggle item in order to add to wishlist
    ...                In case the test passed, execute teardown: 
    ...                toggle again with same data in order to remove the item from wishlist
    Toggle item to wishlist    ${user_id}    ${book_id}
    Output
    Integer     response status                  200
    Array       response body                    minItems=1    maxItems=1
    Integer     response body 0 bookId           ${book_id}
    String      response body 0 title            ${book_title}
    String      response body 0 author           ${book_author}
    String      response body 0 category         ${book_category}
    [Teardown]    Run Keyword If Test Passed
    ...    Toggle item to wishlist    ${user_id}    ${book_id}
    
DELETE /Wishlist/{user_id}, 200, when clear wishlist for a specific user
    [Tags]    wishlist
    [Documentation]    Toggle item in order to add to wishlist
    ...                Check that item is returned from wishlist
    ...                Clear wishlist for that user
    Toggle item to wishlist    ${user_id}    ${book_id}
    Output
    Integer     response status                  200

    List wishlist for a user    ${user_id}
    Integer     response status                  200
    Array       response body                    minItems=1    maxItems=1

    Clear wishlist for a user    ${user_id}
    Integer     response status                  200
    Integer     response body                    0

GET /ShoppingCart/{user_id}, 200, when list items from shopping cart for a user
    [Tags]    shopping
    List shopping cart for a user    ${user_id}
    Integer     response status                  200
    Array       response body                    minItems=0    maxItems=0

POST /ShoppingCart/AddToCart/{user_id}/{book_id}, 200, when user adds book in shopping cart
    [Tags]    shopping
    Add book in shopping cart    ${user_id}    ${book_id}
    Integer     response status                  200
    Integer     response body                    1
    
    [Teardown]    Run Keyword If Test Passed
    ...    Remove book from shopping cart        ${user_id}    ${book_id}

Can add multiple books in shopping cart, increase quantity and clear all items from shopping cart
    [Tags]    shopping
    Add book in shopping cart    ${user_id}    ${book_id}
    Integer     response status                  200
    Integer     response body                    1

    Add book in shopping cart    ${user_id}    ${book_id_second}
    Integer     response status                  200
    Integer     response body                    2

    Add book in shopping cart    ${user_id}    ${book_id}
    Integer     response status                  200
    Integer     response body                    3

    Reduce quantity with 1 for a book    ${user_id}    ${book_id}
    Integer     response status                  200
    Integer     response body                    2

    Clear shopping cart for a user    ${user_id}
    Integer     response status                  200
    Integer     response body                    0