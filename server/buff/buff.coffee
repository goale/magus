
class @Buff

    setGameId: (id) ->
        @gameId = id

    apply: (turns, player, enemy) ->
        fields = {}

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
            when 'heal' then fields["board.#{player}.health"] = health + @power
            # additional damage to player
            when 'attack' then fields["board.#{player}.health"] = health - @power

        fields["board.#{player}.buff"] = null

        Meteor.call 'updateFields', @gameId, fields

        Meteor.call 'log', @gameId, @getLogMessage(player)

        return turns

    getLogMessage: (player) ->
        player = GameUtils.getNickname player

        if @on is 'self' then action = 'применил' else action = 'почувствовал на себе'

        return "#{player} #{action} #{@name}"
