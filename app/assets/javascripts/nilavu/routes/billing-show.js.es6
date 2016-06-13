import NilavuURL from 'nilavu/lib/url';
import Billing from 'nilavu/models/billing';

export default Nilavu.Route.extend({
   redirect() { return this.redirectIfLoginRequired(); },

    model(params) { return params; },

    setupController(controller, params) {
      params = params || {};
      const self = this,
            billing = this.modelFor('billing'),
            billController = this.controllerFor('billing');
      params.forceLoad = true;

      //TO-DO VINO: ADD error handling here to show the error.
      const promise =  Billing.find().then(function(result) {
            billController.setProperties({ model: result });
            alert(JSON.stringify(result));
          //  self.set('loading', false);
      }).catch(function(e) {
        alert("VINO HANDLE ERR (check edit-category)\n"+ e);
        //self.set('loading', false);
      });

      self.controllerFor('navigation/default').set('filterMode', "top");
    },

    renderTemplate() {
      this.render('navigation/default', {
       outlet: 'navigation-bar'
      });

      this.render('billing/show', {
        controller: 'billing',
        outlet: 'list-container'
      });
    }
});
