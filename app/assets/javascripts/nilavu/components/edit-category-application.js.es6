import {
    on,
    observes
} from 'ember-addons/ember-computed-decorators';

export default Ember.Component.extend({
    selectedTab: "prepackaged",

    selectedPackApp: null,

    saving: false,
    apppanels: null,

    category: function() {
        return this.get('category');
    }.property("category"),

    _initPanels: function() {
        this.set('apppanels', []);
        this.set('selectedPackApp', 'virtualmachine');
        this.searchService.set('searchContextEnabled', true);
    }.on('init'),

    selectedPackAppChanged: function() {
        this.set('searchService.searchContextEnabled', true);
        this.set('searchService.searchContext', this.get('searchContext'));
        this.set('category.versionoption', "");
    }.observes('selectedPackApp', 'searchService.term'),

    searchContext: function() {
        return ({
            type: this.get('selectedPackApp'),
            id: this.get('category.id')
        });
    }.property('selectedPackApp'),

    tabHeaderVisible: function() {
        if (!Em.isEmpty(this.get("selectedItem"))) {
            return false;
        }
        return true;
    }.property(),

    selectedItemType: function() {
        if (!Em.isEmpty(this.get("selectedItem"))) {
            if (Em.isEqual(this.get('selectedItem').cattype, this.constants.APP)) {
                this.set('selectedTab', 'customapp');
                return "customapp"
            } else {
                this.set('selectedTab', 'prepackaged');
                return "prepackaged"
            }
        } else {
            return "";
        }
    }.property('selectedItem'),

});
