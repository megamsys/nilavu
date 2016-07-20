import {
    on,
    observes
} from 'ember-addons/ember-computed-decorators';

export default Ember.Component.extend({
    tagName: 'label',
    classNameBindings: [':btn', ':btn-primary', ':btn-storage', 'isActive:active'],
    style: Ember.String.htmlSafe(''),
    attributeBindings: ['style'],

    subscriptionableName: Ember.computed.alias('name'),

    isActive: function() {
        const subscription = this.get('subscriptionable') || "";
        this.set('subscriptionOption', subscription);
        return subscription.trim().length > 0 && subscription.trim() == this.get('subscriptionableName');
    }.property("subscriptionable"),

    myStyle: Ember.computed('display', function() {
        return Ember.String.htmlSafe("display:none");
    })
});
