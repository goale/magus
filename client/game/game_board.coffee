Template.gameBoard.helpers
    elements: ->
        Elements.find()

    player: ->
        @info[Meteor.userId()]

    playerAttacked: ->
        attacked = Meteor.userId in @turnMade

    opponent: ->
        @info[GameUtils.getOpponent(@)]

    opponentAttacked: ->
        attacked = GameUtils.getOpponent(@) in @turnMade

    turnsAreMade: ->
        @turnMade.length is 2

    gameIsCompleted: ->
        completed = not @inProgress and @winner?

    isWinner: ->
        isWinner =  @winner is Meteor.userId()

    logs: ->
        GameLogs.find { gameId: this._id }, { sort: { added: -1 } }

Template.gameBoard.events
    'click .element-btn': (evt, tmpl) ->
        if tmpl.data.inProgress
            Meteor.call 'attack', tmpl.data, @element
