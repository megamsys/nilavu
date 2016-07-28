import {
    on,
    observes
} from 'ember-addons/ember-computed-decorators';

export default Ember.Component.extend({
    tagName: 'label',
    classNameBindings: [':btn', ':btn-primary', ':btnSelect', 'alignRight', 'isActive:active'],


    alignRight: function() {
        const posRight = this.get('position') || "";
        return posRight.trim();
    }.property('position'),

    launchableName: Ember.computed.alias('name'),
    showLaunchableImage: Ember.computed.alias('image'),
    titleName: Ember.computed.alias('title'),

    isActive: function() {
        const launchable = this.get('launchable') || "";
        this.set('launchOption', launchable);
        return launchable.trim().length > 0 && launchable.trim() == this.get('launchableName');
    }.property("launchable"),

    myStyle: Ember.computed('display', function() {
        return Ember.String.htmlSafe("display:none");
    })
});
