if (Elements.find().count() === 0) {
    Meteor.call('initElements');
}
