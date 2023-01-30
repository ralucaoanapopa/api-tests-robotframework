*** Settings ***
Documentation    Tests for BookCartAPI
Resource        ../variables.robot
Resource        ../book_cart_keywords.robot
Library         REST
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
