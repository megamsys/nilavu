import {
    on,
    observes
} from 'ember-addons/ember-computed-decorators';

export default Ember.Component.extend({
    tagName: 'label',
    classNameBindings: [':btn', ':btn-block', 'isActive:active'],

    regionableName: Ember.computed.alias('name'),

    isActive: function() {
        const resource = this.get('resourceable') || "";
        this.set('resourceOption', region);
        return resource.trim().length > 0 && resource.trim() == this.get('resourceableName');
    }.property("resourceable"),

    myStyle: Ember.computed('display', function() {
        return Ember.String.htmlSafe("display:none");
    })
});
