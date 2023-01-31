*** Variables ***
# ============ Book Cart API ==============
${book_cart_base}        https://bookcart.azurewebsites.net/api
${user_name_not}         not_zzz
${user_name_new}         ralutest
${user_id}               1920
${token}                 %{BOOK_CART_TOKEN}

&{user_body}             userId=${0}
...                      firstName=${first_name_new}
...                      lastName=${last_name_new}
...                      username=${user_name_new}
...                      password=${password_new}
...                      gender=${F}
...                      userTypeId=${0}
${first_name_new}        Ralu
${last_name_new}         Test API
${password_new}          Letmetest2@23
${F}                     F

# ============ Library API ==============
${library_base}          https://postman-library-api.glitch.me
${search_q}              ?search=
${checked_out_q}         ?checkedOut=
${genre_q}               ?genre=

${borges}                borges
${author_borges}         Jorge Luis Borges
${title_borges}          Ficciones
${title_hosseini}        A Thousand Splendid Suns
${author_hosseini}       Khaled Hosseini

&{add_book_body}         title=${add_title}
...                      author=${add_author}
...                      genre=${add_genre}
...                      yearPublished=${1994}

${add_title}             The Dispossessed: An Ambiguous Utopia
${add_author}            Ursula K. Le Guin
${add_genre}             fiction
${search_added_book}     Dispossessed

&{update_book_body}      checkedOut=${True}

