class @BuffLogic
    # return new buff instance of corresponding element
    @new: (element) ->
        switch element
            when 'fire' then return new FireBuff
            when 'water' then return new WaterBuff
            when 'ice' then return new IceBuff
            when 'earth' then return new EarthBuff
            when 'air' then return new AirBuff
