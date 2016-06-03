import NilavuURL from 'nilavu/lib/url';
import {    buildCategoryPanel } from 'nilavu/components/edit-category-panel';
import computed from 'ember-addons/ember-computed-decorators';

export default buildCategoryPanel('info', {

  title: function() {
    return I18n.t("vm_management.info.content_title");
  }.property(),

  keys_title: function() {
    return I18n.t("vm_management.info.keys_title");
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

  content_start_time: function() {
    return I18n.t("vm_management.info.content_start_time");
  }.property(),

  content_sshkey_name: function() {
    return I18n.t("vm_management.info.content_name");
  }.property(),

  content_private_sshkey: function() {
    return I18n.t("vm_management.info.content_private_sshkey");
  }.property(),

  content_public_sshkey: function() {
    return I18n.t("vm_management.info.content_public_sshkey");
  }.property(),

  actions: {

    privatekey_download(key) {
      this.get('model').privatekey_download(key);
    }

  }


});
