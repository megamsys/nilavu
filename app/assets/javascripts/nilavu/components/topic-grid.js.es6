import NilavuURL from 'nilavu/lib/url';
export default Ember.Component.extend({
    classNames: ['topic-grid'],
    showTopicPostBadges: true,
    showMoreButton: false,

    sortedTopics: Ember.computed.sort('filteredTopics', 'sortDefinition'),
    sortBy: 'created_at', // default sort by date
    reverseSort: true, // default sort in descending order
    sortDefinition: Ember.computed('sortBy', 'reverseSort', function() {
        let sortOrder = this.get('reverseSort')
            ? 'desc'
            : 'asc';
        return [`${this.get('sortBy')}:${sortOrder}`];
    }),

    limitedTopics: function() {
        if (this.get('expandAllPinned')) {
            return this.get('sortedTopics')
        } else {
            return this.get('sortedTopics').slice(0, 4);
        }
    }.property('sortedTopics'),

    overLimitTopics: function() {
        return this.get('sortedTopics').length > 4 && this.get('visibleShowMore');
    }.property('sortedTopics'),

    _observeHideCategory: function() {
        this.addObserver('hideCategory', this.rerender);
        this.addObserver('order', this.rerender);
        this.addObserver('ascending', this.rerender);
    }.on('init'),

    toggleInTitle: function() {
        return !this.get('bulkSelectEnabled') && this.get('canBulkSelect');
    }.property('bulkSelectEnabled'),

    sortable: function() {
        return !!this.get('changeSort');
    }.property(),

    skipHeader: function() {
        return this.site.mobileView;
    }.property(),

    showLikes: function() {
        return this.get('order') === "likes";
    }.property('order'),

    showOpLikes: function() {
        return this.get('order') === "op_likes";
    }.property('order'),

    filteredTopics: function() {
        const cat = this.get('showCategory');
        return this.get('topics').filter(function(topic) {
            return Ember.isEqual(topic.get('filteredCategory'), cat);
        });
    }.property(),

    click(e) {
        var self = this;
        var on = function(sel, callback) {
            var target = $(e.target).closest(sel);

            if (target.length === 1) {
                callback.apply(self, [target]);
            }
        };

        on('button.bulk-select', function() {
            this.sendAction('toggleBulkSelect');
            this.rerender();
        });

        on('th.sortable', function(e2) {
            this.sendAction('changeSort', e2.data('sort-order'));
            this.rerender();
        });
    },

    actions: {
        showMore: function(category) {
            NilavuURL.routeTo('/' + category);
        }

    }
});
