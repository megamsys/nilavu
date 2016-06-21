import {    on,     observes } from 'ember-addons/ember-computed-decorators';

export default Ember.Component.extend({
    tagName: 'label',
    classNameBindings: [':btn', ':btn-block', 'isActive:active'],

    chooserName: 'select',

    regionableName: Ember.computed.alias('name'),

    isActive: function() {
        const region = this.get('regionable') || "";
        this.set('regionOption', region);
        return region.trim().length > 0 && region.trim() == this.get('regionableName');
    }.property("regionable"),

    myStyle: Ember.computed('display', function() {
        return Ember.String.htmlSafe("display:none");
    })
});
