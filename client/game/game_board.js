Template.gameBoard.helpers({
    elements: function() {
        return Elements.find();
    },
    player: function() {
        return this.info[Meteor.userId()];
    },
    playerAttacked: function() {
        return _.indexOf(this.turnMade, Meteor.userId()) !== -1;
    },
    opponent: function() {
        return this.info[Utils.getOpponent(this)];
    },
    opponentAttacked: function() {
        return _.indexOf(this.turnMade, Utils.getOpponent(this)) !== -1;
    },
    turnsAreMade: function() {
        return this.turnMade.length === 2;
    },
    gameIsCompleted: function() {
        return !this.inProgress && this.winner !== null
    },
    isWinner: function() {
        return this.winner === Meteor.userId();
    },
    logs: function() {
        return GameLogs.find({ gameId: this._id }, { sort: { added: -1 } });
    }
});

Template.gameBoard.events({
    'click .element-btn': function(evt, tmpl) {
        if (tmpl.data.inProgress) {
            Meteor.call('attack', tmpl.data, this.element);
        }
    }
});
