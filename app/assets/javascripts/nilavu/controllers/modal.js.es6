export default Ember.Controller.extend({

    headCentered: function() {
        if (this.get('titleCentered')) {
            return 'text-center';
        }
    }.property('titleCentered')

});
