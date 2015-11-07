Template.profileBadge.events({
    'click button': function(evt, tmpl) {
        Meteor.logout();
    }
})
