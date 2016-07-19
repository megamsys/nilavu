import NilavuURL from 'nilavu/lib/url';
import {
    buildCategoryPanel
} from 'nilavu/components/edit-category-panel';
import computed from 'ember-addons/ember-computed-decorators';

export default buildCategoryPanel('ram', {

    content_ram_size: function() {
        return I18n.t("vm_management.ram.content_ram_size");
    }.property(),

    ram: function() {
        return this._filterInputs("ram");
    }.property('model.inputs'),

    hasInputs: Em.computed.notEmpty('model.inputs'),

    _filterInputs(key) {
        if (!this.get('hasInputs')) return "";
        if (!this.get('model.inputs').filterBy('key', key)[0]) return "";
        return this.get('model.inputs').filterBy('key', key)[0].value;
    },

});
