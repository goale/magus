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
    if (playerOne.currentTurn === playerTwo.currentTurn) {
        console.log('it\'s a tie!');
        return true;
    }

    var turnOne = Elements.findOne({ element: playerOne.currentTurn }),
        turnTwo = Elements.findOne({ element: playerTwo.currentTurn }),
        updateField = {},
        log = { gameId: this.gameId, added: new Date() };

    // playerOne makes a hit
    if (_.indexOf(turnOne.wins, turnTwo.element) !== -1) {
        playerTwo.health -= turnOne.damage;
        updateField["info." + playerTwo.id + ".health"] = playerTwo.health;
        log.playerId = playerOne.id;
        log.element = turnOne.element;
        log.damage = turnOne.damage;
    } else {
        playerOne.health -= turnTwo.damage;
        updateField["info." + playerOne.id + ".health"] = playerOne.health;
        log.playerId = playerTwo.id;
        log.element = turnTwo.element;
        log.damage = turnTwo.damage;
    }

    GameLogs.insert(log);

    // If one of the players dies, complete the game and mark a winner
    if (playerOne.health <= 0 || playerTwo.health <= 0) {
        updateField.inProgress = false;
        updateField.finished = new Date();
        updateField.winner = playerOne.health <= 0 ? playerTwo.id : playerOne.id;

        // TODO: update player winning score
    }

    updateField.turnMade = [];

    updateField["info." + playerOne.id + ".currentTurn"] = null;
    updateField["info." + playerTwo.id + ".currentTurn"] = null;

    Meteor.call('updateField', this.gameId, updateField);
};

Magus = new GameLogic();
