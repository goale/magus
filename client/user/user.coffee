Template.userList.helpers
    users: ->
        myId = Meteor.userId()
        cantPlayAgainst = [myId]

        Games.find({ inProgress: true })
            .forEach (game) ->
                cantPlayAgainst.push GameUtils.getOpponent(game)

        users = Meteor.users.find { _id: { $not: { $in: cantPlayAgainst } } }

Template.userItem.events
    'click button': (evt, tmpl) ->
        evt.preventDefault()
        Meteor.call 'createGame', tmpl.data._id
