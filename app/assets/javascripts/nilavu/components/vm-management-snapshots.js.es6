import NilavuURL from 'nilavu/lib/url';
import {
    buildCategoryPanel
} from 'nilavu/components/edit-category-panel';
import computed from 'ember-addons/ember-computed-decorators';
import {
    observes
} from 'ember-addons/ember-computed-decorators';
export default buildCategoryPanel('snapshots', {

    showSnapshotSpinnerVisible: false,
    snapshots: [],

    sortedSnapshots: Ember.computed.sort('snapshots', 'sortDefinition'),
    sortBy: 'created_at', // default sort by date
    reverseSort: true, // default sort in descending order
    sortDefinition: Ember.computed('sortBy', 'reverseSort', function() {
        let sortOrder = this.get('reverseSort') ? 'desc' : 'asc';
        return [`${this.get('sortBy')}:${sortOrder}`];
    }),

    snapshot_title: function() {
        return I18n.t("vm_management.snapshots.tab_title");
    }.property(),

    snapshot_description: function() {
        return I18n.t("vm_management.snapshots.description");
    }.property(),

    snapshot_list_title: function() {
        return I18n.t("vm_management.snapshots.list_title");
    }.property(),

    content_id: function() {
        return I18n.t("vm_management.snapshots.content_id");
    }.property(),

    content_name: function() {
        return I18n.t("vm_management.snapshots.content_name");
    }.property(),

    content_created_at: function() {
        return I18n.t("vm_management.snapshots.content_created_at");
    }.property(),

    emptySnapshots: function() {
        return I18n.t("vm_management.snapshots.content_empty");
    }.property(),

    showSpinner: function() {
        return this.get("showSnapshotSpinnerVisible");
    }.property("showSnapshotSpinnerVisible"),

    @observes('selectedTab')
    tabChanged() {
        if (Ember.isEqual(this.get('selectedTab'), "snapshots")) {
            this.getSnapshots();
        };
    },

    getSnapshots: function() {
        var self = this;
        this.set("showSnapshotSpinnerVisible", true);
        Nilavu.ajax("/t/" + this.get('model').id + "/snapshots", {
            type: 'GET'
        }).then(function(result) {
            self.set("showSnapshotSpinnerVisible", false);
            if (result.success) {
                self.set('snapshots', result.message)
            } else {
                self.notificationMessages.error(result.message);
            }
        }).catch(function(e) {
            self.set("showSnapshotSpinnerVisible", false);
            self.notificationMessages.error(I18n.t("vm_management.snapshots.list_error"));
        });
    },

    snapshotListEmpty: function() {
      if (Em.isEmpty(this.get('snapshots'))) {
        return true;
      } else {
        return false;
      }
    }.property("snapshots"),

});
