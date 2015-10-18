Games = new Meteor.Collection('games');

Meteor.methods({
    'createGame': function(anotherPlayerId) {
        var game = GameFactory.createGame([Meteor.userId(), anotherPlayerId]);
        Games.insert(game);
    }
});
