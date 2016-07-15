
export function translateResults(results, opts) {

  if (!opts) opts = {};

  const r = results.grouped_search_result;

  results.resultTypes = [];

  r.forEach(function(pair){
    if (pair.provider.length > 0) {
      var result = {
        results: pair,
        componentName: "search-result-" + ((opts.searchContext && opts.searchContext.type) ? opts.searchContext.type : 'none')
      };
      results.resultTypes.push(result);
    }
  });

  const noResults = !!(results.resultTypes.length === 0);
  return noResults ? null : Em.Object.create(results);
}

function searchForTerm(term, opts) {
  if (!opts) opts = {};
  // Only include the data we have
  const data = { term: term, include_blurbs: 'true' };
  if (opts.typeFilter) data.type_filter = opts.typeFilter;
  if (opts.searchForId) data.search_for_id = true;

  if (opts.searchContext) {
    data.search_context = {
      type: opts.searchContext.type,
      id: opts.searchContext.id
    };

  }

  var promise = Nilavu.ajax('/search/query', { data: data });

  promise.then(function(results){
    return translateResults(results, opts);
  });

  return promise;
}

const searchContextDescription = function(type, name){
  if (type) {
    switch(type) {
      case 'topic':
        return I18n.t('search.context.topic');
      case 'user':
        return I18n.t('search.context.user', {username: name});
      case 'category':
        return I18n.t('search.context.category', {category: name});
      case 'private_messages':
        return I18n.t('search.context.private_messages');
    }
  }
};

const getSearchKey = function(args){
  return args.q + "|" + ((args.searchContext && args.searchContext.type) || "") + "|" +
                      ((args.searchContext && args.searchContext.id) || "");
};

const isValidSearchTerm = function(searchTerm) {
  if (searchTerm) {
    return searchTerm.trim().length >= Nilavu.SiteSettings.min_search_term_length;
  } else {
    return false;
  }
};

export { searchForTerm, searchContextDescription, getSearchKey, isValidSearchTerm };
