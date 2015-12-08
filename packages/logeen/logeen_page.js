Template.logeenPage.helpers({
    hasError: function() {
        return Logeen.hasError();
    },
    error: function() {
        return Logeen.getError();
    }
});

Template.logeenPage.events({
    'click button': function(evt, tmpl) {
        evt.preventDefault();
        Logeen.init(tmpl).login();
    }
});
