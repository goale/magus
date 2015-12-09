Logeen.configure
    loginAfterRegistration: yes
    customUserFields:
        wins: 0
        loses: 0
        ties: 0
    onLoginSuccess: () ->
        Router.go '/'
