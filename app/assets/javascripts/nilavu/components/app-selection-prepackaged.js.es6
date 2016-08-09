import NilavuURL from 'nilavu/lib/url';
import {default as computed, observes} from 'ember-addons/ember-computed-decorators';

export default Ember.Component.extend({
    tagName: 'div',
    classNameBindings: [
        ':tab-pane', 'isActive:active'
    ],
    selection_title: "",

    isActive: function() {
        const selTab = this.get('selectedTab');      
        if (Em.isEqual(this.get("selectedPackApp"), this.constants.CONTAINER)) {
            this.set('selection_title', I18n.t("launcher.container_search_text"));
        } else {
            this.set('selection_title', I18n.t("launcher.prepackaged_search_text"));
        }
        return selTab.trim().length > 0 && selTab.trim() == 'prepackaged';
    }.property('selectedTab', 'selectedPackApp'),

    selected_chooser_title: function() {
        return this.get('selection_title');
    }.property('selection_title'),

    appHeaderVisible: function() {
        if (!Em.isEmpty(this.get("selectedItem"))) {
            console.log(JSON.stringify(this.get('selectedItem')));
            if (Em.isEqual(this.get("selectedItem").flavor, this.constants.CONTAINERS)) {
                this.set('selectedPackApp', 'container');
            } else {
                this.set('selectedPackApp', 'virtualmachine');
            }
            return false;
        }
        return true;
    }.property(),

    category: function() {
        return this.get('category');
    }.property("category"),

    //says if its vm or container
    @observes('prepackageble')prepackageChanged: function() {
        this.set('category.prepackageoption', this.get('prepackageble'));
    }
});
