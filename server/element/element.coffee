class @Element

    setPlayer: (playerId) ->
        @player = playerId

    setGame: (gameId) ->
        @gameId = gameId

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



        Meteor.call 'log', @gameId, @getLogMessage(result)

        return result

    getLogMessage: (result) ->
        player = GameUtils.getNickname result.player
        enemy = GameUtils.getNickname result.enemy
        attack = _.sample @messages

        return "#{player} #{attack} #{enemy} (-#{result.damage} HP)"


    isCritical: ->
        return Math.random() < @critical
