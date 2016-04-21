import LogsNotice from 'nilavu/services/logs-notice';
import Singleton from 'nilavu/mixins/singleton';

export default {
  name: "logs-notice",

  initialize: function (container) {
    const siteSettings = container.lookup('site-settings:main');
    const keyValueStore = container.lookup('key-value-store:main');
    const currentUser = container.lookup('current-user:main');
    LogsNotice.reopenClass(Singleton, {
      createCurrent() {
        return this.create({keyValueStore, siteSettings, currentUser });
      }
    });
  }
};
