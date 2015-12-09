class @GameFactory

    @create: (ids) ->
        players = {}

        ids.forEach (id) =>
            players[id] = @initializePlayer(id)

        game =
            players: ids
            turns: {}
            inProgress: yes
            board: players
            started: new Date
            logs: []

    @initializePlayer: (id) ->
        player =
            _id: id
            health: 100
            buff: null
