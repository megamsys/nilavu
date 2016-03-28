import loadScript from 'nilavu/lib/load-script';
import NilavuRoute from 'nilavu/routes/nilavu';

export default NilavuRoute.extend({

  // this route requires the sanitizer
  beforeModel() {
    loadScript('defer/html-sanitizer-bundle');
  },

  model() {
    return this.store.find('queuedPost', {status: 'new'});
  },

  actions: {
    refresh() {
      this.modelFor('queued-posts').refresh();
    }
  }
});
