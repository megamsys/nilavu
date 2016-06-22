import { propertyEqual } from 'nilavu/lib/computed';

export default Em.Component.extend({
  actions:
  {
change_name()
{
},
update()
{

}
  },
  email: function() {
      return this.get('model.email');
  }.property('model.email'),
});
