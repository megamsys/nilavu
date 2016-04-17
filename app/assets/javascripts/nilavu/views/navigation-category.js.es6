import AddCategoryClass from 'nilavu/mixins/add-category-class';

export default Ember.View.extend(AddCategoryClass, {
  categoryFullSlug: Ember.computed.alias('controller.category.fullSlug')
});
