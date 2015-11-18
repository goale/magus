class @BuffFactory
    @new: (element) ->
        switch element
            when 'fire' then return new FireBuff
            #when 'water'
            #when 'ice'
            #when 'earth'
            #when 'air'

    @applyBuffs: (gameId) ->
        # TODO: get buffs and apply them
