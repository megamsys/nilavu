import debounce from 'nilavu/lib/debounce';
import {setting} from 'nilavu/lib/computed';
import {on} from 'ember-addons/ember-computed-decorators';

export default Ember.Controller.extend({
    needs: ['login'],

    complete: false,
    accountPasswordConfirm: 0,
    accountChallenge: 0,
    uniqueEmailValidation: null,
    formSubmitted: false,
    rejectedEmails: Em.A([]),
    rejectedPasswords: Em.A([]),
    isDeveloper: false,

    hasAuthOptions: Em.computed.notEmpty('authOptions'),
    canCreateLocal: setting('enable_local_logins'),
    showCreateForm: Em.computed.or('hasAuthOptions', 'canCreateLocal'),
    maxUsernameLength: setting('max_username_length'),
    minUsernameLength: setting('min_username_length'),
    ctaEye: Nilavu.SiteSettings.logo_signup_cta,
    ctaEyeTitle: Ember.String.htmlSafe(Nilavu.SiteSettings.signup_cta),

    resetForm() {
        // We wrap the fields in a structure so we can assign a value
        this.setProperties({
            accountName: '',
            accountEmail: '',
            accountPassword: '',
            authOptions: null,
            complete: false,
            formSubmitted: false,
            rejectedEmails: [],
            rejectedPasswords: [],
            isDeveloper: false,
            firstname: '',
            lastname: '',
            accountPasswordConfirm: '',
            phonenumber: ''
        });
    },

    submitDisabled: function() {
        if (this.get('formSubmitted'))
            return true;
        if (this.get('nameValidation.failed'))
            return true;
        if (this.get('emailValidation.failed'))
            return true;
        if (this.get('passwordValidation.failed'))
            return true;
        if (this.get('passwordConfirmValidation.failed'))
            return true;

        return false;
    }.property('passwordRequired', 'nameValidation.failed', 'emailValidation.failed', 'passwordValidation.failed', 'passwordConfirmValidation.failed', 'formSubmitted'),

    usernameRequired: Ember.computed.not('authOptions.omit_username'),

    passwordRequired: function() {
        return Ember.isEmpty(this.get('authOptions.auth_provider'));
    }.property('authOptions.auth_provider'),

    passwordInstructions: function() {
        return this.get('isDeveloper')
            ? I18n.t('user.password.instructions', {count: Nilavu.SiteSettings.min_admin_password_length})
            : I18n.t('user.password.instructions', {count: Nilavu.SiteSettings.min_password_length});
    }.property('isDeveloper'),

    nameInstructions: function() {
        return I18n.t(Nilavu.SiteSettings.full_name_required
            ? 'user.name.instructions_required'
            : 'user.name.instructions');
    }.property(),

    // Validate the name.
    nameValidation: function() {
        if (Nilavu.SiteSettings.full_name_required && Ember.isEmpty(this.get('accountName'))) {
            return Nilavu.InputValidation.create({failed: true});
        }

        return Nilavu.InputValidation.create({ok: true});
    }.property('accountName'),

    // Actually wait for the async name check before we're 100% sure we're good to go
    emailValidation: function() {
        const basicValidation = this.get('basicEmailValidation');
        const uniqueEmail = this.get('uniqueEmailValidation');
        return uniqueEmail
            ? uniqueEmail
            : basicValidation;
    }.property('uniqueEmailValidation', 'basicEmailValidation'),

    // Validate the password
    passwordValidation: function() {
        if (!this.get('passwordRequired')) {
            return Nilavu.InputValidation.create({ok: true});
        }

        // If blank, fail without a reason
        const password = this.get("accountPassword");
        if (Ember.isEmpty(this.get('accountPassword'))) {
            return Nilavu.InputValidation.create({failed: true});
        }

        // If too short
        const passwordLength = this.get('isDeveloper')
            ? Nilavu.SiteSettings.min_admin_password_length
            : Nilavu.SiteSettings.min_password_length;
        if (password.length < passwordLength) {
            return Nilavu.InputValidation.create({failed: true, reason: I18n.t('user.password.too_short')});
        }

        if (this.get('rejectedPasswords').contains(password)) {
            return Nilavu.InputValidation.create({failed: true, reason: I18n.t('user.password.common')});
        }

        if (!Ember.isEmpty(this.get('accountEmail')) && this.get('accountPassword') === this.get('accountEmail')) {
            return Nilavu.InputValidation.create({failed: true, reason: I18n.t('user.password.same_as_email')});
        }

        // Looks good!
        return Nilavu.InputValidation.create({ok: true, reason: I18n.t('user.password.ok')});
    }.property('accountPassword', 'rejectedPasswords.@each', 'accountEmail', 'isDeveloper'),

    passwordConfirmValidation: function() {
        const password = this.get("accountPassword");
        // If blank, fail without a reason
        if (Ember.isEmpty(this.get('accountPasswordConfirm'))) {
            return Nilavu.InputValidation.create({failed: true});
        }

        if (!Ember.isEmpty(this.get('accountPasswordConfirm')) && this.get('accountPassword') === this.get('accountPasswordConfirm')) {
            return Nilavu.InputValidation.create({ok: true, reason: I18n.t('user.password.ok_confirm')});
        }

        if (!Ember.isEmpty(this.get('accountPasswordConfirm')) && this.get('accountPassword') != this.get('accountPasswordConfirm')) {
            return Nilavu.InputValidation.create({failed: true, reason: I18n.t('user.password.enter')});
        }

    }.property('accountPasswordConfirm', 'accountPassword'),

    // Check the email address
    basicEmailValidation: function() {
        this.set('uniqueEmailValidation', null);

        // If blank, fail without a reason
        let email;
        if (Ember.isEmpty(this.get('accountEmail'))) {
            return Nilavu.InputValidation.create({failed: true});
        }

        email = this.get("accountEmail");

        if (this.get('rejectedEmails').contains(email)) {
            return Nilavu.InputValidation.create({failed: true, reason: I18n.t('user.email.invalid')});
        }

        if (!Nilavu.Utilities.emailValid(email)) {
            return Nilavu.InputValidation.create({failed: true, reason: I18n.t('user.email.invalid')});
        }

        this.checkEmailAvailability();
        // Let's check it out asynchronously
        return Nilavu.InputValidation.create({failed: false, reason: I18n.t('user.email.checking')});

    }.property('accountEmail', 'rejectedEmails.@each'),

    shouldCheckEmailAvailability: function() {
        return !Ember.isEmpty(this.get('accountEmail'));
    },

    checkEmailAvailability: debounce(function() {
        const _this = this;

        if (this.shouldCheckEmailAvailability) {
            Nilavu.User.checkUsername(null, this.get('accountEmail')).then(function(result) {
                _this.set('isDeveloper', false);
                if (result.errors) {
                    self.set('errorMessage', result.errors.join(' '));
                } else if (result.available) {
                    return _this.set('uniqueEmailValidation', Nilavu.InputValidation.create({ok: true, reason: I18n.t('user.email.ok')}));
                } else {
                    return _this.set('uniqueEmailValidation', Nilavu.InputValidation.create({failed: true, reason: I18n.t('user.change_email.taken')}));
                }
            });
        }
    }, 500),

    actions: {
        externalLogin(provider) {
            this.get('controllers.login').send('externalLogin', provider);
        },

        createAccount() {
            const self = this,
                attrs = this.getProperties('accountName', 'accountEmail', 'accountPassword', 'accountPasswordConfirm', 'firstname', 'lastname', 'phonenumber');

            this.set('formSubmitted', true);

            return Nilavu.User.createAccount(attrs).then(function(result) {
                self.set('isDeveloper', false);
                if (result.success) {
                    // Trigger the browser's password manager using the hidden static login form:
                    const $hidden_login_form = $('#hidden-login-form');
                    $hidden_login_form.find('input[name=username]').val(attrs.accountUsername);
                    $hidden_login_form.find('input[name=password]').val(attrs.accountPassword);

                    $hidden_login_form.find('input[name=redirect]').val(Nilavu.getURL('/users/account-created'));
                    $hidden_login_form.submit();
                } else {
                    self.flash(result.message || I18n.t('create_account.failed'), 'error');
                    if (result.is_developer) {
                        self.set('isDeveloper', true);
                    }
                    if (result.errors && result.errors.email && result.errors.email.length > 0 && result.values) {
                        self.get('rejectedEmails').pushObject(result.values.email);
                    }
                    if (result.errors && result.errors.password && result.errors.password.length > 0) {
                        self.get('rejectedPasswords').pushObject(attrs.accountPassword);
                    }
                    self.set('formSubmitted', false);
                }
                if (result.active) {
                    return window.location.reload();
                }
            }, function() {
                self.set('formSubmitted', false);
                return self.flash(I18n.t('create_account.failed'), 'error');
            });
        }
    }
});
