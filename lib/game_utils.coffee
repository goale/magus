class @GameUtils
    # get enemy id
    @getOpponent: (game, playerId = false) ->
        if not playerId then playerId = Meteor.userId()

        _.without(game.players, playerId).shift()
