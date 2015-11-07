if (Meteor.isServer && Elements.find().count() === 0) {
    Meteor.call('initElements');
}
