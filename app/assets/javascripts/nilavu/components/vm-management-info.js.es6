import NilavuURL from 'nilavu/lib/url';
import {
    buildCategoryPanel
} from 'nilavu/components/edit-category-panel';
import computed from 'ember-addons/ember-computed-decorators';

export default buildCategoryPanel('info', {

    title: function() {
        return I18n.t("vm_management.info.content_title");
    }.property(),

    resources_title: function() {
        return I18n.t("vm_management.info.content_resources_title");
    }.property(),

    network_title: function() {
        return I18n.t("vm_management.network.tab_title");
    }.property(),

    content_hdd: function() {
        return I18n.t("vm_management.info.content_hdd");
    }.property(),

    content_cpu: function() {
        return I18n.t("vm_management.info.content_cpu");
    }.property(),

    content_ram: function() {
        return I18n.t("vm_management.info.content_ram");
    }.property(),

    content_id: function() {
        return I18n.t("vm_management.info.content_id");
    }.property(),

    content_name: function() {
        return I18n.t("vm_management.info.content_name");
    }.property(),

    content_domain: function() {
        return I18n.t("vm_management.info.content_domain");
    }.property(),

    content_state: function() {
        return I18n.t("vm_management.info.content_state");
    }.property(),

    content_host: function() {
        return I18n.t("vm_management.info.content_host");
    }.property(),

    content_region: function() {
        return I18n.t("vm_management.info.content_region");
    }.property(),

    content_flavor: function() {
        return I18n.t("vm_management.info.content_flavor");
    }.property(),

    content_start_time: function() {
        return I18n.t("vm_management.info.content_start_time");
    }.property(),

    content_hdd_size: function() {
        return I18n.t("vm_management.info.content_hdd_size");
    }.property(),

    content_cpu_cores: function() {
        return I18n.t("vm_management.cpu.content_cpu_cores");
    }.property(),

    content_ram_size: function() {
        return I18n.t("vm_management.ram.content_ram_size");
    }.property(),

    content_private_ip: function() {
        return I18n.t("vm_management.network.content_private_ip");
    }.property(),

    content_ipv4: function() {
        return I18n.t("vm_management.network.content_ipv4");
    }.property(),

    content_ipv6: function() {
        return I18n.t("vm_management.network.content_ipv6");
    }.property(),

    content_private: function() {
        return I18n.t("vm_management.network.content_private");
    }.property(),

    content_public: function() {
        return I18n.t("vm_management.network.content_public");
    }.property(),

    id: function() {
        return this.get('model.id');
    }.property('id'),

    name: function() {
        return this.get('model.name');
    }.property('model.name'),

    domain: function() {
        return this._filterInputs("domain");
    }.property('model.domain'),

    cpu_cores: function() {
        return this._filterInputs("cpu");
    }.property('model.inputs'),

    ram: function() {
        return this._filterInputs("ram");
    }.property('model.inputs'),

    hdd: function() {
        return this._filterInputs("hdd");
    }.property('model.inputs'),

    host: function() {
        return this._filterOutputs("vnchost");
    }.property('model.outputs'),

    region: function() {
        return this._filterInputs("region");
    }.property('model.inputs'),

    flavor: function() {
        return this._filterInputs("resource");
    }.property('model.inputs'),

    privateipv4: function() {
        return this._filterOutputs("privateipv4");
    }.property('model.outputs'),

    ipv4_private: function() {
        return this._checked(this._filterInputs("ipv4private"));
    }.property('model.inputs'),

    ipv4_public: function() {
        return this._checked(this._filterInputs("ipv4public"));
    }.property('model.inputs'),

    ipv6_private: function() {
        return this._checked(this._filterInputs("ipv6private"));
    }.property('model.inputs'),

    ipv6_public: function() {
        return this._checked(this._filterInputs("ipv6public"));
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

    createdAt: function() {
        return new Date(this.get('model.created_at'));
    }.property('model.created_at'),

    status: function() {
        return this.get('model.state');
    }.property('model.state'),

});
