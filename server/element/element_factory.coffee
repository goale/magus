class @ElementFactory

    # Get elements for attack buttons
    @initialize: ->
        return [
            { element: 'fire', name: 'Огонь' }
            { element: 'water', name: 'Вода' }
            { element: 'ice', name: 'Лёд' }
            { element: 'earth', name: 'Земля' }
            { element: 'air', name: 'Воздух' }
        ]

    # Creates an Element object based on element type
    # and binds it to player
    @new: (element, gameId, playerId) ->
        switch element
            when 'fire' then el = new FireElement
            when 'water' then el = new WaterElement
            when 'ice' then el = new IceElement
            when 'earth' then el = new EarthElement
            when 'air' then el = new AirElement

        el.setGame gameId
        el.setPlayer playerId

        return el

    # Match players turns, calculate damage and decide who is a boss
    @match: (turns) ->
        if _.size(turns) isnt 2
            return

        turns = _.toArray turns

        [turnOne, turnTwo] = turns

        # it's a tie!
        if turnOne.element is turnTwo.element
            return tie: yes

        # player one makes a hit
        if turnTwo.element in turnOne.hits
            turnOne.hit turnTwo.player
        # player two makes a hit
        else
            turnTwo.hit turnOne.player
