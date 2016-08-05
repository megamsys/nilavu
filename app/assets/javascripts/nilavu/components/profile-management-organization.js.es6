import NilavuURL from 'nilavu/lib/url';
import {buildCategoryPanel} from 'nilavu/components/edit-category-panel';
import computed from 'ember-addons/ember-computed-decorators';

export default buildCategoryPanel('organization', {
    orgSelectedTab: null,
    orgPanels: null,

    _initPanels: function() {
        this.set('orgPanels', []);
        this.set('orgSelectedTab', 'user');
    }.on('init'),

    userSelected: function() {
        return this.orgSelectedTab == 'user';
    }.property('orgSelectedTab'),

    domainSelected: function() {
        return this.orgSelectedTab == 'domain';
    }.property('orgSelectedTab'),

    domainData: function() {
        var rval = [];
        _.each(this.get("model.details"), function(p) {
            rval.addObject({name: p, value: p});
        });
        return rval;
    }.property("model.details"),

    selectDomain: function() {
        return this.get('domainData.firstObject');
    }.property('domainData')
});
