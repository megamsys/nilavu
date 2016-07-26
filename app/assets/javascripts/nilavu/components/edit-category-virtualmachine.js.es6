import {
    on,
    observes
} from 'ember-addons/ember-computed-decorators';

export default Ember.Component.extend({
    selectedTab: "centos",
    saving: false,
    deleting: false,
    imagepanels: null,
    editLaunching: false,

    _initPanels: function() {
        this.set('imagepanels', []);
        this.editLaunching = false;
        if (!Em.isEmpty(this.get("selectedItem"))) {
            this.set('selectedTab', this.get('selectedItem').flavor.toLowerCase());
        }
    }.on('init'),

    tabHeaderVisible: function() {
        if (!Em.isEmpty(this.get("selectedItem"))) {
            return false;
        }
        return true;
    }.property(),

    selectedItemFlavor: function() {
        if (!Em.isEmpty(this.get("selectedItem"))) {
            return this.get('selectedItem').flavor.toLowerCase();
        } else {
            return "";
        }
    }.property('selectedItem'),

    launchOption: function() {
        const option = this.get('model.launchoption') || "";
        return option.trim().length > 0 ? option : I18n.t("launchoption.default");
    }.property('model.launchoption'),


    launchableChanged: function() {
        this.set('model.launchoption', this.get('launchOption'));
        this.set('selectedTab', 'general');
        if (!this.editLaunching) {
            $(".hideme").slideToggle(250);
            this.toggleProperty('editLaunching');
        }
    }.observes('launchOption')


});
