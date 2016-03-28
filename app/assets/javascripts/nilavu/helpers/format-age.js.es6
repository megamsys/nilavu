import { autoUpdatingRelativeAge } from 'nilavu/lib/formatter';
import registerUnbound from 'nilavu/helpers/register-unbound';

registerUnbound('format-age', function(dt) {
  dt = new Date(dt);
  return new Handlebars.SafeString(autoUpdatingRelativeAge(dt));
});
