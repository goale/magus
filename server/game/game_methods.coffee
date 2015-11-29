Meteor.methods
    # player turn logic
    # when both players made a turn, calculate result
    attack: (game, attack) ->
        # make an actual turn
        turns = Magus.makeTurn game, attack

        # both players made a turn, so calculate round result
        # with 2 seconds delay for interactivity
        if turns is 2

            # TODO: apply buffs
            result = Magus.applyBuffs game

            Meteor.setTimeout ->
                    Magus.calculateTurnsResult game._id, result
                , 3000

    # update player turns when player hits an attack button
    updateTurns: (gameId, turns) ->
        Games.update gameId, { $set: { turns: turns } }

    # update player stats
    updateBoard: (gameId, board) ->
        Games.update gameId, { $set: { board: board } }

    # initialize a new game
    createGame: (opponentId) ->
        game = GameFactory.create [Meteor.userId(), opponentId]
        Games.insert game

    # update game document
    updateGame: (game) ->
        Games.update game._id, game

    updateField: (gameId, field) ->
        Games.update gameId, { $set: field }
