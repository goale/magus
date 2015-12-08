var KEY_PREFIX = 'Logeen.';

var ERROR = 'Error.';

var FIELDS = 'Fields.'

/**
 * Simple authentification for meteor
 * @namespace Logeen
 * @author Alex Goncharov
 */
Logeen = {
    fields: { profile: {} }
};

/**
 * Initial configuration
 * @param {Object} config
 */
Logeen.configure = function(config) {
    this.config = config || {};

    if (!_.isUndefined(this.config.customUserFields)) {
        this.fields.profile = _.extend(this.fields.profile, this.config.customUserFields);
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

/**
 * Meteor login wrapper with custom logic
 * @param {String} username
 * @param {String} password
 */
Logeen.loginWithCredentials = function(username, password) {
    var self = this;
    Meteor.loginWithPassword(username, password, function(err) {
        if (err) {
            self.setError('Login', 'Неправильный логин/пароль');
        } else {
            if (self.config.onLoginSuccess !== null
                && self.config.onLoginSuccess instanceof Function) {
                self.config.onLoginSuccess();
            }
        }
    });
};

/**
 * Create new user and login into a game
 */
Logeen.register = function() {
    var self = this;
    if (this.validateRegistration()) {
        Meteor.call('registerUser', this.fields, function(err) {
            if (err) {
                self.setError('Signup', 'Произошла ошибка при регистрации пользователя');
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

    // save fields
    this.saveFields({
        username: this.fields.username,
        nickname: nickname
    });

    // check if fields are not empty
    if (this.fields.username === '' || this.fields.password === '' || passwordMatch === '') {
        this.setError('Signup', 'Не заполнено одно из полей');
        return false;
    }

    // password is too short
    if (this.fields.password.length < 6) {
        this.setError('Signup', 'Пароль слишком короткий');
        return false;
    }

    // passwords mismatch
    if (this.fields.password !== passwordMatch) {
        this.setError('Signup', 'Пароли не совпадают');
        return false;
    }

    // check if user exists
    if (Meteor.users.find({ username: this.fields.username }).count() > 0) {
        this.setError('Signup', 'Пользователь уже существует');
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
 * Save non-private fields like login or nickname to show after failed registration
 * @param {Object} fields
 */
Logeen.saveFields = function(fields) {
    Session.set(KEY_PREFIX + FIELDS, fields);
};

/**
 * Get saved fields
 */
Logeen.getFields = function() {
    return Session.get(KEY_PREFIX + FIELDS);
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
        this.setError('Login', 'Не заполнено одно из полей');
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
Logeen.setError = function(type, msg) {
    if (msg === '') {
        throw new Error('Logeen', 'Cannot set empty error message');
    }

    Session.set(KEY_PREFIX + ERROR + type, msg);
};

/**
 * @return {boolean} true if error exists
 */
Logeen.hasError = function(type) {
    return typeof Session.get(KEY_PREFIX + ERROR + type) !== 'undefined';
}

/**
 * @return {String} error
 */
Logeen.getError = function(type) {
    return Session.get(KEY_PREFIX + ERROR + type);
}
