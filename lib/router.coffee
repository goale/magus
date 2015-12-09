Router.plugin 'dataNotFound', { notFoundTemplate: 'notFound' }

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
            @render 'gameBoard'
    , data: ->
        return Games.findOne _id: @params._id

Router.onBeforeAction ->
        if not Meteor.userId()
            @redirect '/login'
        else
            @next()
    , except: ['login', 'signup']
