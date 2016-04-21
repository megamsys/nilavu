const Notification = Nilavu.Model.extend({
    dismissible: function() {
        return this.get('dismissible');
    }.property('dismissible'),

    status: function() {
        return this.get('status');
    }.property('status'),

    type: function() {
        return this.get('type');
    }.property('type'),

    message: function() {
        return this.get('message');
    }.property('messsage')
});
