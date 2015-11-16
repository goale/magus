Meteor.methods
    attack: (game, attack) ->
        if Meteor.isServer
            turns = Magus.makeTurn game, attack

            if turns is 2
                Meteor.setTimeout(() -> Magus.calculateTurnsResult game, 3000)

    update: (game) ->
        Games.update game._id, game

    updateField: (gameId, field) ->
        Games.update gameId, { $set: field }
