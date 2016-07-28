import Session from 'nilavu/models/session';
import KeyValueStore from 'nilavu/lib/key-value-store';
import AppEvents from 'nilavu/lib/app-events';
import Store from 'nilavu/models/store';
import NilavuURL from 'nilavu/lib/url';
import NilavuLocation from 'nilavu/lib/nilavu-location';
import SearchService from 'nilavu/services/search';
import NotificationMessagesService from 'nilavu/services/notification-messages';
import SocketIOService from 'nilavu/services/socket-io';
import WebsocketsService from 'nilavu/services/websockets';
import PanelActionsService from 'nilavu/services/panel-actions';
import ConstantsService from 'nilavu/services/constants';
import { startTracking, default as TopicTrackingState } from 'nilavu/models/topic-tracking-state';
import ScreenTrack from 'nilavu/lib/screen-track';

function inject() {
  const app = arguments[0],
        name = arguments[1],
        singletonName = Ember.String.underscore(name).replace(/_/g, '-') + ':main';

  Array.prototype.slice.call(arguments, 2).forEach(dest => app.inject(dest, name, singletonName));
}

function injectAll(app, name) {
  inject(app, name, 'controller', 'component', 'route', 'view', 'model', 'adapter');
}

export default {
  name: "inject-discourse-objects",

  initialize(container, app) {
    const appEvents = AppEvents.create();
    app.register('app-events:main', appEvents, { instantiate: false });
    injectAll(app, 'appEvents');
    NilavuURL.appEvents = appEvents;

    app.register('store:main', Store);
    inject(app, 'store', 'route', 'controller');

    const messageBus = window.MessageBus;

    const currentUser = Nilavu.User.current();
    app.register('current-user:main', currentUser, { instantiate: false });

    const topicTrackingState = TopicTrackingState.create({ messageBus, currentUser });
    app.register('topic-tracking-state:main', topicTrackingState, { instantiate: false });
    injectAll(app, 'topicTrackingState');

    const site = Nilavu.Site.current();
    app.register('site:main', site, { instantiate: false });
    injectAll(app, 'site');

    const siteSettings = Nilavu.SiteSettings;
    app.register('site-settings:main', siteSettings, { instantiate: false });
    injectAll(app, 'siteSettings');

    app.register('search-service:main', SearchService);
    injectAll(app, 'searchService');

    app.register('notification-messages:main', NotificationMessagesService);
    injectAll(app, 'notificationMessages');

    app.register('socket-io:main', SocketIOService);
    injectAll(app, 'socketIO');

    app.register('websockets:main', WebsocketsService);
    injectAll(app, 'websockets');

    app.register('panel-actions:main', PanelActionsService);
    injectAll(app, 'panelActions');

    app.register('constants:main', ConstantsService);
    injectAll(app, 'constants');

    const session = Session.current();
    app.register('session:main', session, { instantiate: false });
    injectAll(app, 'session');

    const screenTrack = new ScreenTrack(topicTrackingState, siteSettings, session, currentUser);
    app.register('screen-track:main', screenTrack, { instantiate: false });
    inject(app, 'screenTrack', 'component', 'route');

    inject(app, 'currentUser', 'component', 'route', 'controller');

    app.register('location:nilavu-location', NilavuLocation);

    const keyValueStore = new KeyValueStore("nilavu_");
    app.register('key-value-store:main', keyValueStore, { instantiate: false });
    injectAll(app, 'keyValueStore');

    startTracking(topicTrackingState);
  }
};
