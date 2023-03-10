*** Settings ***
Resource        variables.robot
Library         REST

*** Keywords ***

Set access token in Header
    [Arguments]     ${token}
    Set Headers     {"Authorization": "Bearer ${token}"}

# ============ Book ==============
Setup before running Suite
    [Documentation]    List all book then set as suite variables a set of book details
    ${resp}    GET    ${book_cart_base}/Book
    Set Suite Variable      ${book_id}     ${resp['body'][13]['bookId']}
    Set Suite Variable      ${book_title}     ${resp['body'][13]['title']}
    Set Suite Variable      ${book_author}     ${resp['body'][13]['author']}
    Set Suite Variable      ${book_category}     ${resp['body'][13]['category']}
    Set Suite Variable      ${book_id_second}     ${resp['body'][17]['bookId']}

List all books
    ${resp}    GET    ${book_cart_base}/Book

List all categories
    ${resp}    GET    ${book_cart_base}/Book/GetCategoriesList

List similar books
    [Arguments]    ${id}
    GET    ${book_cart_base}/Book/GetSimilarBooks/${id}

Read one book
    [Arguments]    ${id}
    GET    ${book_cart_base}/Book/${id}

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

# ============ User ==============
Check user availability
    [Arguments]    ${username}
    GET    ${book_cart_base}/User/validateUserName/${username}

Register new user
    POST    ${book_cart_base}/User    ${user_body}

Get number of items from shopping cart for a user
    [Arguments]    ${id}
    GET    ${book_cart_base}/User/${id}

# ============ Wishlist ==============
List wishlist for a user
    [Arguments]    ${id}
    GET    ${book_cart_base}/Wishlist/${id}

Toggle item to wishlist
    [Arguments]    ${user_id}    ${book_id}
    Set access token in Header    ${token}
    POST    ${book_cart_base}/Wishlist/ToggleWishlist/${user_id}/${book_id}

Clear wishlist for a user
    [Arguments]    ${id}
    Set access token in Header    ${token}
    DELETE    ${book_cart_base}/Wishlist/${id}

# ============ Shopping Cart ==============
List shopping cart for a user
    [Arguments]    ${id}
    GET    ${book_cart_base}/ShoppingCart/${id}

Add book in shopping cart
    [Arguments]    ${user_id}    ${book_id}
    POST    ${book_cart_base}/ShoppingCart/AddToCart/${user_id}/${book_id}

Remove book from shopping cart
    [Arguments]    ${user_id}    ${book_id}
    DELETE    ${book_cart_base}/ShoppingCart/${user_id}/${book_id}
    Integer     response status                  200

Reduce quantity with 1 for a book
    [Arguments]    ${user_id}    ${book_id}
    PUT    ${book_cart_base}/ShoppingCart/${user_id}/${book_id}

Clear shopping cart for a user
    [Arguments]    ${user_id}
    DELETE    ${book_cart_base}/ShoppingCart/${user_id}
    Integer     response status                  200