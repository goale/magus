Games = new Meteor.Collection('games');
Elements = new Meteor.Collection('elements');
GameLogs = new Meteor.Collection('gameLogs');
if (Meteor.isServer) {
    Meteor.methods({
        initElements: function() {
            // TODO: balance elements power
            var elements = [
                { element: 'fire', damage: 10, wins: ['ice', 'earth'] },
                { element: 'earth', damage: 7, wins: ['ice', 'air'] },
                { element: 'ice', damage: 8, wins: ['water', 'air'] },
                { element: 'water', damage: 5, wins: ['fire', 'earth'] },
                { element: 'air', damage: 6, wins: ['fire', 'water'] }
            ];

            _.each(elements, function(el) {
                Elements.insert(el);
            });
        },
        createGame: function(anotherPlayerId) {
            var game = GameFactory.createGame([Meteor.userId(), anotherPlayerId]);
            Games.insert(game);
        }
    });
}
