Meteor.methods
    # player turn logic
    # when both players made a turn, calculate result
    attack: (game, attack) ->
        # make an actual turn
        turns = Magus.makeTurn game, attack

        # both players made a turn, so calculate round result
        # with 2 seconds delay for interactivity
        if turns is 2
            Meteor.setTimeout ->
                    result = Magus.applyBuffs game
                    Magus.calculateTurnsResult game._id, result
                , 1000

    # update player turns when player hits an attack button
    updateTurns: (gameId, turns) ->
        Games.update gameId, { $set: { turns: turns } }

    # initialize a new game
    createGame: (opponentId) ->
        game = GameFactory.create [Meteor.userId(), opponentId]
        Games.insert game

    # update game fields
    updateFields: (gameId, field) ->
        Games.update gameId, { $set: field }

    # prepend game events to a game log
    log: (gameId, log) ->
        game = Games.findOne gameId

        time = GameUtils.getElapsedTime game.started
        Games.update gameId, {
            $push: {
                logs: {
                    $each: [{ time: time, message: log }],
                    $position: 0
                }
            }
        }

    # update user scores
    updateScores: (winner, loser, tie = no) ->
        if tie
            winnerField = loserField =
                "profile.ties": 1

        else
            winnerField =
                "profile.wins": 1
            loserField =
                "profile.loses": 1

        Meteor.users.update(
            { _id: winner },
            { $inc: winnerField }
        )

        Meteor.users.update(
            { _id: loser },
            { $inc: loserField }
        )
