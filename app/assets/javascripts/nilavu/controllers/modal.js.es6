export default Ember.Controller.extend({
    // close: false,
    headCentered: function() {
        if (this.get('titleCentered')) {
            return 'text-center';
        }
    }.property('titleCentered'),

    actions: {
        cancelModal() {
            if(this.get('close') == true)
            {
              window.location.reload();
            }
            else {
              this.send('closeModal')
            }

        }
    }
});
