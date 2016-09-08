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
    takeSnapShotSpinner: false,
    snapshots: [],

    sortedSnapshots: Ember.computed.sort('snapshots', 'sortDefinition'),
    sortBy: 'created_at', // default sort by date
    reverseSort: true, // default sort in descending order
    sortDefinition: Ember.computed('sortBy', 'reverseSort', function() {
        let sortOrder = this.get('reverseSort') ? 'desc' : 'asc';
        return [`${this.get('sortBy')}:${sortOrder}`];
    }),

    snapshot_title: function() {
        return I18n.t("vm_management.snapshots.title");
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

    showTakeSnapshotSpinner: function() {
        return this.get("takeSnapShotSpinner");
    }.property("takeSnapShotSpinner"),

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
            // self.notificationMessages.error(I18n.t("vm_management.snapshots.list_error"));
        });
    },

    snapshotListEmpty: function() {
        if (Em.isEmpty(this.get('snapshots'))) {
            return true;
        } else {
            return false;
        }
    }.property("snapshots"),

    getData(reqAction) {
        return {
            id: this.get('model').id,
            cat_id: this.get('model').asms_id,
            name: this.get('model').name,
            req_action: reqAction,
            cattype: this.get('model').tosca_type.split(".")[1],
            category: "snapshot"
        };
    },

    actions: {

      takeSnapshot() {
          var self = this;
          this.set('takeSnapShotSpinner', true);
          Nilavu.ajax('/t/' + this.get('model').id + "/snapshot", {
              data: this.getData("disksaveas"),
              type: 'POST'
          }).then(function(result) {
              self.set('takeSnapShotSpinner', false);
              if (result.success) {
                  self.notificationMessages.success(I18n.t("vm_management.take_snapshot_success"));
              } else {
                  self.notificationMessages.error(I18n.t("vm_management.error"));
              }
          }).catch(function(e) {
              self.set('takeSnapShotSpinner', false);
              self.notificationMessages.error(I18n.t("vm_management.error"));
          });
      },

    }

});
