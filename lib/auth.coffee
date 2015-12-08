Logeen.configure
    loginAfterRegistration: yes
    profile:
        wins: 0
        loses: 0
        ties: 0
    onLoginSuccess: () ->
        Router.go '/'
