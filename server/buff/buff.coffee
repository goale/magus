
class @Buff

    setGame: (gameId) ->
        @gameId = gameId

    setPlayer: (id) ->
        @player = id

    cast: ->
        console.log "applied #{@name} to #{@player}"
