import NilavuURL from 'nilavu/lib/url';
import {
    buildCategoryPanel
} from 'nilavu/components/edit-category-panel';
import computed from 'ember-addons/ember-computed-decorators';

export default buildCategoryPanel('network', {
    content_dns_provider: function() {
        return I18n.t("vm_management.network.content_dns_provider");
    }.property(),

    content_public_ipv4: function() {
        return I18n.t("vm_management.network.content_public_ipv4");
    }.property(),

    content_private_ipv4: function() {
        return I18n.t("vm_management.network.content_private_ipv4");
    }.property(),

    content_public_ipv6: function() {
        return I18n.t("vm_management.network.content_public_ipv6");
    }.property(),

    content_private_ipv6: function() {
        return I18n.t("vm_management.network.content_private_ipv6");
    }.property(),

    privateipv4: function() {
        return this._filterOutputs("privateipv4");
    }.property('model.outputs'),

    publicipv4: function() {
        return this._filterOutputs("publicipv4");
    }.property('model.outputs'),

    privateipv6: function() {
        return this._filterOutputs("privateipv6");
    }.property('model.outputs'),

    publicipv6: function() {
        return this._filterOutputs("publicipv6");
    }.property('model.outputs'),

    showContentPrivateIPV4: function() {
        if (!this._checked(this._filterInputs("ipv4private"))) {
            return "contentDisable";
        }
    }.property('model.inputs'),

    showContentPublicIPV4: function() {
        if (!this._checked(this._filterInputs("ipv4public"))) {
            return "contentDisable";
        }
    }.property('model.inputs'),

    showContentPrivateIPV6: function() {
        if (!this._checked(this._filterInputs("ipv6private"))) {
            return "contentDisable";
        }
    }.property('model.inputs'),

    showContentPublicIPV6: function() {
        if (!this._checked(this._filterInputs("ipv6public"))) {
            return "contentDisable";
        }
    }.property('model.inputs'),

    hasOutputs: Em.computed.notEmpty('model.outputs'),

    hasInputs: Em.computed.notEmpty('model.inputs'),

    _filterInputs(key) {
        if (!this.get('hasInputs')) return "";
        if (!this.get('model.inputs').filterBy('key', key)[0]) return "";
        return this.get('model.inputs').filterBy('key', key)[0].value;
    },

    _filterOutputs(key) {
        if (!this.get('hasOutputs')) return "";
        if (!this.get('model.outputs').filterBy('key', key)[0]) return "";
        return this.get('model.outputs').filterBy('key', key)[0].value;
    },

    _checked(value) {
        if (value == "true") {
            return true;
        } else {
            return false;
        }
    },

});
