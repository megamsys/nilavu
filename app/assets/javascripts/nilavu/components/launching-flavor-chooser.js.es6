import {  on,  observes } from 'ember-addons/ember-computed-decorators';

export default Ember.Component.extend({
    tagName: 'label',
    classNameBindings: [':btn', ':btn-block', 'isActive:active'],

    chooserName: 'select',

    flavorName: Ember.computed.alias('name'),

    isActive: function() {
        const flavor = this.get('flavourable') || "";
        return flavor.trim().length > 0 && flavor.trim() == this.get('flavorName');
    }.property('flavourable'),

    myStyle: Ember.computed('display', function() {
        return Ember.String.htmlSafe("display:none");
    })
});
