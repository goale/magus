class GameUtils
    @getOpponent: (game) ->
        _.without game.players, Meteor.userId
            .shift()
