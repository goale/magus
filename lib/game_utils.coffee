class @GameUtils
    # get username by id
    @getNickname: (id) ->
        Meteor.users.findOne(id).username

    # get enemy id
    @getOpponent: (game, playerId = false) ->
        if not playerId then playerId = Meteor.userId()

        _.without(game.players, playerId).shift()

    # calculate time elapsed from game starting time
    @getElapsedTime: (gameStarted) ->
        # TODO: convert duration to proper format
        return new Date()
