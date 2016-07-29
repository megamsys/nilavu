import NilavuURL from 'nilavu/lib/url';
import {
    logCategoryPanel
} from 'nilavu/components/log-category-panel';
import {
    on,
    computed,
    observes
} from 'ember-addons/ember-computed-decorators';

export default logCategoryPanel('info', {
    infoMessages: [],
    @observes('message')
    messages() {
        const msg = this.get('message'),
            ss = JSON.parse(this.get('message').Message);
        if (Ember.isEqual(ss.Type.toLowerCase(), 'info')) {
            this.get('infoMessages').pushObject({
              source: ss.Source,
              type: ss.Type,
              color: "log-"+ss.Type.toLowerCase(),
              message: ss.Message,
              timestamp: msg.Timestamp,
            });
        }
    },
});
