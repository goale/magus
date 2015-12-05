class @Element

    setPlayer: (playerId) ->
        @player = playerId

    setGame: (gameId) ->
        @gameId = gameId

    hit: (enemy) ->
        fields = {}
        finished = no
        game = Games.findOne @gameId

        if @isCritical()
            @power = parseInt(@power * 1.3)

        fields["board.#{enemy}.health"] = game.board[enemy].health - @power

        if fields["board.#{enemy}.health"] < 0
            fields["board.#{enemy}.health"] = 0
            finished = yes

        if game.board[@player].health < 0
            fields["board.#{@player}.health"] = 0
            finished = yes

        # apply buffs
        if not finished and @isCritical()
            if @buff is 'self'
                fields["board.#{@player}.buff"] = @element
            else
                fields["board.#{enemy}.buff"] = @element

        Meteor.call 'log', @gameId, @getLogMessage(@player, enemy)
        Meteor.call 'updateFields', @gameId, fields

        if finished then Magus.finishGame @gameId


    getLogMessage: (player, enemy) ->
        player = GameUtils.getNickname player
        enemy = GameUtils.getNickname enemy
        attack = _.sample @messages

        return "#{player} #{attack} #{enemy} (-#{@power} HP)"


    isCritical: ->
        return Math.random() < @critical
