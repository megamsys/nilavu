import NilavuURL from 'nilavu/lib/url';

export default {
  name: 'url-redirects',
  initialize: function() {

    // URL rewrites (usually due to refactoring)
    NilavuURL.rewrite(/^\/category\//, "/c/");
    NilavuURL.rewrite(/^\/group\//, "/groups/");
    NilavuURL.rewrite(/\/private-messages\/$/, "/messages/");
    NilavuURL.rewrite(/^\/users\/([^\/]+)\/?$/, "/users/$1/activity");
  }
};
