
class @Buff

    setGameId: (id) ->
        @gameId = id

    apply: (turns, player, enemy) ->
        field = {}

        game = Games.findOne @gameId
        health = game.board[player].health

        switch @type
            # reduce enemy attack
            when 'defence' then turns[enemy].power -= @power
            # increase player's critical chance
            when 'critical' then turns[player].critical += @power
            # increase player attack
            when 'power' then turns[player].power += @power
            # heal the player
            when 'heal' then field["board.#{player}.health"] = health + @power
            # additional damage to player
            when 'attack' then field["board.#{player}.health"] = health - @power

        field["board.#{player}.buff"] = null

        Meteor.call 'updateField', @gameId, field

        # TODO: add buff info to log

        return turns
