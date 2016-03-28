import Post from 'nilavu/models/post';

export default Post.extend({

  _attachCategory: function () {
    const categoryId = this.get("category_id");
    if (categoryId) {
      this.set("category", Nilavu.Category.findById(categoryId));
    }
  }.on("init"),

  presentName: Em.computed.any('name', 'username'),

  sameUser: function() {
    return this.get("username") === Nilavu.User.currentProp("username");
  }.property("username"),

  descriptionKey: function () {
    if (this.get("reply_to_post_number")) {
      return this.get("sameUser") ? "you_replied_to_post" : "user_replied_to_post";
    } else {
      return this.get("sameUser") ? "you_replied_to_topic" : "user_replied_to_topic";
    }
  }.property("reply_to_post_number", "sameUser")

});
