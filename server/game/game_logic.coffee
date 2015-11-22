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
    applyBuffs: (game, applyInstant = no) ->
        _.each game.board, (stats, player) ->
            if stats.buff?
                buff = BuffLogic.new stats.buff

                if (applyInstant and buff.instant) or (not applyInstant and not buff.instant)
                    game = BuffLogic.apply game, player
                    Meteor.call 'updateBoard', game._id, game.board

        return game

    ###
    # calculate round result, apply buffs, and choose a winner
    # @param {Object} game
    ###
    calculateTurnsResult: (game) ->
        logs = []
        # get element stats for turns
        _.each game.turns, (turn, player) ->
            game.turns[player].turn = ElementFactory.new turn.element, player
        # apply non-instant buffs
        game = @applyBuffs game
        result = ElementFactory.match game

        if result.tie? and result.tie
            logs.push(GameLog.add game, 'tie', result)
        else
            # update health
            game.board[result.enemy].health -= result.damage
            # set buffs
            if result.isCritical
                if result.buff is 'self'
                    game.board[result.player].buff = result.element
                else
                    game.board[result.enemy].buff = result.element

            # log damage
            logs.push(GameLog.add game, 'damage', result)

            # choose a winner
            if game.board[result.enemy].health <= 0
                game.inProgress = no
                game.finished = new Date
                game.winner = result.player

                logs.push(GameLog.add game, 'winner', result)

        # flush turns
        game.turns = {}

        game.logs = _.union game.logs, logs

        Meteor.setTimeout ->
                Meteor.call 'updateGame', game
            , 1000

        # apply instant buffs with 2 seconds delay
        Meteor.setTimeout =>
                @applyBuffs game, yes
            , 3000

@Magus = new GameLogic
