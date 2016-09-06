import DiscoveryController from 'nilavu/controllers/discovery';
import { queryParams } from 'nilavu/controllers/discovery-sortable';
import { computed } from 'ember-addons/ember-computed-decorators';
import { endWith } from 'nilavu/lib/computed';
import showModal from 'nilavu/lib/show-modal';

import OpenComposer from "nilavu/mixins/open-composer";


const controllerOpts = {
  needs: ['discovery'],

  showTop:true,
  showFooter: true,
  period: null,

  canStar: Em.computed.alias('controllers.discovery/topics.currentUser.id'),
  showTopicPostBadges: Em.computed.not('controllers.discovery/topics.new'),

  redirectedReason: Em.computed.alias('currentUser.redirected_to_top.reason'),

  order: 'default',
  ascending: false,
  expandGloballyPinned: false,
  expandAllPinned: false,
  isGrid: true,
  isList: false,

  dashboardTitle: function() {
    return I18n.t("dashboards.title");
  }.property(),

  machineTitle: function() {
    return I18n.t("dashboards.machine");
  }.property(),

  appsTitle: function() {
    return I18n.t("dashboards.apps");
  }.property(),

  servicesTitle: function() {
    return I18n.t("dashboards.services");
  }.property(),

  microTitle: function() {
    return I18n.t("dashboards.micro");
  }.property(),

  torpedoCategory: function() {
    return I18n.t("dashboards.torpedo.category");
  }.property(),

  appCategory: function() {
    return I18n.t("dashboards.app.category");
  }.property(),

  serviceCategory: function() {
    return I18n.t("dashboards.service.category");
  }.property(),

  microserviceCategory: function() {
    return I18n.t("dashboards.microservice.category");
  }.property(),

  actions: {

    createTorpedo() {
      const self = this;
      self.set('isLoadingTorpedo', true);
      self.send('createTopic');
    },

    createApp() {
      const self = this;
      self.set('isLoadingApp', true);
      self.send('createTopic');
    },

    createService() {
      const self = this;
      self.set('isLoadingService', true);
      self.send('createTopic');
    },

    createTopic() {
      const self = this;
      // Don't show  if we're still loading, may be show a growl.
      if (self.get('loading')) { return; }

      self.set('loading', true);

      const promise =  this.openComposer(this.controllerFor("discovery/topics")).then(function(result) {
        showModal('editCategory', {model: result, smallTitle: false, titleCentered: true, close:true});
        self.send('stopLoading');
      }).catch(function(e) {
          self.send('stopLoading');
      });
    },

    stopLoading() {
      const self = this;
      self.set('loading', false);
      self.set('isLoadingTorpedo', false);
      self.set('isLoadingApp', false);
      self.set('isLoadingService', false);
    },

    changeSort(sortBy) {
      if (sortBy === this.get('order')) {
        this.toggleProperty('ascending');
      } else {
        this.setProperties({ order: sortBy, ascending: false });
      }

      this.get('model').refreshSort(sortBy, this.get('ascending'));
    },

    // Show newly inserted topics
    showInserted() {
      const tracker = this.topicTrackingState;
      // Move inserted into topics
      this.get('content').loadBefore(tracker.get('newIncoming'));
      tracker.resetTracking();
      return false;
    },

    refresh() {
      const filter = this.get('model.filter');

      this.setProperties({ order: "default", ascending: false });
      // Don't refresh if we're still loading
      if (this.get('controllers.discovery.loading')) { return; }

      // If we `send('loading')` here, due to returning true it bubbles up to the
      // router and ember throws an error due to missing `handlerInfos`.
      // Lesson learned: Don't call `loading` yourself.
      this.set('controllers.discovery.loading', true);
      this.store.findFiltered('topicList', {filter}).then(list => {
        const TopicList = require('nilavu/models/topic-list').default;
        TopicList.hideUniformCategory(list, this.get('category'));

        this.setProperties({ model: list });

        if (this.topicTrackingState) {
          this.topicTrackingState.sync(list, filter);
        }

        this.send('loadingComplete');
      });
    },

    resetNew() {
      this.topicTrackingState.resetNew();
      Nilavu.Topic.resetNew().then(() => this.send('refresh'));
    },

  },

  isFilterPage: function(filter, filterType) {
    if (!filter) { return false; }
    return filter.match(new RegExp(filterType + '$', 'gi')) ? true : false;
  },

  showDismissRead: function() {
    return this.isFilterPage(this.get('model.filter'), 'unread') && this.get('model.topics.length') > 0;
  }.property('model.filter', 'model.topics.length'),

  showResetNew: function() {
    return this.get('model.filter') === 'new' && this.get('model.topics.length') > 0;
  }.property('model.filter', 'model.topics.length'),

  showDismissAtTop: function() {
    return (this.isFilterPage(this.get('model.filter'), 'new') ||
           this.isFilterPage(this.get('model.filter'), 'unread')) &&
           this.get('model.topics.length') >= 30;
  }.property('model.filter', 'model.topics.length'),

  hasTopics: function() {
    return this.get('model.topics.length') > 0
  }.property('model.topics.length'),

  inkTopicsModel: function() {
    return this.get('model.topics');
  }.property('model.topics'),

  allLoaded: Em.computed.empty('model.more_topics_url'),
  latest: endWith('model.filter', 'latest'),
  new: endWith('model.filter', 'new'),
  top: Em.computed.notEmpty('period'),
  yearly: Em.computed.equal('period', 'yearly'),
  quarterly: Em.computed.equal('period', 'quarterly'),
  monthly: Em.computed.equal('period', 'monthly'),
  weekly: Em.computed.equal('period', 'weekly'),
  daily: Em.computed.equal('period', 'daily'),

  footerMessage: function() {
    if (!this.get('allLoaded')) { return; }

    const category = this.get('category');
    if( category ) {
      return I18n.t('topics.bottom.category', {category: category.get('name')});
    } else {
      const split = (this.get('model.filter') || '').split('/');
      if (this.get('model.topics.length') === 0) {
        return I18n.t("topics.none." + split[0], {
          category: split[1]
        });
      } else {
        return I18n.t("topics.bottom." + split[0], {
          category: split[1]
        });
      }
    }
  }.property('allLoaded', 'model.topics.length'),

  footerEducation: function() {
    if (!this.get('allLoaded') || this.get('model.topics.length') > 0 || !Nilavu.User.current()) { return; }

    const split = (this.get('model.filter') || '').split('/');

    if (split[0] !== 'new' && split[0] !== 'unread') { return; }

    return I18n.t("topics.none.educate." + split[0], {
      userPrefsUrl: Nilavu.getURL("/users/") + (Nilavu.User.currentProp("username_lower")) + "/preferences"
    });
  }.property('allLoaded', 'model.topics.length'),

  loadMoreTopics() {
    return this.get('model').loadMore();
  }
};

Ember.keys(queryParams).forEach(function(p) {
  // If we don't have a default value, initialize it to null
  if (typeof controllerOpts[p] === 'undefined') {
    controllerOpts[p] = null;
  }
});

export default DiscoveryController.extend(controllerOpts, OpenComposer);
