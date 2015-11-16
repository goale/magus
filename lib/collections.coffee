@Games = new Meteor.Collection 'games'
@Elements = new Meteor.Collection 'elements'
@Buffs = new Meteor.Collection 'buffs'
@GameLogs = new Meteor.Collection 'gameLogs'

if Meteor.isServer
    Meteor.methods
        initElement: ->
            elements = [
                { element: 'fire', name: 'Огонь', damage: 10, wins: ['ice', 'earth'] },
                { element: 'earth', name: 'Земля', damage: 7, wins: ['ice', 'air'] },
                { element: 'ice', name: 'Лед', damage: 8, wins: ['water', 'air'] },
                { element: 'water', name: 'Вода', damage: 5, wins: ['fire', 'earth'] },
                { element: 'air', name: 'Воздух', damage: 6, wins: ['fire', 'water'] }
            ]

            _.each elements, (el) ->
                Elements.insert el

        initBuffs: ->
            buffs = [
                { name: 'Ожог', element: 'fire', type: 'debuff', power: 5, action: 'damage' },
                { name: 'Земляной щит', element: 'earth', type: 'buff', power: 4, action: 'defence' },
                { name: 'Целебная вода', element: 'water', type: 'buff', power: 5, action: 'heal' },
                { name: 'Ледяные осколки', element: 'ice', type: 'debuff', power: 2, action: 'attack' },
                { name: 'Воздушный удар', element: 'air', type: 'buff', power: 2, action: 'attack' }
            ]

            _.each buffs, (el) ->
                Buffs.insert el

        createGame: (opponentId) ->
            game = GameFactory.createGame [Meteor.userId, opponentId]
            Games.insert game
