export default Ember.ArrayController.extend({
  needs: ['application'],
  title: "Notifications",

  notifications: function() {
    alert('notifications =' + JSON.stringify(this.get('model.content')));
  }.property('model.notifications'),

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
