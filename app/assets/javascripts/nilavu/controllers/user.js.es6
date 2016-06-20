import CanCheckEmails from 'nilavu/mixins/can-check-emails';
import computed from 'ember-addons/ember-computed-decorators';
import UserAction from 'nilavu/models/user-action';
import User from 'nilavu/models/user';

export default Ember.Controller.extend({
    indexStream: false,
    userActionType: null,
    needs: ['application', 'user-notifications', 'user-topics-list'],
    currentPath: Em.computed.alias('controllers.application.currentPath'),
    title: "My Profile",
    selectedTab: null,
    panels: null,
    rerenderTriggers: ['isUploading'],

    _initPanels: function() {
        this.set('panels', []);
        this.set('selectedTab', 'account');
        this.step();
    }.on('init'),

    accoutSelected: function() {
        return this.selectedTab == 'account';
    }.property('selectedTab'),

    organizationSelected: function() {
        return this.selectedTab == 'organization';
    }.property('selectedTab'),

    apikeySelected: function() {
        return this.selectedTab == 'apikey';
    }.property('selectedTab'),


    /*@computed("content.username")
    viewingSelf(username) {
        return username === User.currentProp('username');
    },

    @computed('indexStream', 'viewingSelf', 'forceExpand')
    collapsedInfo(indexStream, viewingSelf, forceExpand) {
        return (!indexStream || viewingSelf) && !forceExpand;
    },

    linkWebsite: Em.computed.not('model.isBasic'),

    @computed("model.trust_level")
    removeNoFollow(trustLevel) {
        return trustLevel > 2 && !this.siteSettings.tl3_links_no_follow;
    },

    @computed('viewingSelf', 'currentUser.admin')
    showBookmarks(viewingSelf, isAdmin) {
        return viewingSelf || isAdmin;
    },

    @computed('viewingSelf', 'currentUser.admin')
    showPrivateMessages(viewingSelf, isAdmin) {
        return this.siteSettings.enable_private_messages && (viewingSelf || isAdmin);
    },

    @computed('viewingSelf', 'currentUser.staff')
    showNotificationsTab(viewingSelf, staff) {
        return viewingSelf || staff;
    },

    @computed("content.badge_count")
    showBadges(badgeCount) {
        return Nilavu.SiteSettings.enable_badges && badgeCount > 0;
    },

    @computed("userActionType")
    privateMessageView(userActionType) {
        return (userActionType === UserAction.TYPES.messages_sent) ||
            (userActionType === UserAction.TYPES.messages_received);
    },

    @computed("indexStream", "userActionType")
    showActionTypeSummary(indexStream, userActionType, showPMs) {
        return (indexStream || userActionType) && !showPMs;
    },


    @computed()
    canInviteToForum() {
        return User.currentProp('can_invite_to_forum');
    },

    canDeleteUser: Ember.computed.and("model.can_be_deleted", "model.can_delete_all_posts"),

    @computed('model.user_fields.@each.value')
    publicUserFields() {
        const siteUserFields = this.site.get('user_fields');
        if (!Ember.isEmpty(siteUserFields)) {
            const userFields = this.get('model.user_fields');
            return siteUserFields.filterProperty('show_on_profile', true).sortBy('position').map(field => {
                field.dasherized_name = field.get('name').dasherize();
                const value = userFields ? userFields[field.get('id').toString()] : null;
                return Ember.isEmpty(value) ? null : Ember.Object.create({
                    value,
                    field
                });
            }).compact();
        }
    },*/


    actions: {
        expandProfile() {
            this.set('forceExpand', true);
        },

        adminDelete() {
            // I really want this deferred, don't want to bring in all this code till used
            const AdminUser = require('admin/models/admin-user').default;
            AdminUser.find(this.get('model.id')).then(user => user.destroy({
                deletePosts: true
            }));
        },

    }
});
