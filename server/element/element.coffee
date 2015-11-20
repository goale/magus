class @Element

    setPlayer: (playerId) ->
        @player = playerId

    hit: (playerId) ->
        critical = no

        if @isCritical()
            critical = yes
            @power = parseInt(@power * 1.3)

        result =
            player: @player
            enemy: playerId
            element: @element
            damage: @power
            buff: @special.on
            isCritical: critical

        return result


    isCritical: ->
        return Math.random() < @critical
