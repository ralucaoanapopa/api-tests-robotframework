*** Settings ***
Resource        variables.robot
Library         REST

*** Keywords ***
List all books
    ${resp}    GET    ${library_base}/books
    [Return]    ${resp}

Setup before running Suite
    [Documentation]    List all book then set as suite variables a set of book details
    ${resp}    List all books
    Set Suite Variable      ${book_id}     ${resp['body'][0]['id']}
    Set Suite Variable      ${book_title}     ${resp['body'][0]['title']}
    Set Suite Variable      ${book_author}     ${resp['body'][0]['author']}
    Set Suite Variable      ${book_genre}     ${resp['body'][0]['genre']}
    Set Suite Variable      ${book_checked_out}     ${resp['body'][0]['checkedOut']}
    Set Suite Variable      ${book_id_second}     ${resp['body'][13]['id']}

Search books with query parameter
    [Arguments]    ${query}
    ${resp}    GET    ${library_base}/books${query}
    [Return]    ${resp}

Loop over a list of items and verify property has expected value
    [Arguments]    ${list}    ${property_to_check}    ${value_to_check}
    FOR    ${element}    IN    @{list}
        Should Be Equal    ${element['${property_to_check}']}     ${value_to_check}
    END

Read one book
    [Arguments]    ${id}
    GET    ${library_base}/books/${id}

Create one book
    [Arguments]    ${body}
    POST    ${library_base}/books    ${body}

Update one book
    [Arguments]    ${id}    ${body}
    PATCH    ${library_base}/books/${id}    ${body}

Remove one book
    [Arguments]    ${id}
    DELETE    ${library_base}/books/${id}