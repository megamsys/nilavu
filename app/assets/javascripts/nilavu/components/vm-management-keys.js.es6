import NilavuURL from 'nilavu/lib/url';
import {    buildCategoryPanel } from 'nilavu/components/edit-category-panel';
import computed from 'ember-addons/ember-computed-decorators';

export default buildCategoryPanel('keys', {

  content_sshkey_name: function() {
    return I18n.t("vm_management.keys.content_name");
  }.property(),

  content_private_sshkey: function() {
    return I18n.t("vm_management.keys.content_private_sshkey");
  }.property(),

  content_public_sshkey: function() {
    return I18n.t("vm_management.keys.content_public_sshkey");
  }.property(),

  keys_title: function() {
    return I18n.t("vm_management.keys.keys_title");
  }.property(),

  actions: {

    privatekey_download(key) {
      this.get('model').privatekey_download(key);
    }

  }


});
