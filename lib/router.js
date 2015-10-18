// Define a layout for the application
Router.configure({
    layoutTemplate: 'layout'
});

Router.route('/', function() {
    this.render('lobby');
});

Router.route('/login', function() {
    this.render('login');
});

Router.route('/games/:_id', function() {
    var game = Games.findOne({ _id: this.params._id });
    game.you = game.info[Meteor.userId()];
    var opponentId = _.without(game.players, Meteor.userId()).shift();
    game.opponent = game.info[opponentId];
    this.render('game', { data: game });
});

// Router hooks
Router.onBeforeAction(function() {
    if (!Meteor.userId()) {
        this.redirect('/login');
    // TODO: add character init page on first login
    } else {
        this.next();
    }
}, { except: 'login' });
