import {
    on,
    observes
} from 'ember-addons/ember-computed-decorators';

export default Ember.Component.extend({
    tagName: 'label',
    classNameBindings: [':btn', ':btn-primary', ':btn-storage', 'isActive:active'],
    style: Ember.String.htmlSafe(''),
    attributeBindings: ['style'],

    storageableName: Ember.computed.alias('name'),

    isActive: function() {
        const storage = this.get('storageable') || "";
        this.set('storageOption', storage);
        return storage.trim().length > 0 && storage.trim() == this.get('storageableName');
    }.property("storageable"),

    myStyle: Ember.computed('display', function() {
        return Ember.String.htmlSafe("display:none");
    })
});
