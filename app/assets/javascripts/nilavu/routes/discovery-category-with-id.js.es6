import Category from 'nilavu/models/category';

export default Nilavu.DiscoveryCategoryRoute.extend({
  model(params) {
    return { category: Category.findById(params.id) };
  }
});
