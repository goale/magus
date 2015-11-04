Utils = {};

Utils.getOpposite = function(game) {
    return _.without(game.players, Meteor.userId())[0];
};
