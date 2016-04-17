import { autoUpdatingRelativeAge } from 'nilavu/lib/formatter';

export default Ember.Handlebars.makeBoundHelper(function(dt) {
  return new Handlebars.SafeString(autoUpdatingRelativeAge(new Date(dt), {format: 'medium', title: true }));
});
