// server side validation
Accounts.validateNewUser(function (user) {
  if (typeof user.profile === 'undefined') {
      throw new Meteor.Error(403, "Wrong options");
  }

  if (user.profile.wins !== 0 || user.profile.loses !== 0 || user.profile.ties !== 0) {
      throw new Meteor.Error(403, "One does not simply set different scores");
  }

  return true;
});
