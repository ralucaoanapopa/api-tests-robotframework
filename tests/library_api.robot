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

GET /books/{book_id}, 200 when read one book
    Read one book    ${book_id_fiction}
    Integer     response status              200
    String      response body title          ${title_hosseini}
    String      response body author         ${author_hosseini}
    String      response body id             ${book_id_fiction}
    String      response body genre          ${book_genre}
    Boolean     response body checkedOut     ${True}

POST /books, 201, when add one book
    [Tags]    library-own
    [Documentation]    Add one book
    ...                since the response from POST does not contain book's details
    ...                search with a word matching book's title and save book id
    Create one book    ${add_book_body}
    Integer     response status                201

    ${resp}    Search books with query parameter    ${search_q}${search_added_book}
    Output
    Integer     response status                200
    Array       response body                  minItems=1
    Set Suite Variable    ${book_id_dispossessed}    ${resp['body'][0]['id']}
    String      response body 0 title          ${add_title}
    String      response body 0 author         ${add_author}
    String      response body 0 id             ${book_id_dispossessed}
    String      response body 0 genre          ${add_genre}
    Boolean     response body 0 checkedOut     ${False}

Can read, update and remove a book added by user previously
    [Tags]    library-own
    Read one book    ${book_id_dispossessed}
    Integer     response status                  200
    String      response body title              ${add_title}
    String      response body author             ${add_author}
    String      response body id                 ${book_id_dispossessed}
    String      response body genre              ${add_genre}
    Boolean     response body checkedOut         ${False}

    Update one book    ${book_id_dispossessed}    ${update_book_body}
    Integer     response status                  200

    Read one book    ${book_id_dispossessed}
    Integer     response status                  200
    String      response body title              ${add_title}
    String      response body author             ${add_author}
    String      response body id                 ${book_id_dispossessed}
    String      response body genre              ${add_genre}
    Boolean     response body checkedOut         ${True}

    Remove one book    ${book_id_dispossessed}
    Integer     response status                  200
