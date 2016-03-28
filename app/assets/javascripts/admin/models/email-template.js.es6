import RestModel from 'nilavu/models/rest';
const { getProperties } = Ember;

export default RestModel.extend({
  revert() {
    return Nilavu.ajax(`/admin/customize/email_templates/${this.get('id')}`, {
      method: 'DELETE'
    }).then(result => getProperties(result.email_template, 'subject', 'body', 'can_revert'));
  }
});
