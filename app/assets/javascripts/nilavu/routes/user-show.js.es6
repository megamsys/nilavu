import NilavuURL from 'nilavu/lib/url';

export default Nilavu.Route.extend({
  redirect() {
      return this.redirectIfLoginRequired();
  },

  renderTemplate() {
    this.render('navigation/default', {
     outlet: 'navigation-bar'
    });

    this.render('user/show', {
      controller: 'user',
      outlet: 'list-container'
    });
  }

});
