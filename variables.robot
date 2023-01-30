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