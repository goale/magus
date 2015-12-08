Meteor.methods({
    registerUser: function(fields, callback) {
        Accounts.createUser(fields, callback);
    }
});
