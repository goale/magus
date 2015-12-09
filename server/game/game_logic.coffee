class GameLogic
    ###
    # add user turn info and return number of turns
    # @param {Object} game
    # @param {string} attack element
    # @return {int} number of turns
    ###
    makeTurn: (game, attack) ->
        userId = Meteor.userId()

        # player already made a turn
        if game.turns[userId]?
            return 0

        game.turns[userId] = { _id: userId, element: attack }

        Meteor.call 'updateTurns', game._id, game.turns

        return _.size game.turns

    ###
    # apply buffs and update player stats
    # @param {Object} game
    # @param {boolean} if true then apply instant buffs
    # @return {Object} game modified with buffs logic
    ###
    applyBuffs: (game) ->
        turns = {}

        _.each game.turns, (turn, player) ->
            turns[player] = ElementFactory.new turn.element, game._id, player

        _.each game.board, (stats, player) ->
            enemy = GameUtils.getOpponent game, player
            if stats.buff?
                buff = BuffLogic.new stats.buff
                buff.setGameId game._id
                turns = buff.apply turns, player, enemy

        return turns

    ###
    # calculate rutns result and update stats
    # @param {Object} game
    ###
    calculateTurnsResult: (gameId, turns) ->
        Meteor.setTimeout =>
                ElementFactory.match turns
            , 2000

    ###
    # prepare game summary and finish game
    # @param {int} gameId
    ###
    finishGame: (gameId) ->
        game = Games.findOne gameId
        tie = yes
        fields = {}

        fields.inProgress = no
        fields.finished = new Date()

        _.each game.board, (stats, player) ->
            if stats.health > 0
                fields.winner = player
                tie = no

        loser = GameUtils.getOpponent game, fields.winner

        Meteor.call 'updateFields', gameId, fields

        if tie
            Meteor.call 'log', gameId, "Ничья! Игроки убили друг друга"
        else
            winner = GameUtils.getNickname fields.winner
            Meteor.call 'log', gameId, "#{winner} оказался сильнее и победил в жесточайшей схватке"

        # update user scores
        Meteor.call 'updateScores', fields.winner, loser, tie

@Magus = new GameLogic
