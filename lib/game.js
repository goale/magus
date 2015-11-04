Meteor.methods({
    attack: function(game, attack) {
        if (Meteor.isServer) {
            var turns = Magus.makeTurn(game, attack);

            if (turns === 2) {
                Meteor.setTimeout(function() {
                    Magus.calculateTurnsResult(game);
                }, 3000);
            }
        }
    },
    update: function(game) {
        Games.update(game._id, game);
    }
});
