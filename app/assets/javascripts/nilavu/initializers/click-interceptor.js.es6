import interceptClick from 'nilavu/lib/intercept-click';
import NilavuURL from 'nilavu/lib/url';

export default {
  name: "click-interceptor",
  initialize() {
    $('#main').on('click.discourse', 'a', interceptClick);
    $(window).on('hashchange', () => NilavuURL.routeTo(document.location.hash));
  }
};
