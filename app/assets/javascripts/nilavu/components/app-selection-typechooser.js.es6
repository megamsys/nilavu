import {   on,  observes } from 'ember-addons/ember-computed-decorators';

export default Ember.Component.extend({
    tagName: 'label',
    classNameBindings: [':btn', ':btn-primary', ':btn-storage', 'isActive:active'],
    style: Ember.String.htmlSafe(''),
    attributeBindings: ['style'],

    appeltypeableName: Ember.computed.alias('name'),

    isActive: function() {
        const appeltype = this.get('appeltypeable') || "";
        this.set('appeltypeOption', appeltype);
        return appeltype.trim().length > 0 && appeltype.trim() == this.get('appeltypeableName');
    }.property("appeltypeable"),

    myStyle: Ember.computed('display', function() {
        return Ember.String.htmlSafe("display:none");
    })
});
