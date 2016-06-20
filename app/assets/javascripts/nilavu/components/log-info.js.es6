import NilavuURL from 'nilavu/lib/url';
import {    logCategoryPanel } from 'nilavu/components/log-category-panel';
import { on, computed, observes } from  'ember-addons/ember-computed-decorators';

export default logCategoryPanel('info', {
  infoMessages: [],
  classNames: ['marginSetup'],
  @observes('message')
  messages() {
      const msg = this.get('message');
      if(msg.Type == 'info') {
        infoMessages.pushObject(msg);
      }
  },
});
