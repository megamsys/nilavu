import { flushMap } from 'nilavu/models/store';
import RestModel from 'nilavu/models/rest';
import { propertyEqual } from 'nilavu/lib/computed';
import { longDate } from 'nilavu/lib/formatter';
import computed from 'ember-addons/ember-computed-decorators';

export function loadTopicView(topic, args) {
    const topicId = topic.get('id');

    const data = _.merge({}, args);

    const url = Nilavu.getURL("/t/") + topicId;

    const jsonUrl = (data.nearPost ? `${url}/${data.nearPost}` : url) + '.json';

    delete data.nearPost;
    delete data.__type;
    delete data.store;

    return PreloadStore.getAndRemove(`topic_${topicId}`, () => {
        return Nilavu.ajax(jsonUrl, { data });
    }).then(json => {
        topic.updateFromJson(json);
        return json;
    });
}

const Topic = RestModel.extend({
    message: null,
    errorLoading: false,

    postStream: function() {
        return this.store.createRecord('postStream', { id: this.get('id'), topic: this });
    }.property(),

    url: function(category) {
          let slug = this.get('slug') || '';
          if (slug.trim().length === 0) {
              slug = "topic";
          }
          return Nilavu.getURL("/t/") + (this.get('id'));
      },

      appurl: function(category) {
          let slug = this.get('slug') || '';
          if (slug.trim().length === 0) {
              slug = "topic";
          }
          return Nilavu.getURL("/t/") + (this.get('id')) + "/app";
      },


    filteredCategory: function() {
      return this.get('tosca_type').split(".")[1].replace("collaboration", "app").replace("analytics", "app");
    }.property(),

    hasOutputs: Em.computed.notEmpty('outputs'),

    filterOutputs(key) {
        if (!this.get('hasOutputs'))
            return "";
        if (!this.get('outputs').filterBy('key', key)[0])
            return "";
        return this.get('outputs').filterBy('key', key)[0].value;
    },


    // Delete this topic
    destroy(deleted_by) {
        this.setProperties({
            deleted_at: new Date(),
            deleted_by: deleted_by,
            'details.can_delete': false,
            'details.can_recover': true
        });
        return Nilavu.ajax("/t/" + this.get('id'), {
            data: { context: window.location.pathname },
            type: 'DELETE'
        });
    },

    // Recover this topic if deleted
    recover() {
        this.setProperties({
            deleted_at: null,
            deleted_by: null,
            'details.can_delete': true,
            'details.can_recover': false
        });
        return Nilavu.ajax("/t/" + this.get('id') + "/recover", { type: 'PUT' });
    },

    // Update our attributes from a JSON result
    updateFromJson(json) {
        const self = this;
        self.set('details', json);

        const keys = Object.keys(json);

        keys.forEach(key => { self.set(key, json[key]) });
    },

    reload() {
        const self = this;
        return Nilavu.ajax('/t/' + this.get('id'), { type: 'GET' }).then(function(topic_json) {
            self.updateFromJson(topic_json);
        });
    }
});

Topic.reopenClass({
    NotificationLevel: {
        WATCHING: 3,
        TRACKING: 2,
        REGULAR: 1,
        MUTED: 0
    },

    create() {
        const result = this._super.apply(this, arguments);
        return result;
    },

    // Load a topic, but accepts a set of filters
    find(topicId, opts) {
        let url = Nilavu.getURL("/t/") + topicId;
        if (opts.nearPost) {
            url += "/" + opts.nearPost;
        }

        const data = {};
        if (opts.postsAfter) {
            data.posts_after = opts.postsAfter;
        }

        // Add the summary of filter if we have it
        if (opts.summary === true) {
            data.summary = true;
        }

        // Check the preload store. If not, load it via JSON
        return Nilavu.ajax(url + ".json", { data: data });
    },

    resetNew() {
        return Nilavu.ajax("/topics/reset-new", { type: 'PUT' });
    }
});

export default Topic;
