*** Settings ***
Documentation    Tests for LibraryAPI
Resource        ../variables.robot
Resource        ../library_keywords.robot
Library         REST
Suite Setup    Setup before running Suite
Force Tags    library-api

*** Test Cases ***
GET /books, 200, when list all books
    List all books
    Integer     response status                200
    Array       response body
    String      response body 0 title          ${book_title}
    String      response body 0 author         ${book_author}
    String      response body 0 id             ${book_id}
    String      response body 0 genre          ${book_genre}
    Boolean     response body 0 checkedOut     ${book_checked_out}

GET /books, 200, when filter books with search parameter
    [Tags]    library-search
    ${resp}    Search books with query parameter    ${search_q}${borges}
    Integer     response status                200
    Array       response body                  minItems=1
    Set Suite Variable    ${book_id_borges}    ${resp['body'][0]['id']}
    String      response body 0 title          ${title_borges}
    String      response body 0 author         ${author_borges}
    String      response body 0 id             ${book_id_borges}
    String      response body 0 genre          ${book_genre}
    Boolean     response body 0 checkedOut     ${True}

GET /books, 200, when filter books with checkedOut parameter
    [Tags]    library-search
    ${resp}    Search books with query parameter    ${checked_out_q}false
    Integer     response status                200
    Array       response body                  minItems=1
    ${total_results} =    Get Length    ${resp['body']}
    Set Suite Variable    ${book_id_checked_out}    ${resp['body'][${total_results}-1]['id']}
    Boolean     response body 0 checkedOut     ${false}
    Loop over a list of items and verify property has expected value    ${resp['body']}    checkedOut    ${false}

GET /books, 200, when filter books with genre parameter
    [Tags]    library-search
    ${resp}    Search books with query parameter    ${genre_q}${book_genre}
    Integer     response status                200
    Array       response body                  minItems=1
    ${total_results} =    Get Length    ${resp['body']}
    Set Suite Variable    ${book_id_fiction}    ${resp['body'][${total_results}-1]['id']}
    Loop over a list of items and verify property has expected value    ${resp['body']}    genre    ${book_genre}