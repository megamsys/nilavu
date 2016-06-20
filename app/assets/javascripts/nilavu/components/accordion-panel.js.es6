import Ember from 'ember';
export default Ember.Component.extend({

    didInsertElement: function() {
        Ember.$(this.get('data-parent')).find(this.get('data-href')).slideToggle();
        this.toggleProperty('data-aria-expanded');
    },

    actions: {
        toggleCollapse: function() {
            Ember.$(this.get('data-parent')).find(this.get('data-href')).slideToggle();
            this.toggleProperty('data-aria-expanded');
        }
    }
});
