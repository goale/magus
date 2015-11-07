Meteor.publish('games', function() {
    return Games.find({ players: this.userId });
});

Meteor.publish('users', function() {
    return Meteor.users.find();
});

Meteor.publish('elements', function() {
    return Elements.find();
});

Meteor.publish('gameLogs', function() {
    return GameLogs.find();
});
