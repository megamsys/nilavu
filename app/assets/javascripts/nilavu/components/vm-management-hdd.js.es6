import NilavuURL from 'nilavu/lib/url';
import {    buildCategoryPanel } from 'nilavu/components/edit-category-panel';
import computed from 'ember-addons/ember-computed-decorators';

export default buildCategoryPanel('hdd', {

  content_hdd_size: function() {
    return I18n.t("vm_management.hdd.content_hdd_size");
  }.property(),


});
