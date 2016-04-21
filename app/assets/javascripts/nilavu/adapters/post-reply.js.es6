import RestAdapter from 'nilavu/adapters/rest';

export default RestAdapter.extend({
  find(store, type, findArgs) {
    return Nilavu.ajax(`/posts/${findArgs.postId}/replies`).then(replies => {
      return { post_replies: replies };
    });
  },
});
