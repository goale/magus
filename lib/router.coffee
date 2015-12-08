Router.configure
    layoutTemplate: 'layout'
    waitOn: ->
        Meteor.subscribe 'games'

Router.route '/', ->
    @render 'lobby'

Router.route '/login', ->
    @render 'login'

Router.route '/signup', ->
    @render 'register'

Router.route '/games/:_id', ->
    if @ready()
        game = Games.findOne _id: @params._id
        @render 'gameBoard', data: game

Router.onBeforeAction ->
        if not Meteor.userId()
            @redirect '/login'
        else
            @next()
    , except: ['login', 'signup']
