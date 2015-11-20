class @ElementFactory

    # Get elements for attack buttons
    @initialize: ->
        return [
            { element: 'fire', name: 'Огонь' }
            { element: 'ice', name: 'Лёд' }
        ]

    # Creates an Element object based on element type
    # and binds it to player
    @new: (element, playerId) ->
        switch element
            when 'fire' then el = new FireElement
            when 'ice' then el = new IceElement

        el.setPlayer playerId

        return el

    # Match players turns, calculate damage and decide who is a boss
    @match: (turns, board) ->
        if _.size(turns) isnt 2
            return

        turns = _.toArray turns

        [turnOne, turnTwo] = turns

        # it's a tie!
        if turnOne.turn is turnTwo.turn
            return tie: yes

        elementOne = @new turnOne.turn, turnOne._id
        elementTwo = @new turnTwo.turn, turnTwo._id

        # player one makes a hit
        if elementTwo.element in elementOne.hits
            elementOne.hit elementTwo.player
        # player two makes a hit
        else
            elementTwo.hit elementOne.player
