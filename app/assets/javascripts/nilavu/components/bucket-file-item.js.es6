import { formatFileIcons, formatFileSize } from 'nilavu/helpers/file-formats';
export default Ember.Component.extend({

  sizeWithUnits: function() {
      return formatFileSize(this.model.size);
  }.property(),

  iconClass: function() {
      var nameSplit = this.get('model').key.split('.');
      return formatFileIcons(nameSplit[nameSplit.length - 1]);
  }.property('model'),

  popIcon: function() {
      return "pop_icon";
  }.property(),

});
