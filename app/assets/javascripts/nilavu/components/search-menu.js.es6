import {
    searchForTerm,
    searchContextDescription,
    isValidSearchTerm
} from 'nilavu/lib/search';
import NilavuURL from 'nilavu/lib/url';
import {
    default as computed,
    observes
} from 'ember-addons/ember-computed-decorators';
import showModal from 'nilavu/lib/show-modal';

let _dontSearch = false;

export default Ember.Component.extend({
    searchService: Ember.inject.service('search'),
    classNames: ['search-menu'],
    typeFilter: null,
    searchBar: true,

    searchBarVisible: function() {
        return this.get('searchBar');
    }.property('searchBar'),

    didInsertElement: function() {
        this.setSearchTerm();
    },

    @observes('searchService.searchContext')
    contextChanged: function() {
        if (this.get('searchService.searchContextEnabled')) {
            _dontSearch = true;
            this.set('searchService.searchContextEnabled', false);
            _dontSearch = false;
        }
        this.setSearchTerm();
    },

    @computed('searchService.searchContext', 'searchService.term', 'searchService.searchContextEnabled')
    fullSearchUrlRelative(searchContext, term, searchContextEnabled) {
        if (searchContextEnabled && Ember.get(searchContext, 'type') === 'topic') {
            return null;
        }

        let url = '/search?q=' + encodeURIComponent(this.get('searchService.term'));

        if (searchContextEnabled) {
            url += encodeURIComponent(" " + searchContext.type + ":" + searchContext.id);
        }
        return url;
    },

    @computed('fullSearchUrlRelative')
    fullSearchUrl(fullSearchUrlRelative) {
        if (fullSearchUrlRelative) {
            return Nilavu.getURL(fullSearchUrlRelative);
        }
    },

    @computed('searchService.searchContext')
    searchContextDescription(ctx) {
        return searchContextDescription(Em.get(ctx, 'type'), Em.get(ctx, 'user.username') || Em.get(ctx, 'category.name'));
    },

    @observes('searchService.searchContextEnabled')
    searchContextEnabledChanged() {
        if (_dontSearch) {
            return;
        }
        this.newSearchNeeded();
    },

    // If we need to perform another search
    @observes('searchService.term', 'typeFilter')
    newSearchNeeded() {
        this.set('noResults', false);
        const term = this.get('searchService.term');
        if (isValidSearchTerm(term)) {
            this.set('loading', true);
            Ember.run.debounce(this, 'searchTerm', term, this.get('typeFilter'), 400);
        } else {
            this.setProperties({
                content: null
            });
        }
        this.set('selectedIndex', 0);
    },

    setSearchTerm() {
        if (!Em.isEmpty(this.get("selectedItem"))) {
            if (!Em.isEqual(this.get('searchService.searchContext.type'), "container")) {
                this.set('searchService.term', this.get('selectedItem').flavor.toLowerCase());
                this.set('searchBar', false);
            } else {
                this.set('searchService.term', "");
                this.set('searchBar', true);
                this.setProperties({
                    content: null
                });
                this._cancelSearch = true;
                this.set('loading', false);
            }
        }
    },

    searchTerm(term, typeFilter) {
        // for cancelling debounced search
        if (this._cancelSearch) {
            this._cancelSearch = null;
            return;
        }

        if (this._search) {
            this._search.abort();
        }

        const searchContext = this.get('searchService.searchContext') ? this.get('searchService.searchContext') : null;
        this._search = searchForTerm(term, {
            typeFilter,
            searchContext,
            fullSearchUrl: this.get('fullSearchUrl')
        });
        this._search.then((content) => {
            this.setProperties({
                noResults: !content,
                content
            });
        }).finally(() => {
            this.set('loading', false);
            this._search = null;
        });
    },

    @computed('typeFilter', 'loading')
    showCancelFilter(typeFilter, loading) {
        if (loading) {
            return false;
        }
        return !Ember.isEmpty(typeFilter);
    },

    @observes('searchService.term')
    termChanged() {
        this.cancelTypeFilter();
    },

    actions: {
        fullSearch() {
            const self = this;

            if (this._search) {
                this._search.abort();
            }

            // maybe we are debounced and delayed
            // stop that as well
            this._cancelSearch = true;
            Em.run.later(function() {
                self._cancelSearch = false;
            }, 400);

            const url = this.get('fullSearchUrlRelative');
            if (url) {
                NilavuURL.routeTo(url);
            }
        },

        moreOfType(type) {
            this.set('typeFilter', type);
        },

        cancelType() {
            this.cancelTypeFilter();
        },

        showedSearch() {
            $('#search-term').focus().select();
        },

        cancelHighlight() {
            this.set('searchService.highlightTerm', null);
        }
    },

    cancelTypeFilter() {
        this.set('typeFilter', null);
    },

    keyDown(e) {
        if (e.which === 13 && isValidSearchTerm(this.get('searchService.term'))) {
            this.set('visible', false);
            this.send('fullSearch');
        }
    }
});
