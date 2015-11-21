class @BuffLogic
    # return new buff instance of corresponding element
    @new: (element) ->
        switch element
            when 'fire' then return new FireBuff
            when 'water' then return new WaterBuff
            when 'ice' then return new IceBuff
            when 'earth' then return new EarthBuff
            when 'air' then return new AirBuff

    # apply buff depending on it's logic and update player stats
    @apply: (game, player) ->
        enemy = GameUtils.getOpponent game, player
        buff = @new game.board[player].buff

        switch buff.type
            # reduce enemy attack
            when 'defence' then game.turns[enemy].turn.power -= buff.power
            # increase player's critical chance
            when 'critical' then game.turns[player].turn.critical += buff.power
            # increase player attack
            when 'power' then game.turns[player].turn.power += buff.power
            # heal the player
            when 'heal' then game.board[player].health += buff.power
            # additional damage to player
            when 'attack' then game.board[player].health -= buff.power

        game.board[player].buff = null

        return game
