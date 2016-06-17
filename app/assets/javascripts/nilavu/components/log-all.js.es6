import NilavuURL from 'nilavu/lib/url';
import {    logCategoryPanel } from 'nilavu/components/log-category-panel';
import { on, computed, observes } from  'ember-addons/ember-computed-decorators';

export default logCategoryPanel('all', {
  @observes('message')
  arrived() {
      console.log(this.get('message'));
  },
});
