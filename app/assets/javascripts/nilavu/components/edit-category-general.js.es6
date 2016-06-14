import NilavuURL from 'nilavu/lib/url';
import {
    buildCategoryPanel
} from 'nilavu/components/edit-category-panel';
import computed from 'ember-addons/ember-computed-decorators';

export default buildCategoryPanel('general', {

    editingResource: false,
    editingCost: false,

    category: function() {
        return this.get('category');
    }.property("category"),

    //TO-DO togglePropert("subDomainValid"), if not don't allow to launch
    subDomain: function() {
        const subdomain = this.get('category.random_name');
        return subdomain.trim().length > 0 ? subdomain : "launch.domain_name";
    }.property('category.random_name'),

    domain: function() {
        const domain = this.get('category.domain');
        return domain.trim().length > 0 ? domain : "launch.domain";
    }.property('category.domain'),

    regions: Em.computed.alias('category.regions'),

    // We need to get the regions from the Draft model
    showSubRegions: function() {
        if (Ember.isEmpty(this.get('category.regions'))) {
            return null;
        }

      return this.get('category.regions');

    }.property('category.regions'),

    resources: function() {
        const _regionOption = this.get('regionOption');
        const fullFlavor = this.get('regions').filter(function(c) {
            if (c.name == _regionOption) {
                return c;
            }
        });

        return fullFlavor;
    }.property('category.regionoption', 'regionOption'),


    regionChanged: function() {
        if (!this.editingResource) {
            this.$(".hideme2").slideToggle(150);
            this.toggleProperty('editingResource');
        }
        if (this.editingCost) {
            this.toggleProperty('editingCost');
            $(".hideme3").slideToggle(250);
        }
        this.set('category.regionoption', this.get('regionOption'));


    }.observes('regionOption'),

    regionOption: function() {
        if (Ember.isEmpty(this.get('category.regions')) && this.get('category.regionoption').trim().length > 0) {
            return this.get('category.regionoption');
        }
        return null;
    }.property('category.regions', 'category.regionoption'),

    resourceOption: function() {
        if (Ember.isEmpty(this.get('category.regions')) && this.get('category.resourceoption').trim().length > 0) {
            return this.get('category.resourceoption');

        }
        return null;
    }.property('category.regions', 'category.resourceoption'),

    resourceChanged: function() {
        this.set('category.resourceoption', this.get('resourceOption'));
        if (!this.editingCost) {
            $(".hideme3").slideToggle(250);
            this.toggleProperty('editingCost');
        }
    }.observes('resourceOption'),

    //TO-DO nove the StorageOption to a model StorageType like PermissionType
    storageOption: function() {
        //let HDD = 'HDD';

        if (Ember.isEmpty(this.get('category.regions')) &&
            this.get('category.resourceoption').trim().length > 0) {
            return true;
        }
        //return HDD;
        return false;
    }.property('category.storageOption'),

    storageChanged: function() {
        this.set('category.storageoption', this.get('storageOption'));
    }.observes('storageOption'),

    actions: {
        showCategoryTopic() {
            NilavuURL.routeTo(this.get('category.topic_url'));
            return false;
        }
    }
});
