Template.gameList.helpers
    games: ->
        Games.find { inProgress: yes }
            .map (game) ->
                game.opponent = Meteor.users.findOne(GameUtils.getOpponent(game)).username
