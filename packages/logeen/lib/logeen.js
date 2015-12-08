/**
 * Simple authentification for meteor
 * @namespace Logeen
 * @author Alex Goncharov
 */
Logeen = {
    /**
     * @var LOGEEN_ERROR Session key for login errors
     */
    LOGEEN_ERROR: 'logeenError',

    fields: { profile: {} }
};

/**
 * Initial configuration
 * @param {Object} config
 */
Logeen.configure = function(config) {
    this.config = config || {};

    if (!_.isUndefined(this.config.profile)) {
        this.fields.profile = _.extend(this.fields.profile, this.config.profile);
    }
};

/**
 * Initialize login/register fnctionality and set a template to work with
 * @param {Blaze.TemplateInstance} template
 * @throws Error
 * @return {Logeen} this
 */
Logeen.init = function(template) {
    if (!(template instanceof Blaze.TemplateInstance)) {
        throw new Error('Logeen: you must provide a blaze template object');
    }
    this.template = template;

    return this;
};

/**
 * Login attempt with some validation
 */
Logeen.login = function() {
    if (this.validateLogin()) {
        this.loginWithCredentials(this.username, this.password);
    }
};

Logeen.loginWithCredentials = function(username, password) {
    var self = this;
    Meteor.loginWithPassword(username, password, function(err) {
        if (err) {
            self.setError('Неправильный логин/пароль');
        } else {
            if (self.config.onLoginSuccess !== null
                && self.config.onLoginSuccess instanceof Function) {
                self.config.onLoginSuccess();
            }
        }
    });
};

Logeen.register = function() {
    var self = this;
    if (this.validateRegistration()) {
        Meteor.call('registerUser', this.fields, function(err) {
            if (err) {
                self.setError('Произошла ошибка при регистрации пользователя');
            } else {
                self.loginWithCredentials(
                    self.fields.username,
                    self.fields.password
                );
            }
        });
    }
};

/**
 * Regitration fields validation (type, existence and emptiness checking)
 * @return {boolean} true if validation succeed
 */
Logeen.validateRegistration = function() {
    this.fields.username = this.template.find('input[name="username"]').value;
    this.fields.password = this.template.find('input[name="password"]').value;

    var passwordMatch = this.template.find('input[name="password-confirm"]').value,
        nickname = this.template.find('input[name="nickname"]').value;

    // check if fields are not empty
    if (this.fields.username === '' || this.fields.password === '' || passwordMatch === '') {
        this.setError('Не заполнено одно из полей');
        return false;
    }

    // password is too short
    if (this.fields.password.length < 6) {
        this.setError('Пароль слишком короткий');
        return false;
    }

    // passwords mismatch
    if (this.fields.password !== passwordMatch) {
        this.setError('Пароли не совпадают');
        return false;
    }

    // check if user exists
    if (Meteor.users.find({ username: this.fields.username }).count() > 0) {
        this.setError('Пользователь уже существует');
        return false;
    }

    this.fields.profile.nickname = nickname || this.fields.username;

    Match.test(this.fields.username, String);
    Match.test(this.fields.profile.nickname, String);
    Match.test(this.fields.password, [String, Number]);
    Match.test(passwordMatch, [String, Number]);

    return true;
};

/**
 * Simple login fields validation (type and emptiness checking)
 * @return {boolean} true if validation succeed
 */
Logeen.validateLogin = function() {
    this.username = this.template.find('input[name="username"]').value;
    this.password = this.template.find('input[name="password"]').value;

    // check if fields are not empty
    if (this.username === '' || this.password === '') {
        this.setError('Не заполнено одно из полей');
        return false;
    }

    // Sanity check for user input, throws error
    Match.test(this.username, String);
    Match.test(this.password, [String, Number]);

    return true;
};

/**
 * Store error message in meteor session with special key
 * @param {String} msg
 * @throws Error
 */
Logeen.setError = function(msg) {
    if (msg === '') {
        throw new Error('Logeen', 'Cannot set empty error message');
    }

    Session.set(this.LOGEEN_ERROR, msg);
};

/**
 * @return {boolean} true if error exists
 */
Logeen.hasError = function() {
    return typeof Session.get(this.LOGEEN_ERROR) !== 'undefined';
}

/**
 * @return {String} error
 */
Logeen.getError = function() {
    return Session.get(this.LOGEEN_ERROR);
}
