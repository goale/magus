Template.userList.helpers({
    'users': function() {
        return Meteor.users.find({ _id: { $not: Meteor.userId() } });
    }
});

Template.userItem.events({
    'click button': function(evt, tmpl) {
        evt.preventDefault();
        return Meteor.call('createGame', tmpl.data._id);
    }
});
