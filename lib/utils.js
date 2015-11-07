Utils = {};

Utils.getOpponent = function(game) {
    return _.without(game.players, Meteor.userId())[0];
};
