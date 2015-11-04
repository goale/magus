Template.userList.helpers({
    'users': function() {
        var myId = Meteor.userId(),
            cantPlayAgainst = [myId];

        Games.find({ inProgress: true }).forEach(function(game) {
            cantPlayAgainst.push(Utils.getOpposite(game));
        });

        return Meteor.users.find({ _id: { $not: { $in: cantPlayAgainst } } });
    }
});

Template.userItem.events({
    'click button': function(evt, tmpl) {
        evt.preventDefault();
        return Meteor.call('createGame', tmpl.data._id);
    }
});
