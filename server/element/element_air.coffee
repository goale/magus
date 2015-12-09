class @AirElement extends Element

    messages: [
        'сдул воздушным потоком',
        'ударил с вертушки ветром'
    ]

    element: 'air'

    name: 'Воздух'

    power: 7

    hits: ['fire', 'water']

    critical: 0.35

    special: new AirBuff
