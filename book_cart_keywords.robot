*** Settings ***
Resource        variables.robot
Library         REST

*** Keywords ***
# ============ List all Keywords ==============
List all books
    ${resp}    GET    ${book_cart_base}/Book
    Set Suite Variable      ${book_id}     ${resp['body'][13]['bookId']}

List all categories
    ${resp}    GET    ${book_cart_base}/Book/GetCategoriesList

List similar books
    [Arguments]    ${id}
    GET    ${book_cart_base}/Book/GetSimilarBooks/${id}

# ============ Read one Keywords ==============
Read one book
    [Arguments]    ${id}
    GET    ${book_cart_base}/Book/${id}

# ============ Verify responses Keywords ==========
Verify response book model
    Integer     response body bookId         
    String      response body title
    String      response body author
    String      response body category
    Number      response body price
    String      response body coverFileName

Verify response list categories
    Array        response body                         minItems=5    maxItems=5
    Integer      response body 0 categoryId            1
    String       response body 0 categoryName          Biography
    Integer      response body 1 categoryId            2
    String       response body 1 categoryName          Fiction
    Integer      response body 2 categoryId            3
    String       response body 2 categoryName          Mystery
    Integer      response body 3 categoryId            4
    String       response body 3 categoryName          Fantasy
    Integer      response body 4 categoryId            5
    String       response body 4 categoryName          Romance

Verify response similar books
    Array        response body                         minItems=5    maxItems=5
    