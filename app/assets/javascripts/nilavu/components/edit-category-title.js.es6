import {on} from 'ember-addons/ember-computed-decorators';

export default Ember.Component.extend({
    _initPanels: function() {
        this.set('launchable', 'virtualmachines');
    }.on('init')
});
