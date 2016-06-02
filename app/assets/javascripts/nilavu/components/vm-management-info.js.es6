import NilavuURL from 'nilavu/lib/url';
import {    buildCategoryPanel } from 'nilavu/components/edit-category-panel';
import computed from 'ember-addons/ember-computed-decorators';

export default buildCategoryPanel('info', {

  title: function() {
    return I18n.t("vm_management.info.content_title");
  }.property(),

});
