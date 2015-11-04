Games = new Meteor.Collection('games');
Elements = new Meteor.Collection('elements');

Meteor.methods({
    initElements: function() {
        Elements.insert({ elements: ['fire','water' ,'ice', 'earth', 'air'] });
    },
    createGame: function(anotherPlayerId) {
        var game = GameFactory.createGame([Meteor.userId(), anotherPlayerId]);
        Games.insert(game);
    }
});
