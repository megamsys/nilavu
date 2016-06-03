import Ember from 'ember';

export default Ember.Service.extend({
  googlePackages: ['corechart', 'bar', 'line', 'scatter'],
  language: 'en',

  _callbacksAddedWhileLoading: [],
  _loadComplete: false,
  _loadInProgress: false,

  loadPackages() {
    return new Ember.RSVP.Promise((resolve, reject) => {
      const { google } = window;
      const wasPreviouslyLoadedInTestSuite = google && google.visualization;

      if (this.get('_loadComplete') || wasPreviouslyLoadedInTestSuite) {

        /* If Google charts has been loaded, new calls
        to loadPackages can be resolved immediately */

        resolve();
      } else if (this.get('_loadInProgress')) {

        /* If this promise is created whilst google charts
        is being loaded, we can't resolve until it is loaded.
        Thus, we keep track of the resolve callbacks passed. */

        this.get('_callbacksAddedWhileLoading').push([resolve, reject]);
      } else {
        this.set('_loadInProgress', true);

        google.charts.load('current', {
          language: this.get('language'),
          packages: this.get('googlePackages'),

          callback: () => {

            /* Check for a corner case where the service has
            been destroyed before the charts are finished
            loading. If we set a property on a destroyed
            service, Ember throws an error. */

            if (this.isDestroying || this.isDestroyed) {
              reject();

              this.get('_callbacksAddedWhileLoading').forEach((resolveCallback) => {
                resolveCallback[1]();
              });

              return;
            }

            /* Once Google Charts has been loaded, mark the
            library as loaded and call all resolve callbacks
            passed to this promise before the Google Charts
            library had completed loading */

            this.set('_loadComplete', true);

            resolve();

            this.get('_callbacksAddedWhileLoading').forEach((resolveCallback) => {
              resolveCallback[0]();
            });
          },

        });
      }
    });
  },

});
