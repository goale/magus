Template.gameList.helpers
    games: ->
        Games.find({ inProgress: yes }).map (game) ->
            game.opponent = Meteor.users.findOne(GameUtils.getOpponent(game)).username
            game.started = moment(game.started).fromNow()
            return game
