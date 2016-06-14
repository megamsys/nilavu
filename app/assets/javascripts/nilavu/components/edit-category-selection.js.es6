import { buildCategoryPanel } from 'nilavu/components/edit-category-panel';

export default buildCategoryPanel('selection', {

  category: function() {
      return this.get('category');
  }.property("category"),

  isVirtualMachine: function() {
      const launchable = this.get('category.launchoption') || "";
      return (launchable.trim.length > 0 && Ember.isEqual(launchable.trim(), I18n.t('launcher.virtualmachines')));
  }.observes('category.launchoption')

});
