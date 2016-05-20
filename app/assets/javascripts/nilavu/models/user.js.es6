import { url } from 'nilavu/lib/computed';
import RestModel from 'nilavu/models/rest';
import Singleton from 'nilavu/mixins/singleton';
import { longDate } from 'nilavu/lib/formatter';
import { default as computed, observes } from 'ember-addons/ember-computed-decorators';
import Topic from 'nilavu/models/topic';

const User = RestModel.extend({

  hasPMs: Em.computed.gt("private_messages_stats.all", 0),
  hasStartedPMs: Em.computed.gt("private_messages_stats.mine", 0),
  hasUnreadPMs: Em.computed.gt("private_messages_stats.unread", 0),
  hasPosted: Em.computed.gt("post_count", 0),
  hasNotPosted: Em.computed.not("hasPosted"),
  canBeDeleted: Em.computed.and("can_be_deleted", "hasNotPosted"),

  redirected_to_top: {
    reason: null,
  },

  @computed()
  stream() {
  //  return UserStream.create({ user: this });
  return "";
  },

  @computed()
  postsStream() {
  //  return UserPostsStream.create({ user: this });
  return "";
  },

  staff: Em.computed.or('admin', 'moderator'),

  destroySession() {
    return Nilavu.ajax(`/session/${this.get('username')}`, { type: 'DELETE'});
  },

  @computed("username_lower")
  searchContext(username) {
    return {
      type: 'user',
      id: username,
      user: this
    };
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
    if (Em.isEmpty(bgUrl) || !Nilavu.SiteSettings.allow_profile_backgrounds) { return; }
    return ('background-image: url(' + Nilavu.getURLWithCDN(bgUrl) + ')').htmlSafe();
  },

  @computed()
  path() {
    // no need to observe, requires a hard refresh to update
    return Nilavu.getURL(`/users/${this.get('username_lower')}`);
  },

  pmPath(topic) {
    const userId = this.get('id');
    const username = this.get('username_lower');

    const details = topic && topic.get('details');
    const allowedUsers = details && details.get('allowed_users');
    const groups = details && details.get('allowed_groups');

    // directly targetted so go to inbox
    if (!groups || (allowedUsers && allowedUsers.findBy("id", userId))) {
      return Nilavu.getURL(`/users/${username}/messages`);
    } else {
      if (groups && groups[0])
      {
        return Nilavu.getURL(`/users/${username}/messages/group/${groups[0].name}`);
      }
    }

  },

  adminPath: url('id', 'username_lower', "/admin/users/%@1/%@2"),

  mutedTopicsPath: url('/latest?state=muted'),

  @computed("username")
  username_lower(username) {
    return "";
    //return username.toLowerCase();
  },

  @computed("trust_level")
  trustLevel(trustLevel) {
    return Nilavu.Site.currentProp('trustLevels').findProperty('id', parseInt(trustLevel, 10));
  },

  isBasic: Em.computed.equal('trust_level', 0),
  isLeader: Em.computed.equal('trust_level', 3),
  isElder: Em.computed.equal('trust_level', 4),
  canManageTopic: Em.computed.or('staff', 'isElder'),

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
      data: { new_username }
    });
  },

  changeEmail(email) {
    return Nilavu.ajax(`/users/${this.get('username_lower')}/preferences/email`, {
      type: 'PUT',
      data: { email }
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

    [       'email_always',
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

    ['muted','watched','tracked'].forEach(s => {
      let cats = this.get(s + 'Categories').map(c => c.get('id'));
      // HACK: denote lack of categories
      if (cats.length === 0) { cats = [-1]; }
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
      const userProps = Em.getProperties(this.get('user_option'),'enable_quoting', 'external_links_in_new_tab', 'dynamic_favicon');
      Nilavu.User.current().setProperties(userProps);
    }).finally(() => {
      this.set('isSaving', false);
    });
  },

  changePassword() {
    return Nilavu.ajax("/session/forgot_password", {
      dataType: 'json',
      data: { login: this.get('username') },
      type: 'POST'
    });
  },

  /*loadUserAction(id) {
    const stream = this.get('stream');
    return Nilavu.ajax(`/user_actions/${id}.json`, { cache: 'false' }).then(result => {
      if (result && result.user_action) {
        const ua = result.user_action;

        if ((this.get('stream.filter') || ua.action_type) !== ua.action_type) return;
        if (!this.get('stream.filter') && !this.inAllStream(ua)) return;

        ua.title = Nilavu.Emoji.unescape(Handlebars.Utils.escapeExpression(ua.title));
        const action = UserAction.collapseStream([UserAction.create(ua)]);
        stream.set('itemsLoaded', stream.get('itemsLoaded') + 1);
        stream.get('content').insertAt(0, action[0]);
      }
    });
  },

  inAllStream(ua) {
    return ua.action_type === UserAction.TYPES.posts ||
           ua.action_type === UserAction.TYPES.topics;
  },

  @computed("groups.@each")
  displayGroups() {
    const groups = this.get('groups');
    const filtered = groups.filter(group => {
      return !group.automatic || group.name === "moderators";
    });
    return filtered.length === 0 ? null : filtered;
  },*/

  // The user's stat count, excluding PMs.
  @computed("statsExcludingPms.@each.count")
  statsCountNonPM() {
    if (Ember.isEmpty(this.get('statsExcludingPms'))) return 0;
    let count = 0;
    _.each(this.get('statsExcludingPms'), val => {
      if (this.inAllStream(val)) {
        count += val.count;
      }
    });
    return count;
  },

  // The user's stats, excluding PMs.
  @computed("stats.@each.isPM")
  statsExcludingPms() {
    if (Ember.isEmpty(this.get('stats'))) return [];
    return this.get('stats').rejectProperty('isPM');
  },

  findDetails(options) {
    const user = this;

    return PreloadStore.getAndRemove(`user_${user.get('username')}`, () => {
      return Nilavu.ajax(`/users/${user.get('username')}.json`, { data: options });
    }).then(json => {

      /*if (!Em.isEmpty(json.user.stats)) {
        json.user.stats = Nilavu.User.groupStats(_.map(json.user.stats, s => {
          if (s.count) s.count = parseInt(s.count, 10);
          return UserActionStat.create(s);
        }));
      }

      if (!Em.isEmpty(json.user.groups)) {
        json.user.groups = json.user.groups.map(g => Group.create(g));
      }*/

      if (json.user.invited_by) {
        json.user.invited_by = Nilavu.User.create(json.user.invited_by);
      }

      /*if (!Em.isEmpty(json.user.featured_user_badge_ids)) {
        const userBadgesMap = {};
        UserBadge.createFromJson(json).forEach(userBadge => {
          userBadgesMap[ userBadge.get('id') ] = userBadge;
        });
        json.user.featured_user_badges = json.user.featured_user_badge_ids.map(id => userBadgesMap[id]);
      }

      if (json.user.card_badge) {
        json.user.card_badge = Badge.create(json.user.card_badge);
      }*/

      user.setProperties(json.user);
      return user;
    });
  },

  findStaffInfo() {
    if (!Nilavu.User.currentProp("staff")) { return Ember.RSVP.resolve(null); }
    return Nilavu.ajax(`/users/${this.get("username_lower")}/staff-info.json`).then(info => {
      this.setProperties(info);
    });
  },

  pickAvatar(upload_id, type, avatar_template) {
    return Nilavu.ajax(`/users/${this.get("username_lower")}/preferences/avatar/pick`, {
      type: 'PUT',
      data: { upload_id, type }
    }).then(() => this.setProperties({
      avatar_template,
      uploaded_avatar_id: upload_id
    }));
  },

  isAllowedToUploadAFile(type) {
    return this.get('staff') ||
           this.get('trust_level') > 0 ||
           Nilavu.SiteSettings['newuser_max_' + type + 's'] > 0;
  },

  createInvite(email, group_names) {
    return Nilavu.ajax('/invites', {
      type: 'POST',
      data: { email, group_names }
    });
  },

  generateInviteLink(email, group_names, topic_id) {
    return Nilavu.ajax('/invites/link', {
      type: 'POST',
      data: { email, group_names, topic_id }
    });
  },

  @observes("muted_category_ids")
  updateMutedCategories() {
    this.set("mutedCategories", Nilavu.Category.findByIds(this.muted_category_ids));
  },

  @observes("tracked_category_ids")
  updateTrackedCategories() {
    this.set("trackedCategories", Nilavu.Category.findByIds(this.tracked_category_ids));
  },

  @observes("watched_category_ids")
  updateWatchedCategories() {
    this.set("watchedCategories", Nilavu.Category.findByIds(this.watched_category_ids));
  },

  @computed("can_delete_account", "reply_count", "topic_count")
  canDeleteAccount(canDeleteAccount, replyCount, topicCount) {
    return !Nilavu.SiteSettings.enable_sso && canDeleteAccount && ((replyCount || 0) + (topicCount || 0)) <= 1;
  },

  "delete": function() {
    if (this.get('can_delete_account')) {
      return Nilavu.ajax("/users/" + this.get('username'), {
        type: 'DELETE',
        data: {context: window.location.pathname}
      });
    } else {
      return Ember.RSVP.reject(I18n.t('user.delete_yourself_not_allowed'));
    }
  },

  dismissBanner(bannerKey) {
    this.set("dismissed_banner_key", bannerKey);
    Nilavu.ajax(`/users/${this.get('username')}`, {
      type: 'PUT',
      data: { dismissed_banner_key: bannerKey }
    });
  },

  checkEmail() {
    return Nilavu.ajax(`/users/${this.get("username_lower")}/emails.json`, {
      type: "PUT",
      data: { context: window.location.pathname }
    }).then(result => {
      if (result) {
        this.setProperties({
          email: result.email,
          associated_accounts: result.associated_accounts
        });
      }
    });
  },

  summary() {
    return Nilavu.ajax(`/users/${this.get("username_lower")}/summary.json`)
           .then(json => {
              const topicMap = {};

              json.topics.forEach(t => {
                topicMap[t.id] = Topic.create(t);
              });

              /*const badgeMap = {};
              Badge.createFromJson(json).forEach(b => {
                badgeMap[b.id] = b;
              }); */

              const summary = json["user_summary"];

              summary.replies.forEach(r => {
                r.topic = topicMap[r.topic_id];
                r.url = r.topic.urlForPostNumber(r.post_number);
                r.createdAt = new Date(r.created_at);
              });

              summary.topics = summary.topic_ids.map(id => topicMap[id]);

              summary.badges = summary.badges.map(ub => {
                const badge = badgeMap[ub.badge_id];
                badge.count = ub.count;
                return badge;
              });
              return summary;
           });
  }

});

User.reopenClass(Singleton, {

  // Find a `Nilavu.User` for a given username.
  findByUsername(username, options) {
    const user = User.create({username: username});
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

  checkUsername(username, email, for_user_id) {
    return Nilavu.ajax('/users/check_email', {
      data: { username, email, for_user_id }
    });
  },

  groupStats(stats) {
    /*const responses = UserActionStat.create({
      count: 0,
      action_type: UserAction.TYPES.replies
    });

    stats.filterProperty('isResponse').forEach(stat => {
      responses.set('count', responses.get('count') + stat.get('count'));
    }); */

    const result = Em.A();
    result.pushObjects(stats.rejectProperty('isResponse'));

    let insertAt = 0;
    result.forEach((item, index) => {
     if (item.action_type === UserAction.TYPES.topics || item.action_type === UserAction.TYPES.posts) {
       insertAt = index + 1;
     }
    });
    if (responses.count > 0) {
      result.insertAt(insertAt, responses);
    }
    return result;
  },

  createAccount(attrs) {
    return Nilavu.ajax("/users", {
      data: {
        name: attrs.accountName,
        email: attrs.accountEmail,
        password: attrs.accountPassword,
        username: attrs.accountUsername,
        password_confirmation: attrs.accountPasswordConfirm,
        challenge: attrs.accountChallenge,
        user_fields: attrs.userFields
      },
      type: 'POST'
    });
  }
});

export default User;
