import NilavuURL from 'nilavu/lib/url';
import {    buildCategoryPanel } from 'nilavu/components/edit-category-panel';
import computed from 'ember-addons/ember-computed-decorators';

export default buildCategoryPanel('cpu', {

  content_cpu_cores: function() {
    return I18n.t("vm_management.cpu.content_cpu_cores");
  }.property(),


});
