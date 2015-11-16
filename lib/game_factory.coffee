class GameFactory

    @createGame: (ids) ->
        players = new Object

        ids.forEach (id) =>
            players[id] = @initPlayer()

        game =
            players: ids
            info: players
            turnCompleted: no
            inProgress: yes
            started: new Date

    @initPlayer: (id) ->
        player =
            health: 100

    @flushTurns: (gameId, playerOne, playerTwo, fields) ->
        fields.turnMade = []
        fields["info.#{playerOne}.currentTurn"] = null
        fields["info.#{playerTwo}.currentTurn"] = null

        Meteor.call 'updateField', gameId, fields
