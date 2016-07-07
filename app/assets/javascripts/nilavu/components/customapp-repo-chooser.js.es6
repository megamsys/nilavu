import {   on,  observes } from 'ember-addons/ember-computed-decorators';

export default Ember.Component.extend({
    tagName: 'label',
    classNameBindings: [':btn', ':btn-primary', ':btn-storage', 'isActive:active'],
    style: Ember.String.htmlSafe(''),
    attributeBindings: ['style'],

    repoableName: Ember.computed.alias('name'),

    isActive: function() {
        const repotype = this.get('repoable') || "";
        return repotype.trim().length > 0 && repotype.trim() == this.get('repoableName');
    }.property("repoable"),

    myStyle: Ember.computed('display', function() {
        return Ember.String.htmlSafe("display:none");
    })
});
