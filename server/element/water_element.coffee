class @WaterElement extends Element

    messages: [
        'брызнул струей',
        'засосал в водовород'
    ]

    element: 'water'

    name: 'Вода'

    power: 6

    hits: ['fire', 'earth']

    critical: 0.3

    special: new WaterBuff
