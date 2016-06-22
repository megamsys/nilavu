import NilavuURL from 'nilavu/lib/url';
import {    buildCategoryPanel } from 'nilavu/components/edit-category-panel';
import computed from 'ember-addons/ember-computed-decorators';

export default buildCategoryPanel('apikey', {

  api_key: function() {
      return this.get('model.api_key');
  }.property('model.api_key'),

  createdAt: function() {
      return this.get('model.createdAt');
  }.property('model.createdAt'),

});
