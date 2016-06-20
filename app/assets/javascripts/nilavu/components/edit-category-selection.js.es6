import { buildCategoryPanel } from 'nilavu/components/edit-category-panel';

export default buildCategoryPanel('selection', {

    category: function() {
        return this.get('category');
    }.property("category"),

    //is VM we are playing with words :)
    virtuosoOption: Ember.computed.alias('virtuosoable'),

    virtuosoChanged: function() {
      const launchable = this.get('category.launchoption') || "";
        if (launchable.trim().length > 0) {
            const isv = Ember.isEqual(launchable.trim(), I18n.t('launcher.virtualmachines'));
            this.set('virtuosoable', isv);
        }
        return false;
    }.observes('category.launchoption')

});
