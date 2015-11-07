GameFactory = {};

GameFactory.createGame = function(ids) {
    var players = {};

    var self = this;

    ids.forEach(function(id) {
        players[id] = self.initPlayer();
    });

    return {
        players: ids,
        info: players,
        turnCompleted: false,
        inProgress: true,
        started: new Date()
    };
};

GameFactory.initPlayer = function(id) {
    return {
        health: 100,
        defence: 0,
        attack: 0
    };
};

GameFactory.flushTurns = function(gameId, playerOne, playerTwo, fields) {
    fields.turnMade = [];

    fields["info." + playerOne + ".currentTurn"] = null;
    fields["info." + playerTwo + ".currentTurn"] = null;

    Meteor.call('updateField', gameId, fields);
};
