import RestModel from 'nilavu/models/rest';
import { fmt } from 'nilavu/lib/computed';

export default RestModel.extend({
  detailedName: fmt('id', 'name', '%@ - %@')
});
