Template.loginForm.events
    'click button': (evt, tmpl) ->
        evt.preventDefault()

        Meteor.loginWithPassword(
            tmpl.find('#login-username').value,
            tmpl.find('#login-password').value,
            (error) ->
                if error?
                    console.log error
                else
                    Router.go '/'
        )
