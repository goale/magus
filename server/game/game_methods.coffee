Meteor.methods
    attack: (game, attack) ->
        turns = Magus.makeTurn game, attack

        if turns is 2
            Meteor.setTimeout ->
                    Magus.calculateTurnsResult game
                , 3000

    update: (game) ->
        Games.update game._id, game

    updateField: (gameId, field) ->
        Games.update gameId, { $set: field }

    createGame: (opponentId) ->
        game = GameFactory.createGame [Meteor.userId(), opponentId]
        Games.insert game
