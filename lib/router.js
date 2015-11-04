// Define a layout for the application
Router.configure({
    layoutTemplate: 'layout',
    waitOn: function() {
        return Meteor.subscribe('games');
    }
});

Router.route('/', function() {
    this.render('lobby');
});

Router.route('/login', function() {
    this.render('login');
});

Router.route('/games/:_id', function() {

    if (this.ready()) {
        var game = Games.findOne({ _id: this.params._id });
        this.render('gameBoard', { data: game });
    } else {
        //TODO: loading
    }

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
