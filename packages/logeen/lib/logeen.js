/**
 * Simple authentification for meteor
 * @namespace Logeen
 * @author Alex Goncharov
 */
Logeen = {
    /**
     * @var SESSION_LOGIN_ERROR Session key for login errors
     */
    SESSION_LOGIN_ERROR: 'loginError'
};

/**
 * Initial configuration
 * @param {Object} config
 */
Logeen.configure = function(config) {
    this.config = config || {};
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
    var self = this;

    if (this.validateLogin()) {
        Meteor.loginWithPassword(
            this.username.value,
            this.password.value,
            function(err) {
                if (err) {
                    self.setLoginError('Неправильный логин/пароль');
                } else {
                    if (self.config.onLoginSuccess !== null
                        && self.config.onLoginSuccess instanceof Function) {
                        self.config.onLoginSuccess();
                    }
                }
            }
        );
    }
};

/**
 * Simple login fields validation (type and emptiness checking)
 * @return {boolean} true if validation succeed
 */
Logeen.validateLogin = function() {
    this.username = this.template.find(this.template.find('input[name="username"]'));
    this.password = this.template.find(this.template.find('input[name="password"]'));

    // check if fields are not empty
    if (this.username.value === '' || this.password.value === '') {
        this.setLoginError('Не заполнено одно из полей');
        return false;
    }

    // Sanity check for user input, throws error
    Match.test(this.username.value, String);
    Match.test(this.password.value, [String, Number]);

    return true;
};

/**
 * Store error message in meteor session with special key
 * @param {String} msg
 * @throws Error
 */
Logeen.setLoginError = function(msg) {
    if (msg === '') {
        throw new Error('Logeen', 'Cannot set empty error message');
    }

    Session.set(this.SESSION_LOGIN_ERROR, msg);
};

/**
 * @return {boolean} true if error exists
 */
Logeen.hasError = function() {
    return typeof Session.get(this.SESSION_LOGIN_ERROR) !== 'undefined';
}

/**
 * @return {String} error
 */
Logeen.getError = function() {
    return Session.get(this.SESSION_LOGIN_ERROR);
}
