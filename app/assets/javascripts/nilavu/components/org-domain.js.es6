import NilavuURL from 'nilavu/lib/url';
import {    orgCategoryPanel } from 'nilavu/components/org-category-panel';
import { on, computed } from  'ember-addons/ember-computed-decorators';

export default orgCategoryPanel('domain', {
  name: function() {
      return this.get('model.details');
  }.property('model.details'),

});
