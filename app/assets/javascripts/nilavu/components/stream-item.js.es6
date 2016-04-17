import { propertyEqual } from 'nilavu/lib/computed';
import { actionDescription } from "nilavu/components/small-action";

export default Ember.Component.extend({
  classNameBindings: [":item", "item.hidden", "item.deleted", "moderatorAction"],
  moderatorAction: propertyEqual("item.post_type", "site.post_types.moderator_action"),
  actionDescription: actionDescription("item.action_code", "item.created_at", "item.username"),

  actions: {
    removeBookmark(userAction) {
      this.sendAction("removeBookmark", userAction);
    }
  }
});
