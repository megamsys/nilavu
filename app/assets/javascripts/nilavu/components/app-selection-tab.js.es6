import { propertyEqual, propertyNotEqual } from 'nilavu/lib/computed';

export default Em.Component.extend({
    tagName: 'li',
    classNameBindings: [':text-center', 'isActive:active', 'tabClassName', 'disabled:tabDisabled'],

    tabClassName: function() {
        return 'app-selection-' + this.get('tab');
    }.property('tab'),

    disabled: function() {
        const sel = this.get('selectedTab') || "";
        return sel.trim().length > 0 && sel.trim() != this.get('tab');
    }.property('selectedTab', 'tab'),

    active: propertyEqual('selectedTab', 'tab'),

    isActive: function() {
        const sel = this.get('selectedTab') || "";
        return sel.trim().length > 0 && sel.trim() == this.get('tab');
    }.property('selectedTab', 'tab'),

    title: function() {
        return I18n.t('launcher.' + this.get('tab').replace('-', '_'));
    }.property('tab'),

    lowerTitle: function() {
        return this.get('title').toLowerCase();
    }.property('title'),

    _addToCollection: function() {
        this.get('apppanels').addObject(this.get('tabClassName'));
    }.on('didInsertElement'),

    actions: {
        select: function() {
            this.set('selectedTab', this.get('tab'));
        }
    }
});
