import { propertyEqual } from 'nilavu/lib/computed';
import RestModel from 'nilavu/models/rest';

export default RestModel.extend({
  hasOptions: Em.computed.gt('options.length', 0),
  isDefault: propertyEqual('id', 'site.default_archetype'),
  notDefault: Em.computed.not('isDefault')
});
