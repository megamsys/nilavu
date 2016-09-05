import NilavuURL from 'nilavu/lib/url';

export default Ember.Controller.extend({
  needs: ['navigation/category', 'discovery/topics', 'application'],
  showTop: true,
  showFooter: true,
  loading: false,
  isLoadingTorpedo: false,
  isLoadingApp: false,
  isLoadingService: false,

  category: Em.computed.alias('controllers.navigation/category.category'),
  noSubcategories: Em.computed.alias('controllers.navigation/category.noSubcategories'),

  loadedAllItems: Em.computed.not("controllers.discovery/topics.model.canLoadMore"),

  _showFooter: function() {
    this.set("controllers.application.showFooter", this.get("loadedAllItems"));
  }.observes("loadedAllItems"),

  showMoreUrl(period) {
    let url = '', category = this.get('category');
    if (category) {
      url = '/c/' + Nilavu.Category.slugFor(category) + (this.get('noSubcategories') ? '/none' : '') + '/l';
    }
    url += '/top/' + period;
    return url;
  },

  actions: {
    changePeriod(p) {
      NilavuURL.routeTo(this.showMoreUrl(p));
    },
  }

});
