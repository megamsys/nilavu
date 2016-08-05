import NilavuURL from 'nilavu/lib/url';
import {orgCategoryPanel} from 'nilavu/components/org-category-panel';
import {on, computed} from 'ember-addons/ember-computed-decorators';

export default orgCategoryPanel('user', {

    userName: function() {
        return this.get('model.username');
    }.property('model.username'),

    email: function() {
        return this.get('model.email');
    }.property('model.email')
});
