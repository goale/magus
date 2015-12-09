Template.logeenPage.helpers({
    hasError: function() {
        return Logeen.hasError('Login');
    },
    error: function() {
        return Logeen.getError('Login');
    }
});

Template.logeenPage.events({
    'click button': function(evt, tmpl) {
        evt.preventDefault();
        Logeen.init(tmpl).login();
    }
});
