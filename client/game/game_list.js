Template.gameList.helpers({
    games: function() {
        return Games.find({ inProgress: true }).map(function(game) {
            game.opponent = Meteor.users.findOne(Utils.getOpponent(game)).username;

            return game;
        });
    }
});
