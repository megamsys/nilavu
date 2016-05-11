import NilavuURL from 'nilavu/lib/url';
import { buildCategoryPanel } from 'nilavu/components/edit-category-panel';
import { categoryBadgeHTML } from 'nilavu/helpers/category-link';
import Category from 'nilavu/models/category';

export default buildCategoryPanel('general', {
  foregroundColors: ['FFFFFF', '000000'],
  canSelectParentCategory: Em.computed.not('category.isUncategorizedCategory'),
  regions: Em.computed.alias('category.regions'),

  // background colors are available as a pipe-separated string
  backgroundColors: function() {
  /*  const categories = Nilavu.Category.list();
    return this.siteSettings.category_colors.split("|").map(function(i) { return i.toUpperCase(); }).concat(
                categories.map(function(c) { return c.color.toUpperCase(); }) ).uniq(); */
  return ['green'];
  }.property(),

  usedBackgroundColors: function() {
    const categories = Nilavu.Category.list();
    const category = this.get('category');

    // If editing a category, don't include its color:
    return categories.map(function(c) {
      return (category.get('id') && category.get('color').toUpperCase() === c.color.toUpperCase()) ? null : c.color.toUpperCase();
    }, this).compact();
  }.property('category.id', 'category.color'),

  parentCategories: function() {
    return Nilavu.Category.list().filter(function (c) {
      return !c.get('parentCategory');
    });
  }.property(),

  categoryBadgePreview: function() {
    const category = this.get('category');
    const c = Category.create({
      name: category.get('categoryName'),
      color: category.get('color'),
      text_color: category.get('text_color'),
      parent_category_id: parseInt(category.get('parent_category_id'),10),
      read_restricted: category.get('read_restricted')
    });
    return categoryBadgeHTML(c, {link: false});
  }.property('category.parent_category_id', 'category.categoryName', 'category.color', 'category.text_color'),


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


  actions: {
    showCategoryTopic() {
      NilavuURL.routeTo(this.get('category.topic_url'));
      return false;
    }
  }
});
