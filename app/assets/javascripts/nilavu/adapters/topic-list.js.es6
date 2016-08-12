import RestAdapter from 'nilavu/adapters/rest';


export function finderFor(filter, params) {
  return function() {
    let url = Nilavu.getURL("/") + filter;

    if (params) {
      const keys = Object.keys(params),
        encoded = [];

      keys.forEach(function(p) {
        const value = encodeURI(params[p]);
        if (typeof value !== 'undefined') {
          encoded.push(p + "=" + value);
        }
      });

      if (encoded.length > 0) {
        url += "?" + encoded.join('&');
      }
    }
    return Nilavu.ajax(url);
  };
}

export default RestAdapter.extend({

  find(store, type, findArgs) {
    const filter = findArgs.filter;
    const params = findArgs.params;

    return PreloadStore.getAndRemove("topic_list_" + filter, finderFor(filter, params)).then(function(result) {
      result.filter = filter;
      result.params = params;
      return result;
    });
  }
});
