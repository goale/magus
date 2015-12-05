class @FireElement extends Element

    messages: [
        'полыхнул ярким пламенем в лицо',
        'сжег напалмом'
    ]

    element: 'fire'

    name: 'Огонь'

    power: 10

    hits: ['ice', 'earth']

    critical: 0.3

    special: new FireBuff
