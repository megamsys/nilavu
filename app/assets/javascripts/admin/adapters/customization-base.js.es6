import RestAdapter from 'nilavu/adapters/rest';

export default RestAdapter.extend({
  basePath() {
    return "/admin/customize/";
  }
});
