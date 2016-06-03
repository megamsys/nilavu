import {
    on,
    observes
} from 'ember-addons/ember-computed-decorators';

export default Ember.Component.extend({
    tagName: 'div',
    classNameBindings: [':version_select', 'isActive:versionactive'],

    versionableName: Ember.computed.alias('version'),

    isActive: function() {
        const version = this.get('category.versionoption') || "";
        return version.trim().length > 0 && version.trim() == this.get('versionableName');
    }.property("category.versionoption"),

    click: function() {
        this.set('category.versionoption', this.get('versionableName'));
        this.set('category.versiondetail', this.get('versionDetail'));
    }

});
