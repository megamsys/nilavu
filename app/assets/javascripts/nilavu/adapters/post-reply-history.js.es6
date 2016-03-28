import RestAdapter from 'nilavu/adapters/rest';

export default RestAdapter.extend({
  find(store, type, findArgs) {
    const maxReplies = Nilavu.SiteSettings.max_reply_history;
    return Nilavu.ajax(`/posts/${findArgs.postId}/reply-history?max_replies=${maxReplies}`).then(replies => {
      return { post_reply_histories: replies };
    });
  },
});
