class GameLogic
    gameId: 0

    makeTurn: (game, attack) ->
        userId = Meteor.userId()

        if not game.turnMade?
            game.turnMade = []

        if userId in game.turnMade
            turnLen = game.turnMade.length
            return

        game.info[userId].currentTurn = attack

        game.turnMade.push userId

        Meteor.call 'update', game

        turnLen = game.turnMade.length

    calculateTurnsResult: (game) ->
        @gameId = game._id
        @comparePlayers game.info

    comparePlayers: (players) ->
        playerIds = Object.keys players

        return if playerIds.length isnt 2

        playerOne = players[playerIds[0]]
        playerTwo = players[playerIds[1]]

        playerOne.id = playerIds[0]
        playerTwo.id = playerIds[1]

        @matchTurns playerOne, playerTwo

    matchTurns: (playerOne, playerTwo) ->
        field = {}

        if playerOne.currentTurn is playerTwo.currentTurn
            GameFactory.flushTurns @gameId, playerOne.id, playerTwo.id, {}
            return

        turnOne = Elements.findOne { element: playerOne.currentTurn }
        turnTwo = Elements.findOne { element: playerTwo.currentTurn }

        if turnTwo.element in turnOne.wins
            playerTwo.health -= turnOne.damage
            field["info.#{playerTwo.id}.health"] = playerTwo.health
        else
            playerOne.health -= turnTwo.damage
            field["info.#{playerOne.id}.health"] = playerOne.health

        if playerOne.health <= 0 or playerTwo.health <= 0
            field.inProgress = no
            field.finished = new Date
            field.winner = if playerOne.health <= 0 then playerTwo.id else playerOne.id

        GameFactory.flushTurns @gameId, playerOne.id, playerTwo.id, field

@Magus = new GameLogic
# GameLogic.prototype.matchTurns = function(playerOne, playerTwo) {
#     var log = {};
#
#     if (playerOne.currentTurn === playerTwo.currentTurn) {
#         log = this.log(false, playerOne.currentTurn, true);
#         GameLogs.insert(log);
#         GameFactory.flushTurns(this.gameId, playerOne.id, playerTwo.id, {});
#         return true;
#     }
#
#     var turnOne = Elements.findOne({ element: playerOne.currentTurn }),
#         turnTwo = Elements.findOne({ element: playerTwo.currentTurn }),
#         field = {};
#
#     // playerOne makes a hit
#     if (_.indexOf(turnOne.wins, turnTwo.element) !== -1) {
#         playerTwo.health -= turnOne.damage;
#         field["info." + playerTwo.id + ".health"] = playerTwo.health;
#         log = this.log(playerOne.id, turnOne);
#     } else {
#         playerOne.health -= turnTwo.damage;
#         field["info." + playerOne.id + ".health"] = playerOne.health;
#         log = this.log(playerTwo.id, turnTwo);
#     }
#
#     // If one of the players dies, complete the game and mark a winner
#     if (playerOne.health <= 0 || playerTwo.health <= 0) {
#         field.inProgress = false;
#         field.finished = new Date();
#         field.winner = playerOne.health <= 0 ? playerTwo.id : playerOne.id;
#
#         // TODO: update player winning score
#     }
#
#     GameLogs.insert(log);
#
#     GameFactory.flushTurns(this.gameId, playerOne.id, playerTwo.id, field);
# };

# GameLogic.prototype.log = function(playerId, turn, isTie = false) {
#     var log = { gameId: this.gameId, added: new Date() };
#
#     log.element = turn.element;
#
#     if (isTie) {
#         log.text = 'Ничья'
#     } else {
#         log.damage = turn.damage;
#         log.playerId = playerId;
#     }
#
#     return log;
# };

@Magus = new GameLogic