import NilavuURL from 'nilavu/lib/url';
import {    buildCategoryPanel } from 'nilavu/components/edit-category-panel';
import computed from 'ember-addons/ember-computed-decorators';

export default buildCategoryPanel('info', {

  title: function() {
    return I18n.t("vm_management.info.content_title");
  }.property(),

  hdd_title: function() {
    return I18n.t("vm_management.info.content_hdd_title");
  }.property(),

  cpu_title: function() {
    return I18n.t("vm_management.info.content_cpu_title");
  }.property(),

  ram_title: function() {
    return I18n.t("vm_management.info.content_ram_title");
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

  content_hdd_size: function() {
    return I18n.t("vm_management.info.content_hdd_size");
  }.property(),

  content_cpu_cores: function() {
    return I18n.t("vm_management.cpu.content_cpu_cores");
  }.property(),

  content_ram_size: function() {
    return I18n.t("vm_management.ram.content_ram_size");
  }.property(),


});
