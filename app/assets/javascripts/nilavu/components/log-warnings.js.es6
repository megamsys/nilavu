import NilavuURL from 'nilavu/lib/url';
import {
    logCategoryPanel
} from 'nilavu/components/log-category-panel';
import {
    on,
    computed,
    observes
} from 'ember-addons/ember-computed-decorators';

export default logCategoryPanel('warnings', {
    warningMessages: [],

    @observes('message')
    messages() {
        const msg = this.get('message'),
            ss = JSON.parse(this.get('message').Message);
        if (ss.Type == 'warning') {
            this.get('warningMessages').pushObject({
                source: ss.Source,
                message: ss.Message,
                timestamp: msg.Timestamp,
            });
        }
    },
});
