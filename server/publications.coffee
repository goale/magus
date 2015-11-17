# TODO: publish only needed for client fields
# TODO: hide opponent turns
Meteor.publish 'games', ->
    Games.find { players: @userId }

Meteor.publish 'users', ->
    Meteor.users.find()

Meteor.publish 'elements', ->
    Elements.find()

Meteor.publish 'gameLogs', ->
    GameLogs.find()

Meteor.publish 'buffs', ->
    Buffs.find()
