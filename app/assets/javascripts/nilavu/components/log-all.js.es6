import NilavuURL from 'nilavu/lib/url';
import {    logCategoryPanel } from 'nilavu/components/log-category-panel';
import { on, computed, observes } from  'ember-addons/ember-computed-decorators';

export default logCategoryPanel('all', {
  classNames: ['marginSetup'],
  @observes('message')
  messages() {
      console.log(this.get('message'));
  },
});
