import NilavuRoute from 'nilavu/routes/nilavu';

export default function(pageName) {
  const route = {
    model() {
      console.log("static route pagename is " + pageName);
      return Nilavu.StaticPage.find(pageName);
    },

    renderTemplate() {
      this.render('static');
    },

    setupController(controller, model) {
      this.controllerFor('static').set('model', model);
    }
  };
  return NilavuRoute.extend(route);
}
