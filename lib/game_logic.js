/**
 * Class containig functionality for game business logic
 *
 * @class GameLogic
 * @constructor
 */
function GameLogic() {
    this.gameId = 0;
}

/**
 * User turn
 * @param {Object} game
 * @param {string} attack
 * @return {int} turnsInGame
 */
GameLogic.prototype.makeTurn = function(game, attack) {
    var userId = Meteor.userId();

    if (typeof game.turnMade === 'undefined') {
        game.turnMade = [];
    }

    if (_.indexOf(game.turnMade, userId) !== -1) {
        return game.turnMade.length;
    }

    game.info[userId].currentTurn = attack;

    game.turnMade.push(userId);

    Meteor.call('update', game);

    return game.turnMade.length;
};

/**
 * Calculate result based on user turns and flush turn progress
 * @param {Object} game
 */
GameLogic.prototype.calculateTurnsResult = function(game) {
    this.gameId = game._id;
    this.comparePlayers(game.info);
};

GameLogic.prototype.comparePlayers = function(players) {
    var playerIds = Object.keys(players);

    if (playerIds.length !== 2) {
        return;
    }

    var playerOne = players[playerIds[0]],
        playerTwo = players[playerIds[1]];

    playerOne.id = playerIds[0];
    playerTwo.id = playerIds[1];

    // Match player turns
    this.matchTurns(playerOne, playerTwo);
};

/**
 * Match player turns, update health and clear turns info
 * @param {Object} playerOne
 * @param {Object} playerTwo
 */
GameLogic.prototype.matchTurns = function(playerOne, playerTwo) {
    var log = {};

    if (playerOne.currentTurn === playerTwo.currentTurn) {
        log = this.log(false, playerOne.currentTurn, true);
        GameLogs.insert(log);
        GameFactory.flushTurns(this.gameId, playerOne.id, playerTwo.id, {});
        return true;
    }

    var turnOne = Elements.findOne({ element: playerOne.currentTurn }),
        turnTwo = Elements.findOne({ element: playerTwo.currentTurn }),
        field = {};

    // playerOne makes a hit
    if (_.indexOf(turnOne.wins, turnTwo.element) !== -1) {
        playerTwo.health -= turnOne.damage;
        field["info." + playerTwo.id + ".health"] = playerTwo.health;
        log = this.log(playerOne.id, turnOne);
    } else {
        playerOne.health -= turnTwo.damage;
        field["info." + playerOne.id + ".health"] = playerOne.health;
        log = this.log(playerTwo.id, turnTwo);
    }

    // If one of the players dies, complete the game and mark a winner
    if (playerOne.health <= 0 || playerTwo.health <= 0) {
        field.inProgress = false;
        field.finished = new Date();
        field.winner = playerOne.health <= 0 ? playerTwo.id : playerOne.id;

        // TODO: update player winning score
    }

    GameLogs.insert(log);

    GameFactory.flushTurns(this.gameId, playerOne.id, playerTwo.id, field);
};

GameLogic.prototype.log = function(playerId, turn, isTie = false) {
    var log = { gameId: this.gameId, added: new Date() };

    log.element = turn.element;

    if (isTie) {
        log.text = 'Ничья'
    } else {
        log.damage = turn.damage;
        log.playerId = playerId;
    }

    return log;
};

Magus = new GameLogic();
