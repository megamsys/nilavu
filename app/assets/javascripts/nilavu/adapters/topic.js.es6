import RestAdapter from 'nilavu/adapters/rest';

export default RestAdapter.extend({
  find(store, type, findArgs) {
    if (findArgs.similar) {
      return Nilavu.ajax("/topics/similar_to", { data: findArgs.similar });
    } else {
      return this._super(store, type, findArgs);
    }
  }
});
