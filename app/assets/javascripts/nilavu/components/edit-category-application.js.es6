import { on, observes } from 'ember-addons/ember-computed-decorators';

export default Ember.Component.extend({
    selectedTab: "prepackaged",
    saving: false,
    deleting: false,
    imagepanels: null,


    _initPanels: function() {
        this.set('appelpanels', []);
    }.on('init')/*,

   appelOption: function() {
        const option = this.get('model.appeloption') || "";
        return option.trim().length > 0 ? option : I18n.t("appeloption.default");
    }.property('model.appeloption'),


    appelableChanged: function() {
        this.set('model.appeloption', this.get('appelOption'));
        this.set('selectedTab', this.get('appelOption'));
    }.observes('appelOption')
*/

});
