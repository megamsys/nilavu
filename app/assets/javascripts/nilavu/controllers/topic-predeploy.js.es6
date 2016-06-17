import NilavuURL from 'nilavu/lib/url';
//import Clock from 'nilavu/services/clock';
import NilavuPollster from 'nilavu/lib/nilavu-pollster';
import { headerHeight } from 'nilavu/components/site-header';
import computed from "ember-addons/ember-computed-decorators";

export default Ember.Controller.extend({
    needs: ['topic'],

    loading: false,

    unreadNotification: false,
    progress: 10,

    id: Ember.computed.alias('model.id'),
    createdAt: Ember.computed.alias('model.created_at'),

    _initPoller: function() {
        this.set('notifications', []);
    }.on('init'),

    @computed('model.postStream.posts')
    postsToRender() {
      alert(this.get('model.postStream.posts'));
        return  this.get('model.postStream.posts');
            //this.get('model.postStream.postsWithPlaceholders');
    },

    // Add the new notification into the model stream
    predeployNotificationChanged: function() {
        //state.notifications.map(n => this.attach('notification-item', n));
        const self = this;
        const deployLiveFeed = this.get('notifications');

        if (Ember.isEmpty(deployLiveFeed)) {
            return };

        deployLiveFeed.forEach(feed => {
            const postStream = this.get('model.postStream');
            switch (feed.event_type) {
                case "RUNNING":
                    {
                        //      postStream.triggerChangedPost(data.id, data.updated_at).then(() => refresh({ id: data.id, refreshLikes: true }));
                        if (self.get('progress')) {
                            alert("Ah. ha! is running, stop polling, redirect after 2 s to topic-show");
                            self.appEvents.trigger('post-stream:refresh', { state: "SUCCESS" });
                        }
                        break;
                    }
                case "ERROR":
                    {
                        //    postStream.triggerChangedPost(data.id, data.updated_at).then(() => refresh({ id: data.id, refreshLikes: true }));
                        if (self.get('progress')) {
                            alert("Oooops :( error, stop polling, redirect after 2 s to /");
                            self.appEvents.trigger('post-stream:refresh', { state: "ERROR" });
                        }
                        break;
                    }
                case "LAUNCHING":
                case "LAUNCHED":
                case "BOOTSTRAPPING":
                case "BOOTSTRAPPED":
                case "STATEUP":
                case "CHEFRUNNING":
                case "COOKBOOKSUCCESS":
                case "IPUPDATED":
                case "AUTHKEYSADDED":
                case "ROUTEADDED":
                    {
                        postStream.triggerNewPostInStream(feed);
                        this.appEvents.trigger('post-stream:refresh');

                        if (self.get('progress')) {
                            console.log("ok, lets progress it " + self.get('progress'));
                            self.appEvents.trigger('post-stream:refresh', { state: "STEP" });
                        }
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

        var topicController = this;

        this.startPolling();

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
            //  alert("refreshNotifications stale\n" + JSON.stringify(results));

            this.toggleProperty('unreadNotification');
            this.set('notifications', results);
        } else {
            this.loading = true;
        }

        stale.refresh().then(notifications => {
            this.toggleProperty('unreadNotification');
            this.set('notifications', notifications);
        }).catch(() => {
            this.toggleProperty('unreadNotification');
            this.set('notifications', []);
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
    },

    actions: {
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

    // Route and close the expansion
    jumpTo(url) {
        this.set('expanded', false);
        NilavuURL.routeTo(url);
    },

    streamPercentage: function() {
        if (!this.get('model.postStream.loaded')) {
            return 0;
        }
        if (this.get('model.postStream.highest_post_number') === 0) {
            return 0;
        }
        var perc = this.get('progressPosition') / this.get('model.postStream.filteredPostsCount');
        return (perc > 1.0) ? 1.0 : perc;
    }.property('model.postStream.loaded', 'progressPosition', 'model.postStream.filteredPostsCount'),

    jumpTopDisabled: function() {
        return this.get('progressPosition') <= 3;
    }.property('progressPosition'),

    filteredPostCountChanged: function() {
        if (this.get('model.postStream.filteredPostsCount') < this.get('progressPosition')) {
            this.set('progressPosition', this.get('model.postStream.filteredPostsCount'));
        }
    }.observes('model.postStream.filteredPostsCount'),

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
