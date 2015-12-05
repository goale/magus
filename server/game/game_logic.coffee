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

        # TODO: add to log

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
                result = ElementFactory.match turns
                @updateStats gameId, result
            , 2000


    ###
    # update turns/game results
    # @param {int} gameId
    # @param {Object} round result
    ###
    updateStats: (gameId, result) ->
        game = Games.findOne gameId
        fields = {}

        if result.tie? and result.tie
            Meteor.call 'log', gameId, "Никто никого не ударил"
        else
            # reduce enemy's health
            fields["board.#{result.enemy}.health"] = game.board[result.enemy].health - result.damage

            # set buffs
            if result.isCritical
                if result.buff is 'self'
                    fields["board.#{result.player}.buff"] = result.element
                else
                    fields["board.#{result.enemy}.buff"] = result.element

            if fields["board.#{result.enemy}.health"] <= 0
                fields.inProgress = no
                fields.finished = new Date
                fields.winner = result.player

                winner = GameUtils.getNickname result.player
                Meteor.call 'log', gameId, "#{winner} оказался сильнее и победил"

        # flush turns
        fields["turns"] = {}

        Meteor.call 'updateFields', gameId, fields

@Magus = new GameLogic
