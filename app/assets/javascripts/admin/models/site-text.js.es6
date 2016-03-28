import RestModel from 'nilavu/models/rest';
const { getProperties } = Ember;

export default RestModel.extend({
  revert() {
    return Nilavu.ajax(`/admin/customize/site_texts/${this.get('id')}`, {
      method: 'DELETE'
    }).then(result => getProperties(result.site_text, 'value', 'can_revert'));
  }
});
