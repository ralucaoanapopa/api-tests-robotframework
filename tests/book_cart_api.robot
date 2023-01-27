*** Settings ***
Documentation    Tests for BookCartAPI
Resource        ../variables.robot
Library         REST
Force Tags    book-cart-api

*** Test Cases ***
GET /Book, 200, when list all books
    GET    ${book_cart_base}/Book
    Integer     response status                200
    Output
    Array       response body
    Integer     response body 0 bookId         2
    String      response body 0 title          HP2
    String      response body 0 author         JKR
    Number      response body 0 price          235.0
    String      response body 0 coverFileName