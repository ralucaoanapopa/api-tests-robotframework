*** Settings ***
Documentation    Tests for BookCartAPI
Resource        ../variables.robot
Resource        ../book_cart_keywords.robot
Library         REST
Force Tags    book-cart-api

*** Test Cases ***
GET /Book, 200, when list all books
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
    Read one book    ${book_id}
    Integer     response status                200
    Output
    Verify response book model
    Integer     response body bookId           ${book_id}

GET /Book/GetCategoriesList, 200, when list all categories
    List all categories
    Integer     response status                200
    Verify response list categories

GET /Book/GetSimilarBooks/{book_id}, 200, when list similar books
    List similar books    ${book_id}
    Integer     response status                200
    Verify response similar books
