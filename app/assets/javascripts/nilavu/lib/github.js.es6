export function translateResults(results, opts) {

    const r = results;

    results.resultTypes = [];

    r.forEach(function(pair) {
        if (pair) {
            var result = {
                owner: pair.owner.login,
                clone_url: pair.clone_url,
                default_branch: pair.default_branch,
                private: pair.private,
                description: pair.description,
                created_at: pair.created_at,
                language: pair.language,
                updated_at: pair.updated_at
            };
            results.resultTypes.push(result);
        }
    });

    const noResults = !!(results.resultTypes.length === 0);

    if (opts) { results.token = [opts.token]; };

    return noResults ? null : Em.Object.create(results);
}

function reposForUser(opts) {
    if (!opts) opts = {};

    const session = Nilavu.Session.currentProp('external_auth_githubresult');

    if (!session) return;

    const user = session.extra_data.github_screen_name;

    const host = 'https://api.github.com';

    let headers = {};

    if (session.token) {
        headers.Authorization = `token ${session.token}`;
    }

    var promise = Nilavu.ajax(host + '/users/' + user + '/repos', { data: opts, headers: headers });

    promise.then(function(results) {
        return translateResults(results, session);
    });

    return promise;
}




export { reposForUser };
