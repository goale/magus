Template.gameBoard.helpers({
    elements: function() {
        var elements = Elements.findOne().elements,
            result = [];

        elements.map(function(el) {
            result.push({ value: el });
        });

        return result;
    },
    player: function() {
        return this.info[Meteor.userId()];
    },
    playerAttacked: function() {
        return _.indexOf(this.turnMade, Meteor.userId()) !== -1;
    },
    opponent: function() {
        return this.info[Utils.getOpposite(this)];
    },
    opponentAttacked: function() {
        return _.indexOf(this.turnMade, Utils.getOpposite(this)) !== -1;
    },
    turnsAreMade: function() {
        return this.turnMade.length === 2;
    }
});

Template.gameBoard.events({
    'click .element-btn': function(evt, tmpl) {
        Meteor.call('attack', tmpl.data, this.value);
    }
});
