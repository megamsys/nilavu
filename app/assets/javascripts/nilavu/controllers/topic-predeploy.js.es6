import NilavuURL from 'nilavu/lib/url';
import { autoUpdatingRelativeAge } from 'nilavu/lib/formatter';
import Clock from 'nilavu/services/clock';
import NilavuPollster from 'nilavu/lib/nilavu-pollster';
import { headerHeight } from 'nilavu/components/site-header';
import computed from "ember-addons/ember-computed-decorators";
import LaunchStatus from "nilavu/models/launch-status";

export default Ember.Controller.extend({
    needs: ['topic', 'topic-predeploy'],

    clock: null,

    loading: false,

    deploySuccess: false,

    deployError: false,

    nameEnabled: true,

    title: I18n.t('launcher.predeployer'),


    name: function() {
        return this.get('model.name');
    }.property('model.name'),

    createdAt: function(){
      return this.get('model.created_at');
    }.property('model.created_at'),

    unreadNotification: false,

    progressPosition: 0,

    maxProgressPosition: 100,

    barHead: function() {
        if (this.deploySuccess) {
            this.set('barLabel', "Success, redirecting to management...");
            return 'success';
        }

        if (this.deployError) {
            this.set('barLabel', "Ooops, try relaunching...");
            return 'danger';
        }
        this.set('barLabel', "Launching...");
        return 'none';
    }.property('progressPosition', 'streamPercentage'),

    id: Ember.computed.alias('model.id'),

    _initPoller: function() {
        this.set('notifications', []);
        this.set('clock', Clock.create());
    }.on('init'),

    @computed('model.postStream.posts')
    postsToRender() {
        return this.get('model.postStream.posts');
    },

    // Add the new notification into the model stream
    predeployNotificationChanged: function() {
        //state.notifications.map(n => this.attach('notification-item', n));
        const self = this;
        const deployLiveFeed = this.get('notifications');

        if (Ember.isEmpty(deployLiveFeed)) {
            return
        };

        deployLiveFeed.forEach(feed => {
            const postStream = this.get('model.postStream');
            const events = feed.event_type.split('.')[2].toUpperCase();
            switch (events) {
                case LaunchStatus.TYPES_SUCCESS.RUNNING:
                    {
                        postStream.triggerNewPostInStream(feed).then(() => {
                            self.stopPolling();
                            self.appEvents.trigger('post-stream:refresh', { id: self.get('model.id') });
                            self.notificationMessages.success(I18n.t('launcher.launched') + " " + this.get('model.name'));
                            self.set('deploySuccess', true);
                        });
                        break;
                    }
                case LaunchStatus.TYPES_ERROR.ERROR:
                    {
                        postStream.triggerNewPostInStream(feed).then(() => {
                            self.stopPolling();
                            self.appEvents.trigger('post-stream:refresh', { id: self.get('model.id') });
                            self.notificationMessages.error(I18n.t('launcher.not_launched') + " " + this.get('model.name'));
                            self.set('deployError', true);
                        });
                        break;
                    }
                    case LaunchStatus.TYPES.LAUNCHING:
                    case LaunchStatus.TYPES.LAUNCHED:
                    case LaunchStatus.TYPES.BOOTSTRAPPING:
                    case LaunchStatus.TYPES.BOOTSTRAPPED:
                    case LaunchStatus.TYPES.STATEUPSTARTING:
                    case LaunchStatus.TYPES.CHEFRUNNING:
                    case LaunchStatus.TYPES.COOKBOOKSUCCESS:
                    case LaunchStatus.TYPES.AUTHKEYSADDED:
                    case LaunchStatus.TYPES.ROUTEADDED:
    		            case LaunchStatus.TYPES.CHEFCONFIGSETUPSTARTING:
    		            case LaunchStatus.TYPES.CHEFCONFIGSETUPSTARTED:
    		            case LaunchStatus.TYPES.GITCLONED:
    		            case LaunchStatus.TYPES.GITCLONING:
    		            case LaunchStatus.TYPES.UPDATING:
                    case LaunchStatus.TYPES.VNCHOSTUPDATING:
    		            case LaunchStatus.TYPES.UPDATED:
    		            case LaunchStatus.TYPES.DOWNLOADED:
    		            case LaunchStatus.TYPES.DOWNLOADING:
    		            case LaunchStatus.TYPES.COOKBOOK_DOWNLOADING:
    		            case LaunchStatus.TYPES.COOKBOOK_DOWNLOADED:
                    case LaunchStatus.TYPES.AUTHKEYSUPDATING:
                    case LaunchStatus.TYPES.AUTHKEYSUPDATED:
                    case LaunchStatus.TYPES.IP_UPDATING:
                    case LaunchStatus.TYPES.IP_UPDATED:
                    case LaunchStatus.TYPES.DNSNAMESKIPPED:
                    {
                        postStream.triggerNewPostInStream(feed).then(() => {
                            self.appEvents.trigger('post-stream:refresh', { id: self.get('model.id') });
                        });
                        break;
                    }
                default:
                    {
                        Em.Logger.warn("unknown topic live feed type", feed);
                    }
            }
        });
    }.observes('unreadNotification'),

    subscribe: function() {
        // Unsubscribe before subscribing again
        this.unsubscribe();

        this.startPolling();
        this.startClocker();

        const pollster = this.get('pollster');

        if (pollster) {
            pollster.start();
        }
    },

    startPolling: function() {
        const self = this;
        if (Ember.isNone(this.get('pollster'))) {
            this.set('pollster', NilavuPollster.create({
                onPoll: function() {
                    self.refreshNotifications();
                }
            }));
        }
    },

    stopPolling: function() {
        this.get('pollster').stop();
    },

    startClocker: function() {
        if (this.get('clock')) {
            this.get('clock').start();
        }
    },

    refreshNotifications() {
        const id = this.get('id');

        if (this.loading) {
            return;
        }
        // estimate (poorly) the amount of notifications to return
        let limit = Math.round(($(window).height() - headerHeight()) / 55);
        // we REALLY don't want to be asking for negative counts of notifications
        // less than 5 is also not that useful
        if (limit < 5) { limit = 5; }
        if (limit > 40) { limit = 40; }

        const stale = this.store.findStale('notification', { id: id, recent: true, limit }, { cacheKey: 'recent-notifications' });

        if (stale.hasResults) {
            const results = stale.results;
            let content = results.get('content');

            // we have to truncate to limit, otherwise we will render too much
            if (content && (content.length > limit)) {
                content = content.splice(0, limit);
                results.set('content', content);
                results.set('totalRows', limit);
            }
            this.set('notifications', results);
            this.toggleProperty('unreadNotification');
        } else {
            this.loading = true;
        }

        stale.refresh().then(notifications => {
            this.set('notifications', notifications);
            this.toggleProperty('unreadNotification');
        }).catch(() => {
            this.set('notifications', []);
            this.toggleProperty('unreadNotification');
        }).finally(() => {
            this.loading = false;
        });
    },

    unsubscribe() {
        if (this.get('pollster')) {
            this.stopPolling();
        }
        if (this.get('clock')) {
            this.get('clock').stop();
        }
        this.set('deploySuccess', false);
        this.set('deployError', false);
        this.set('progressPosition', false);
    },

    actions: {

      showVNC() {
          this.get('controllers.topic').send('showVNC');
      },
        // Called the the topmost visible post on the page changes.
        topVisibleChanged(event) {
            const { post, refresh } = event;

            if (!post) {
                return;
            }

            const postStream = this.get('model.postStream');
            const firstLoadedPost = postStream.get('posts.firstObject');

            const currentPostNumber = post.get('post_number');
            this.set('model.currentPost', currentPostNumber);
            this.send('postChangedRoute', currentPostNumber);

            if (post.get('post_number') === 1) {
                return;
            }

            if (firstLoadedPost && firstLoadedPost === post) {
                postStream.prependMore().then(() => refresh());
            }
        },

        //  Called the the bottommost visible post on the page changes.
        bottomVisibleChanged(event) {
            const { post, refresh } = event;

            const postStream = this.get('model.postStream');
            const lastLoadedPost = postStream.get('posts.lastObject');

            this.set('controllers.topic-predeploy.progressPosition', postStream.progressIndexOfPost(post));

            if (lastLoadedPost && lastLoadedPost === post && postStream.get('canAppendMore')) {
                postStream.appendMore().then(() => refresh());
                // show loading stuff
                refresh();
            }
        },

        toggleExpansion(opts) {
            this.toggleProperty('expanded');
            if (this.get('expanded')) {
                this.set('toPostIndex', this.get('progressPosition'));
                if (opts && opts.highlight) {
                    // TODO: somehow move to view?
                    Em.run.next(function() {
                        $('.jump-form input').select().focus();
                    });
                }
            }
        },

        jumpPost() {
            var postIndex = parseInt(this.get('toPostIndex'), 10);

            // Validate the post index first
            if (isNaN(postIndex) || postIndex < 1) {
                postIndex = 1;
            }
            if (postIndex > this.get('model.postStream.filteredPostsCount')) {
                postIndex = this.get('model.postStream.filteredPostsCount');
            }
            this.set('toPostIndex', postIndex);
            var stream = this.get('model.postStream'),
                postId = stream.findPostIdForPostNumber(postIndex);

            if (!postId) {
                Em.Logger.warn("jump-post code broken - requested an index outside the stream array");
                return;
            }

            var post = stream.findLoadedPost(postId);
            if (post) {
                this.jumpTo(this.get('model').urlForPostNumber(post.get('post_number')));
            } else {
                var self = this;
                // need to load it
                stream.findPostsByIds([postId]).then(function(arr) {
                    post = arr[0];
                    self.jumpTo(self.get('model').urlForPostNumber(post.get('post_number')));
                });
            }
        },

        jumpTop() {
            this.jumpTo(this.get('model.firstPostUrl'));
        },

        jumpBottom() {
            this.jumpTo(this.get('model.lastPostUrl'));
        }

    },

    streamPercentage: function() {
        return this.get('progressPosition');
    }.property('model.postStream.loaded', 'progressPosition', 'model.postStream.filteredPostsCount'),

    // Route and close the expansion
    jumpTo(url) {
        NilavuURL.routeTo(url);
    },

    jumpTopDisabled: function() {
        return this.get('progressPosition') <= 3;
    }.property('progressPosition'),

    filteredPostCountChanged: function() {
        const p = this.get('progressPosition');
        const f = this.get('model.postStream.filteredPostsCount');
        var s = p + f;

        if (s >= this.maxProgressPosition) {
            return this.set('progressPosition', this.maxProgressPosition);
        }

        this.set('progressPosition', s);

    }.observes('model.postStream.filteredPostsCount'),

    jumpToPostLaunch: function() {
        if (!this.get('deploySuccess')) { return }

        Ember.run.debounce(this, () => {
            this.notificationMessages.success(I18n.t('launcher.launched_redirecting'));
            this.set('model.postStream.loading', false);
            this.set('progressPosition', this.maxProgressPosition);
            this.set('model.predeploy_finished', true);

            const slugId = this.get('model.id') ? this.get('model.id') : "";
            const depOK = this.get('deploySuccess');

            const category = this.get("model.tosca_type").split(".")[1];
            var url = '/t/' + slugId;

            if (!Em.isEqual(category, "torpedo")) {
              url = '/t/' + slugId + '/app';
            }

            if (slugId && depOK) {
                this.jumpTo(url);
            } else {
                this.jumpTo('/');
            }
        }, 1500);
    }.observes('deploySuccess'),

    stayOnPage: function() {
      if (!this.get('deployError')) { return }

      Ember.run.debounce(this, () => {
          this.set('model.postStream.loading', false);
          this.set('progressPosition', this.maxProgressPosition);
      }, 1500);
    }.observes('deployError'),

    jumpBottomDisabled: function() {
        return this.get('progressPosition') >= this.get('model.postStream.filteredPostsCount') ||
            this.get('progressPosition') >= this.get('model.highest_post_number');
    }.property('model.postStream.filteredPostsCount', 'model.highest_post_number', 'progressPosition'),

    hideProgress: function() {
        if (!this.get('model.postStream.loaded')) return true;
        if (!this.get('model.currentPost')) return true;
        if (this.get('model.postStream.filteredPostsCount') < 2) return true;
        return false;
    }.property('model.postStream.loaded', 'model.currentPost', 'model.postStream.filteredPostsCount'),

    hugeNumberOfPosts: function() {
        return (this.get('model.postStream.filteredPostsCount') >= Nilavu.SiteSettings.short_progress_text_threshold);
    }.property('model.highest_post_number'),

    jumpToBottomTitle: function() {
        if (this.get('hugeNumberOfPosts')) {
            return I18n.t('topic.progress.jump_bottom_with_number', { post_number: this.get('model.highest_post_number') });
        } else {
            return I18n.t('topic.progress.jump_bottom');
        }
    }.property('hugeNumberOfPosts', 'model.highest_post_number')


});
