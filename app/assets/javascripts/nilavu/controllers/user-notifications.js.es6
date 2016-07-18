export default Ember.Controller.extend({
    needs: ['application'],
    title: function() {
        return I18n.t('notifications.title');
    }.property(),

    loading: false,

    notifierEvents: function() {
         const self  = this;
         return this.get('model').map(function(evt) {
            return {
                'eventType': evt.event_type,
                'description': self._descriptionFor(evt),
                'read': self._markReadFor(evt),
                'createdAt': evt.created_at
            };
        });
    }.property('model'),

    _descriptionFor: function(n) {
        const descs = n.data.filter((f) => f.key == 'desc');
        return descs.get('firstObject').value;
    },

    _markReadFor: function(n) {
        const descs = n.data.filter((f) => f.key == 'read');
        return descs.get('firstObject').value;
    },

    _showFooter: function() {
        this.set("controllers.application.showFooter", !this.get("model.canLoadMore"));
    }.observes("model.canLoadMore"),

    showDismissButton: Ember.computed.gt('user.total_unread_notifications', 0),

    currentPath: Em.computed.alias('controllers.application.currentPath'),

    actions: {
        resetNew: function() {
            Nilavu.ajax('/notifications/mark-read', { method: 'PUT' }).then(() => {
                this.setEach('read', true);
            });
        },

        loadMore: function() {
            this.get('model').loadMore();
        }
    }
});
