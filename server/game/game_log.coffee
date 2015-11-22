class @GameLog

    @messages: {
        fire: [
            'полыхнул ярким пламенем в лицо',
            'сжег напалмом'
        ],
        water: [
            'брызнул гидроабразивной струей',
            'засосал в водовород'
        ],
        earth: [
            'кинул булыжник в голову',
            'закопал'
        ],
        air: [
            'сдул воздушным потоком',
            'ударил с вертушки ветром'
        ],
        ice: [
            'заморозил лицо',
            'кинул снежком в голову'
        ]
    }

    @add: (game, type, result) ->
        switch type
            when 'tie' then message = 'Никто никого не ударил!'
            when 'damage' then message = @getDamageMessage result
            when 'buff' then message = @getBuffMessage result

        log =
            time: GameUtils.getElapsedTime game.started 
            message: message

        if result.player? then log.player = result.player

        return log



    # get username by user id
    @getNickname: (id) ->
        Meteor.users.findOne(id).username

    @getDamageMessage: (result) ->
        action = _.sample @messages[result.element]
        player = @getNickname result.player
        enemy = @getNickname result.enemy
        return "#{player} #{action} #{enemy} (-#{result.damage})"

    @getBuffMessage: (result) ->
        # TODO: add buff log
