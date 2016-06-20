const Notification = Nilavu.Model.extend({
    dismissible: function() {
      alert(this.get('dismissible'));
        return this.get('dismissible');
    }.property('dismissible'),

    status: function() {
      alert(this.get('status'));

        return this.get('status');
    }.property('status'),

    type: function() {
      alert(this.get('type'));

        return this.get('type');
    }.property('type'),

    message: function() {
      alert(this.get('message'));

        return this.get('message');
    }.property('messsage')
});
