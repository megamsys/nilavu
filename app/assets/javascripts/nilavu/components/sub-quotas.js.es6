import { on, observes, computed } from 'ember-addons/ember-computed-decorators';
import FlavorCost from 'nilavu/models/flavor_cost';

export default Ember.Component.extend({
  unitFlav: function() {
      const fc = FlavorCost.all(this.get('model.subresource'));
      if (!Ember.isEmpty(fc) && fc.length > 0) {
          const propagate = fc.objectAt(0);
          this.set('model.flavorcost', propagate);
          return propagate;
      }
      return;
  }.property('model.subresource','flavorcost'),

    fcpu: function() {
        const uf = this.get('unitFlav');
        if (!Ember.isEmpty(uf)) {
            return uf.cpu();
        }
    }.property('unitFlav.cpu'),

    ncpu: function() {
        return (this.get('fcpu') ? this.get('fcpu').replace(/[^0-9]+/g, '') : '');
    }.property('unitFlav'),

    fmemory: function() {
        const uf = this.get('unitFlav');
        if (!Ember.isEmpty(uf)) {
            return uf.memory();
        }
    }.property('unitFlav.memory'),

    nmemory: function() {
        return (this.get('fmemory') ? this.get('fmemory').replace(/[^0-9]+/g, '') : '');
    }.property('unitFlav'),

    fstorage: function() {
        const uf = this.get('unitFlav');
        if (!Ember.isEmpty(uf)) {
            return uf.storage();
        }
    }.property('unitFlav.storage'),

    nstorage: function() {
        return (this.get('fstorage') ? this.get('fstorage').replace(/[^0-9]+/g, '') : '');
    }.property('unitFlav'),

    unitChanged: function() {
        //  this.set('model.unitoption', this.get('unitFlav'));
    },

    change: function() {
        Ember.run.once(this, 'unitChanged');
    },

    we may have to do it for all others.
    _rerenderOnChange: function() {
        this.rerender();
    }.observes('nstorage')


});
