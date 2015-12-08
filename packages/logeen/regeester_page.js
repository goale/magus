Template.regeesterPage.helpers({
    hasError: function() {
        return Logeen.hasError();
    },
    error: function() {
        return Logeen.getError();
    }
});

Template.regeesterPage.events({
    'click button': function(evt, tmpl) {
        evt.preventDefault();
        Logeen.init(tmpl).register();
    }
});
