import NilavuURL from 'nilavu/lib/url';
import {
    logCategoryPanel
} from 'nilavu/components/log-category-panel';
import {
    on,
    computed,
    observes
} from 'ember-addons/ember-computed-decorators';

export default logCategoryPanel('actions', {
    actionMessages: [],

    @observes('message')
    messages() {
        const msg = this.get('message'),
            ss = JSON.parse(this.get('message').Message);
        this.get('actionMessages').pushObject({
            source: ss.Source,
            message: ss.Message,
            timestamp: msg.Timestamp,
        });
    },
});
