/**
 * Class containig functionality for game business logic
 *
 * @class GameLogic
 * @constructor
 */
function GameLogic() {

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
        console.log('already attacked');
        return game.turnMade.length;
    }

    console.log('You attacked with ' + attack);

    game.info[userId].currentTurn = attack;

    game.turnMade.push(userId);


    Meteor.call('update', game);
    
    return game.turnMade.length;
};

/**
 * Calculate result based on user turns and flush turn progress
 * @param {Object} game
 *
 */
GameLogic.prototype.calculateTurnsResult = function(game) {
    _.each(game.info, function(val, index, obj) {
        console.log(val);
    });

    this.flushTurnsInfo(game);
}

/**
 * Clear players turn info after round is complete
 * @param {Object} game
 */
GameLogic.prototype.flushTurnsInfo = function(game) {
    _.map(game.info, function(obj, index) {
        obj.currentTurn = null;
        return obj;
    });

    game.turnMade = [];
    Meteor.call('update', game);
}



Magus = new GameLogic();
