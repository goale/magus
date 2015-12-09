Template.gameBoard.helpers
    elements: ->
        Meteor.call 'getElements', (err, result) ->
            Session.set 'elements', result

        return Session.get 'elements' or ''

    player: ->
        @board[Meteor.userId()]

    opponent: ->
        @board[GameUtils.getOpponent(@)]

    playerAttacked: ->
        @turns[Meteor.userId()]

    opponentAttacked: ->
        @turns[GameUtils.getOpponent(@)]?

    gameIsCompleted: ->
        completed = not @inProgress and @winner?

    isWinner: ->
        isWinner =  @winner is Meteor.userId() if @winner?

    logs: ->
        @logs

Template.gameBoard.events
    'click .element-btn': (evt, tmpl) ->
        if tmpl.data.inProgress
            Meteor.call 'attack', tmpl.data, @element
