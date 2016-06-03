import { buildCategoryPanel } from 'nilavu/components/edit-category-panel';

export default buildCategoryPanel('selection', {

  isVirtualMachine: function() {
      const launchable = this.get('launchOption') || "";
      return (launchable.trim.length > 0 && Ember.isEqual(launchable.trim(), I18n.t('launcher.virtualmachines')));
  }.observes('category.launchoption')

});
