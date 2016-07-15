import NilavuURL from 'nilavu/lib/url';
import RestModel from 'nilavu/models/rest';
import PostsWithPlaceholders from 'nilavu/lib/posts-with-placeholders';
import {
    default as computed
} from 'ember-addons/ember-computed-decorators';
import { loadTopicView } from 'nilavu/models/topic';

export default RestModel.extend({
    _identityMap: null,
    posts: null,
    stream: null,
    loaded: null,
    loadingAbove: true,
    loadingBelow: null,
    loadingFilter: null,
    postsWithPlaceholders: null,

    init() {
        this._identityMap = {};
        const posts = [];
        const postsWithPlaceholders = PostsWithPlaceholders.create({ posts, store: this.store });

        this.setProperties({
            posts,
            postsWithPlaceholders,
            stream: [],
            userFilters: [],
            summary: false,
            loaded: false,
            loadingAbove: true,
            loadingBelow: false,
            loadingFilter: false,
            stagingPost: false,
        });
    },

    loading: Ember.computed.or('loadingAbove', 'loadingBelow', 'loadingFilter', 'stagingPost'),
    notLoading: Ember.computed.not('loading'),
    filteredPostsCount: Ember.computed.alias("stream.length"),

    @computed('posts.[]')
    hasPosts() {
        return this.get('posts.length') > 0;
    },

    @computed('hasPosts', 'filteredPostsCount')
    hasLoadedData(hasPosts, filteredPostsCount) {
        return filteredPostsCount > 0;
    },

    canAppendMore: Ember.computed.and('notLoading', 'hasPosts', 'lastPostNotLoaded'),
    canPrependMore: Ember.computed.and('notLoading', 'hasPosts', 'firstPostNotLoaded'),

    @computed('hasLoadedData', 'firstPostId', 'posts.[]')
    firstPostPresent(hasLoadedData, firstPostId) {
        if (!hasLoadedData) {
            return false;
        }
        return !!this.get('posts').findProperty('id', firstPostId);
    },

    firstPostNotLoaded: Ember.computed.not('firstPostPresent'),
    firstPostId: Ember.computed.alias('stream.firstObject'),
    lastPostId: Ember.computed.alias('stream.lastObject'),

    @computed('hasLoadedData', 'lastPostId', 'posts.@each.id')
    loadedAllPosts(hasLoadedData, lastPostId) {
        if (!hasLoadedData) {
            return false;
        }
        if (lastPostId === -1) {
            return true;
        }
        return true;
        //return !!this.get('posts').findProperty('id', lastPostId);
    },

    lastPostNotLoaded: Ember.computed.not('loadedAllPosts'),

    /**
      Returns a JS Object of current stream filter options. It should match the query
      params for the stream.
    **/
    @computed('summary', 'show_deleted', 'userFilters.[]')
    streamFilters(summary, showDeleted) {
        const result = {};
        if (summary) { result.filter = "summary"; }
        if (showDeleted) { result.show_deleted = true; }

        const userFilters = this.get('userFilters');
        if (!Ember.isEmpty(userFilters)) {
            result.username_filters = userFilters.join(",");
        }

        return result;
    },

    @computed('streamFilters.[]', 'topic.posts_count', 'posts.length')
    hasNoFilters() {
        const streamFilters = this.get('streamFilters');
        return !(streamFilters && ((streamFilters.filter === 'summary') || streamFilters.username_filters));
    },

    /**
      Returns the window of posts above the current set in the stream, bound to the top of the stream.
      This is the collection we'll ask for when scrolling upwards.
    **/
    @computed('posts.[]', 'stream.[]')
    previousWindow() {
        // If we can't find the last post loaded, bail
        const firstPost = _.first(this.get('posts'));
        if (!firstPost) {
            return [];
        }

        // Find the index of the last post loaded, if not found, bail
        const stream = this.get('stream');
        const firstIndex = this.indexOf(firstPost);
        if (firstIndex === -1) {
            return [];
        }

        let startIndex = firstIndex - this.get('topic.chunk_size');
        if (startIndex < 0) { startIndex = 0; }
        return stream.slice(startIndex, firstIndex);
    },

    /**
      Returns the window of posts below the current set in the stream, bound by the bottom of the
      stream. This is the collection we use when scrolling downwards.
    **/
    @computed('posts.lastObject', 'stream.[]')
    nextWindow(lastLoadedPost) {
        // If we can't find the last post loaded, bail
        if (!lastLoadedPost) {
            return [];
        }

        // Find the index of the last post loaded, if not found, bail
        const stream = this.get('stream');
        const lastIndex = this.indexOf(lastLoadedPost);
        if (lastIndex === -1) {
            return [];
        }
        if ((lastIndex + 1) >= this.get('highest_post_number')) {
            return [];
        }

        // find our window of posts
        return stream.slice(lastIndex + 1, lastIndex + this.get('topic.chunk_size') + 1);
    },

    cancelFilter() {
        this.set('summary', false);
        this.set('show_deleted', false);
        this.get('userFilters').clear();
    },

    toggleDeleted() {
        this.toggleProperty('show_deleted');
        //  return this.refresh();
    },

    jumpToSecondVisible() {
        const posts = this.get('posts');
        if (posts.length > 1) {
            const secondPostNum = posts[1].get('post_number');
            NilavuURL.jumpToPost(secondPostNum);
        }
    },


    collapsePosts(from, to) {
        const posts = this.get('posts');
        const remove = posts.filter(post => {
            const postNumber = post.get('post_number');
            return postNumber >= from && postNumber <= to;
        });

        posts.removeObjects(remove);

        // make gap
        this.set('gaps', this.get('gaps') || { before: {}, after: {} });
        const before = this.get('gaps.before');
        const post = posts.find(p => p.get('post_number') > to);

        before[post.get('id')] = remove.map(p => p.get('id'));
        post.set('hasGap', true);

        this.get('stream').enumerableContentDidChange();
    },

    // Appends the next window of posts to the stream. Call it when scrolling downwards.
    appendMore() {
        // Make sure we can append more posts
        if (!this.get('canAppendMore')) {
            return Ember.RSVP.resolve();
        }

        const postIds = this.get('nextWindow');
        if (Ember.isEmpty(postIds)) {
            return Ember.RSVP.resolve();
        }

        this.set('loadingBelow', true);
        const postsWithPlaceholders = this.get('postsWithPlaceholders');
        postsWithPlaceholders.appending(postIds);
        return this.findPostsByIds(postIds).then(posts => {
            posts.forEach(p => this.appendPost(p));
            return posts;
        }).finally(() => {
            postsWithPlaceholders.finishedAppending(postIds);
            this.set('loadingBelow', false);
        });
    },

    // Prepend the previous window of posts to the stream. Call it when scrolling upwards.
    prependMore() {
        // Make sure we can append more posts
        if (!this.get('canPrependMore')) {
            return Ember.RSVP.resolve();
        }

        const postIds = this.get('previousWindow');
        if (Ember.isEmpty(postIds)) {
            return Ember.RSVP.resolve();
        }

        this.set('loadingAbove', true);
        return this.findPostsByIds(postIds.reverse()).then(posts => {
            posts.forEach(p => this.prependPost(p));
        }).finally(() => {
            const postsWithPlaceholders = this.get('postsWithPlaceholders');
            postsWithPlaceholders.finishedPrepending(postIds);
            this.set('loadingAbove', false);
        });
    },


    prependPost(post) {
        const stored = this.storePost(post);
        if (stored) {
            const posts = this.get('posts');
            posts.unshiftObject(stored);
        }

        return post;
    },

    appendPost(post) {
        const stored = this.storePost(post);
        if (stored) {
            const posts = this.get('posts');
            if (!posts.contains(stored)) {
                posts.pushObject(stored);
            }
            if (stored.get('id') !== -1) {
                this.set('lastAppended', stored);
            }
        }
        return post;
    },


    // Returns a post from the identity map if it's been inserted.
    findLoadedPost(id) {
        return this._identityMap[id];
    },

    loadPost(postId) {
        const url = "/posts/" + postId;
        const store = this.store;

        return Discourse.ajax(url).then(p => this.storePost(store.createRecord('post', p)));
    },

    /**
      Finds and adds a post to the stream by id. Typically this would happen if we receive a message
      from the message bus indicating there's a new post. We'll only insert it if we currently
      have no filters.
    **/
    triggerNewPostInStream(postData) {
        const resolved = Ember.RSVP.Promise.resolve();
        const postId = postData.id;
        if (!postId) {
            return resolved;
        }
        const loadedAllPosts = this.get('loadedAllPosts');

        if (this.get('stream').indexOf(postId) === -1) {
            this.get('stream').addObject(postId);
            if (loadedAllPosts) {
                this.set('loadingLastPost', true);
                return this.findPostsByIds([postData]).then(posts => {
                    posts.forEach((p) => this.appendPost(p));
                }).finally(() => {
                    this.set('loadingLastPost', false);
                });
            }
        }
        return resolved;
    },

    triggerRecoveredPost(postId) {
        const existing = this._identityMap[postId];

        if (existing) {
            return this.triggerChangedPost(postId, new Date());
        } else {
            // need to insert into stream
            const url = "/posts/" + postId;
            const store = this.store;
            return Discourse.ajax(url).then(p => {
                const post = store.createRecord('post', p);
                const stream = this.get("stream");
                const posts = this.get("posts");
                this.storePost(post);

                // we need to zip this into the stream
                let index = 0;
                stream.forEach(pid => {
                    if (pid < p.id) {
                        index += 1;
                    }
                });

                stream.insertAt(index, p.id);

                index = 0;
                posts.forEach(_post => {
                    if (_post.id < p.id) {
                        index += 1;
                    }
                });

                if (index < posts.length) {
                    posts.insertAt(index, post);
                } else {
                    if (post.post_number < posts[posts.length - 1].post_number + 5) {
                        this.appendMore();
                    }
                }
            });
        }
    },

    triggerDeletedPost(postId) {
        const existing = this._identityMap[postId];

        if (existing) {
            const url = "/posts/" + postId;
            const store = this.store;

            return Discourse.ajax(url).then(p => {
                this.storePost(store.createRecord('post', p));
            }).catch(() => {
                this.removePosts([existing]);
            });
        }
        return Ember.RSVP.Promise.resolve();
    },

    triggerChangedPost(postId, updatedAt) {
        const resolved = Ember.RSVP.Promise.resolve();
        if (!postId) {
            return resolved;
        }

        const existing = this._identityMap[postId];
        if (existing && existing.updated_at !== updatedAt) {
            const url = "/posts/" + postId;
            const store = this.store;
            return Discourse.ajax(url).then(p => this.storePost(store.createRecord('post', p)));
        }
        return resolved;
    },

    /**
      Returns the closest post given a postNumber that may not exist in the stream.
      For example, if the user asks for a post that's deleted or otherwise outside the range.
      This allows us to set the progress bar with the correct number.
    **/
    closestPostForPostNumber(postNumber) {
        if (!this.get('hasPosts')) {
            return;
        }

        let closest = null;
        this.get('posts').forEach(p => {
            if (!closest) {
                closest = p;
                return;
            }

            if (Math.abs(postNumber - p.get('post_number')) < Math.abs(closest.get('post_number') - postNumber)) {
                closest = p;
            }
        });

        return closest;
    },

    // Get the index of a post in the stream. (Use this for the topic progress bar.)
    progressIndexOfPost(post) {
        return this.progressIndexOfPostId(post.get('id'));
    },

    // Get the index in the stream of a post id. (Use this for the topic progress bar.)
    progressIndexOfPostId(postId) {
        return this.get('stream').indexOf(postId) + 1;
    },

    /**
      Returns the closest post number given a postNumber that may not exist in the stream.
      For example, if the user asks for a post that's deleted or otherwise outside the range.
      This allows us to set the progress bar with the correct number.
    **/
    closestPostNumberFor(postNumber) {
        if (!this.get('hasPosts')) {
            return;
        }

        let closest = null;
        this.get('posts').forEach(p => {
            if (closest === postNumber) {
                return;
            }
            if (!closest) { closest = p.get('post_number'); }

            if (Math.abs(postNumber - p.get('post_number')) < Math.abs(closest - postNumber)) {
                closest = p.get('post_number');
            }
        });

        return closest;
    },

    // Find a postId for a postNumber, respecting gaps
    findPostIdForPostNumber(postNumber) {
        const stream = this.get('stream'),
            beforeLookup = this.get('gaps.before'),
            streamLength = stream.length;

        let sum = 1;
        for (let i = 0; i < streamLength; i++) {
            const pid = stream[i];

            // See if there are posts before this post
            if (beforeLookup) {
                const before = beforeLookup[pid];
                if (before) {
                    for (let j = 0; j < before.length; j++) {
                        if (sum === postNumber) {
                            return pid;
                        }
                        sum++;
                    }
                }
            }

            if (sum === postNumber) {
                return pid;
            }
            sum++;
        }
    },

    updateFromJson(postStreamData) {
        const posts = this.get('posts');

        const postsWithPlaceholders = this.get('postsWithPlaceholders');
        postsWithPlaceholders.clear(() => posts.clear());

        this.set('gaps', null);
        if (postStreamData) {
            // Load posts if present
            const store = this.store;
            postStreamData.posts.forEach(p => this.appendPost(store.createRecord('post', p)));
            delete postStreamData.posts;

            // Update our attributes
            this.setProperties(postStreamData);
        }
    },

    /**
      Stores a post in our identity map, and sets up the references it needs to
      find associated objects like the topic. It might return a different reference
      than you supplied if the post has already been loaded.
    **/
    storePost(post) {
        // Calling `Ember.get(undefined)` raises an error
        if (!post) {
            return; }

        const postId = post.id;
        if (postId) {
            const existing = this._identityMap[post.get('id')];
            // Update the `highest_post_number` if this post is higher.
            /*const postNumber = post.get('post_number');
            if (postNumber && postNumber > (this.get('topic.highest_post_number') || 0)) {
                this.set('topic.highest_post_number', postNumber);
            }*/

            if (existing) {
                // If the post is in the identity map, update it and return the old reference.
                //existing.updateFromPost(post);
                return existing;
            }
            //post.set('topic', this.get('topic'));
            this._identityMap[post.get('id')] = post;
        }
        return post;
    },

    findPostsByIds(postDatas) {
        const identityMap = this._identityMap;
        const unloaded = postDatas.filter(p => !identityMap[p.id]);
        // Load our unloaded posts by id
        return this.loadIntoIdentityMap(unloaded).then(() => {
            return postDatas;
        });
    },

    loadIntoIdentityMap(postDatas) {
        const self = this;
        if (Ember.isEmpty(postDatas)) {
            return Ember.RSVP.resolve([]);
        }
        return new Ember.RSVP.Promise(function(resolve, reject) {
            postDatas.forEach(p => self.storePost(p));
            resolve();
        });
    },

    indexOf(post) {
        return this.get('stream').indexOf(post.get('id'));
    },

    // Handles an error loading a topic based on a HTTP status code. Updates
    // the text to the correct values.
    errorLoading(result) {
        const status = result.jqXHR.status;

        const topic = this.get('topic');
        this.set('loadingFilter', false);
        topic.set('errorLoading', true);

        // If the result was 404 the post is not found
        // If it was 410 the post is deleted and the user should not see it
        if (status === 404 || status === 410) {
            topic.set('notFoundHtml', result.jqXHR.responseText);
            return;
        }

        // If the result is 403 it means invalid access
        if (status === 403) {
            topic.set('noRetry', true);
            if (Discourse.User.current()) {
                topic.set('message', I18n.t('topic.invalid_access.description'));
            } else {
                topic.set('message', I18n.t('topic.invalid_access.login_required'));
            }
            return;
        }

        // Otherwise supply a generic error message
        topic.set('message', I18n.t('topic.server_error.description'));
    }
});
