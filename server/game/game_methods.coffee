Meteor.methods
    attack: (game, attack) ->
        turns = Magus.makeTurn game, attack

        if turns is 2
            Meteor.setTimeout ->
                    Magus.calculateTurnsResult game._id
                , 3000

    updateTurns: (gameId, turns) ->
        Games.update gameId, { $set: { turns: turns } }

    createGame: (opponentId) ->
        game = GameFactory.create [Meteor.userId(), opponentId]
        Games.insert game

    updateGame: (game) ->
        Games.update game._id, game
