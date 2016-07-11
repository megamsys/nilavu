import { on, observes } from 'ember-addons/ember-computed-decorators';

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
        this.set('selectedPackApp','virtualmachine');
        this.searchService.set('searchContextEnabled', true);
    }.on('init'),

    selectedPackAppChanged: function() {
      this.set('searchService.searchContextEnabled', true);
      this.set('searchService.searchContext', this.get('searchContext'));
      this.set('category.versionoption', "");
    }.observes('selectedPackApp', 'searchService.term'),

    searchContext: function() {
      return ({ type: this.get('selectedPackApp'), id: this.get('category.id') });
    }.property('selectedPackApp')

});
