class GameLogic

    makeTurn: (game, attack) ->
        userId = Meteor.userId()

        # player already made a turn
        if game.turns[userId]?
            # temporarly return all steps to always flush turns TODO: remove it
            return _.size game.turns

        game.turns[userId] = { _id: userId, turn: attack }

        Meteor.call 'updateTurns', game._id, game.turns

        return _.size game.turns

    calculateTurnsResult: (gameId) ->
        game = Games.findOne gameId
        result = ElementFactory.match game.turns, game.board

        if result.tie? and result.tie
            # TODO: add to log tie result
        else
            # update health
            game.board[result.enemy].health -= result.damage
            # set buffs
            if result.isCritical
                if result.buff is 'self'
                    game.board[result.player].buff = result.element
                else
                    game.board[result.enemy].buff = result.element
            # choose winner
            if game.board[result.enemy].health <= 0
                game.inProgress = no
                game.finished = new Date
                game.winner = result.player
            # log result

        # flush turns
        game.turns = {}

        Meteor.call 'updateGame', game

@Magus = new GameLogic
