import { url } from 'nilavu/lib/computed';
import RestModel from 'nilavu/models/rest';
import Singleton from 'nilavu/mixins/singleton';
import { longDate } from 'nilavu/lib/formatter';
import { default as computed, observes } from 'ember-addons/ember-computed-decorators';
import Topic from 'nilavu/models/topic';

const User = RestModel.extend({

    redirected_to_top: {
        reason: null,
    },

    staff: Em.computed.or('admin', 'moderator'),

    destroySession() {
        return Nilavu.ajax(`/sessions/${this.get('email')}`, {
            type: 'DELETE'
        });
    },

    @computed("username", "name")
    displayName(username, name) {
        if (Nilavu.SiteSettings.enable_names && !Ember.isEmpty(name)) {
            return name;
        }
        return username;
    },

    @computed('profile_background')
    profileBackground(bgUrl) {
        if (Em.isEmpty(bgUrl) || !Nilavu.SiteSettings.allow_profile_backgrounds) {
            return;
        }
        return ('background-image: url(' + Nilavu.getURLWithCDN(bgUrl) + ')').htmlSafe();
    },

    @computed()
    path() {
        // no need to observe, requires a hard refresh to update
        return Nilavu.getURL(`/users/${this.get('email')}`);
    },

    adminPath: url('id', 'username_lower', "/admin/users/%@1/%@2"),

    @computed("email")
    email_lower(email) {
        return email.toLowerCase();
    },

    @computed("trust_level")
    trustLevel(trustLevel) {
        return Nilavu.Site.currentProp('trustLevels').findProperty('id', parseInt(trustLevel, 10));
    },

    isBasic: Em.computed.equal('trust_level', 0),

    isSuspended: Em.computed.equal('suspended', true),

    @computed("suspended_till")
    suspended(suspendedTill) {
        return suspendedTill && moment(suspendedTill).isAfter();
    },

    @computed("suspended_till")
    suspendedTillDate(suspendedTill) {
        return longDate(suspendedTill);
    },

    changeUsername(new_username) {
        return Nilavu.ajax(`/users/${this.get('username_lower')}/preferences/username`, {
            type: 'PUT',
            data: {
                new_username
            }
        });
    },

    changeEmail(email) {
        return Nilavu.ajax(`/users/${this.get('username_lower')}/preferences/email`, {
            type: 'PUT',
            data: {
                email
            }
        });
    },

    copy() {
        return Nilavu.User.create(this.getProperties(Ember.keys(this)));
    },

    save() {
        const data = this.getProperties(
            'bio_raw',
            'website',
            'location',
            'name',
            'locale',
            'custom_fields',
            'user_fields',
            'muted_usernames',
            'profile_background',
            'card_background'
        );

        ['email_always',
            'mailing_list_mode',
            'external_links_in_new_tab',
            'email_digests',
            'email_direct',
            'email_in_reply_to',
            'email_private_messages',
            'email_previous_replies',
            'dynamic_favicon',
            'enable_quoting',
            'disable_jump_reply',
            'automatically_unpin_topics',
            'digest_after_minutes',
            'new_topic_duration_minutes',
            'auto_track_topics_after_msecs',
            'like_notification_frequency',
            'include_tl0_in_digests'
        ].forEach(s => {
            data[s] = this.get(`user_option.${s}`);
        });

        ['muted', 'watched', 'tracked'].forEach(s => {
            let cats = this.get(s + 'Categories').map(c => c.get('id'));
            // HACK: denote lack of categories
            if (cats.length === 0) {
                cats = [-1];
            }
            data[s + '_category_ids'] = cats;
        });

        if (!Nilavu.SiteSettings.edit_history_visible_to_public) {
            data['edit_history_public'] = this.get('user_option.edit_history_public');
        }

        // TODO: We can remove this when migrated fully to rest model.
        this.set('isSaving', true);
        return Nilavu.ajax(`/users/${this.get('username_lower')}`, {
            data: data,
            type: 'PUT'
        }).then(result => {
            this.set('bio_excerpt', result.user.bio_excerpt);
            const userProps = Em.getProperties(this.get('user_option'), 'enable_quoting', 'external_links_in_new_tab', 'dynamic_favicon');
            Nilavu.User.current().setProperties(userProps);
        }).finally(() => {
            this.set('isSaving', false);
        });
    },

    changePassword() {
        return Nilavu.ajax("/session/forgot_password", {
            dataType: 'json',
            data: {
                login: this.get('username')
            },
            type: 'POST'
        });
    },


    findDetails(options) {
        return Nilavu.ajax(`/users/${this.get('email')}`, {
            data: options
        });
    },

    setDetails(details) {
        this.setProperties(details);
    },


    isAllowedToUploadAFile(type) {
        return this.get('staff') ||
            this.get('trust_level') > 0 ||
            Nilavu.SiteSettings['newuser_max_' + type + 's'] > 0;
    },

    createInvite(email, group_names) {
        return Nilavu.ajax('/invites', {
            type: 'POST',
            data: {
                email,
                group_names
            }
        });
    },

    generateInviteLink(email, group_names, topic_id) {
        return Nilavu.ajax('/invites/link', {
            type: 'POST',
            data: {
                email,
                group_names,
                topic_id
            }
        });
    },

    @computed("can_delete_account", "reply_count", "topic_count") canDeleteAccount(canDeleteAccount, replyCount, topicCount) {
        return !Nilavu.SiteSettings.enable_sso && canDeleteAccount && ((replyCount || 0) + (topicCount || 0)) <= 1;
    },

    "delete": function() {

        if (this.get('can_delete_account')) {
            return Nilavu.ajax("/users/" + this.get('username'), {
                type: 'DELETE',
                data: {
                    context: window.location.pathname
                }
            });
        } else {
            return Ember.RSVP.reject(I18n.t('user.delete_yourself_not_allowed'));
        }
    },

    dismissBanner(bannerKey) {

        this.set("dismissed_banner_key", bannerKey);
        Nilavu.ajax(`/users/${this.get('username')}`, {
            type: 'PUT',
            data: {
                dismissed_banner_key: bannerKey
            }
        });
    },

    checkEmail() {

        return Nilavu.ajax(`/users/${this.get("username_lower")}/emails.json`, {
            type: "PUT",
            data: {
                context: window.location.pathname
            }
        }).then(result => {
            if (result) {
                this.setProperties({
                    email: result.email,
                    associated_accounts: result.associated_accounts
                });
            }
        });
    }
});

User.reopenClass(Singleton, {

    // Find a `Nilavu.User` for a given username.
    findByUsername(username, options) {
        const user = User.create({
            username: username
        });
        return user.findDetails(options);
    },

    // TODO: Use app.register and junk Singleton
    createCurrent() {
        const userJson = PreloadStore.get('currentUser');

        if (userJson) {

            const store = Nilavu.__container__.lookup('store:main');
            return store.createRecord('user', userJson);
        }
        return null;
    },

    //check email exists or not
    checkUsername(username, email, for_user_id) {

        return Nilavu.ajax('/users/check_email', {
            data: {
                username,
                email,
                for_user_id
            }
        });
    },


    createAccount(attrs) {
        return Nilavu.ajax("/users", {
            data: {
                //name: attrs.accountName,
                email: attrs.accountEmail,
                password: attrs.accountPassword,
                username: attrs.accountUsername,
                password_confirmation: attrs.accountPasswordConfirm,
                challenge: attrs.accountChallenge,
                user_fields: attrs.userFields,
                firstname: attrs.firstname,
                lastname: attrs.lastname,
                phone: attrs.phonenumber
            },
            type: 'POST'
        });
    },

});

export default User;
