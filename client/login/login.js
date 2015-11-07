Template.loginForm.events({
    'click button': function(evt, tmpl) {
        evt.preventDefault();
        Meteor.loginWithPassword(
            tmpl.find('#login-username').value,
            tmpl.find('#login-password').value,
            function(error) {
                if (typeof error !== 'undefined') {
                    console.log(error);
                } else {
                    Router.go('/');
                }
            }
        );
    }
});
