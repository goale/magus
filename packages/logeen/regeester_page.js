Template.regeesterPage.helpers({
    hasError: function() {
        return Logeen.hasError('Signup');
    },
    error: function() {
        return Logeen.getError('Signup');
    },
    fields: function() {
        return Logeen.getFields();
    }
});

Template.regeesterPage.events({
    'click button': function(evt, tmpl) {
        evt.preventDefault();
        Logeen.init(tmpl).register();
    }
});
