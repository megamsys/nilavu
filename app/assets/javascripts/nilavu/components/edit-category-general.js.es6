import NilavuURL from 'nilavu/lib/url';
import { buildCategoryPanel } from 'nilavu/components/edit-category-panel';
//import { categoryBadgeHTML } from 'nilavu/helpers/category-link';
//import Category from 'nilavu/models/category';

export default buildCategoryPanel('general', {
  //TO-DO toggleProperty("subDomainValid"), if not don't allow to launch
  subDomain: function() {
    const subdomain  = this.get('category.random_name');
    return subdomain.trim().length > 0  ? subdomain : "launch.domain_name";
  }.property('category.random_name'),

  domain: function() {
    const domain  = this.get('category.domain');
    return domain.trim().length > 0 ? domain : "launch.domain";
  }.property('category.domain'),

  regions: Em.computed.alias('category.regions'),

  resources: function() {
    const _regionOption =  this.get('regionOption');
    const fullFlavor = this.get('regions').filter(function(c) {
    if (c.name == _regionOption) {
      return c;
    }
    });
    return fullFlavor;
  }.property('regionOption'),

  // We need to get the regions from the Draft model
  showSubRegions: function() {
    if (Ember.isEmpty(this.get('category.regions'))) {
      return null;
    }
    return this.get('category.regions');
  }.property('category.regions'),

  // We need to get the regions from the Draft model
  regionOption: function() {
    alert(this.get('category.regionoption'));
    /*if (Ember.isEmpty(this.get('category.regions')) && this.get('model.regionOption').trim().length >0) {
      return null;
    }
    return this.get('category.regions');*/
    return null;
  }.property('category.regionoption'),

  // We need to get the regions from the Draft model
  showSubResources: function() {
    /*if (Ember.isEmpty(this.get('category.regions')) && this.get('model.regionOption').trim().length >0) {
      return null;
    }
    return this.get('category.regions');*/
    return false;
  }.property('category.regionoption'),

  //TO-DO togglePropert("subDomainValid"), if not don't allow to launch
  subDomain: function() {
    const subdomain  = this.get('category.random_name');
    return subdomain.trim().length > 0  ? subdomain : "launch.domain_name";
  }.property('category.random_name'),

  domain: function() {
    const domain  = this.get('category.domain');
    return domain.trim().length > 0 ? domain : "launch.domain";
  }.property('category.domain'),

  regionChanged: function() {
    alert("regionChanged " + this.get('regionOption'));
    this.set('category.regionoption', this.get('regionOption'));
    alert("this.get model "  + this.get('category.regionoption'));
  }.observes('regionOption'),

  regionOption: function() {
    if (Ember.isEmpty(this.get('category.regions')) && this.get('category.regionoption').trim().length >0) {
      return true;
    }
    return false;
  }.property('category.regions', 'category.regionoption'),

  resourceOption: function() {
    if (Ember.isEmpty(this.get('category.regions')) && this.get('category.resourceoption').trim().length >0) {
      return true;
    }
    return false;
  }.property('category.regions', 'category.resourceoption'),

  regionChanged: function() {
    this.$(".hideme2").slideToggle(150);
    this.set('category.regionoption', this.get('regionOption'));
  }.observes('regionOption'),

  resourceChanged: function() {
    this.$(".hideme3").slideToggle(150);
    this.set('category.resourceoption', this.get('resourceOption'));
  }.observes('resourceOption'),

  actions: {
    showCategoryTopic() {
      NilavuURL.routeTo(this.get('category.topic_url'));
      return false;
    }
  }
});
