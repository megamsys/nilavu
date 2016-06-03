import NilavuURL from 'nilavu/lib/url';
import {    buildCategoryPanel } from 'nilavu/components/edit-category-panel';
import computed from 'ember-addons/ember-computed-decorators';

export default buildCategoryPanel('network', {

  content_dns_provider: function() {
    return I18n.t("vm_management.network.content_dns_provider");
  }.property(),

  content_public_ip: function() {
    return I18n.t("vm_management.network.content_public_ip");
  }.property(),

  content_private_ip: function() {
    return I18n.t("vm_management.network.content_private_ip");
  }.property(),

  content_reattach_ip: function() {
    return I18n.t("vm_management.network.content_reattach_ip");
  }.property(),  


});
