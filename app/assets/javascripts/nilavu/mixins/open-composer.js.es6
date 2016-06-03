// This mixin allows a route to open the composer
import Composer from 'nilavu/models/composer';

export default Ember.Mixin.create({

  openComposer(controller) {
    return this.controllerFor('composer').open({
      action: Composer.CREATE_TOPIC
    });
  }

});
