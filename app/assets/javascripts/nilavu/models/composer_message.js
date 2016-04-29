/**
  Represents a pop up message displayed over the composer

  @class ComposerMessage
  @extends Ember.Object
  @namespace Nilavu
  @module Nilavu
**/
Nilavu.ComposerMessage = Em.Object.extend({});

Nilavu.ComposerMessage.reopenClass({
  /**
    Look for composer messages given the current composing settings.

    @method find
    @param {Nilavu.Composer} composer The current composer
    @returns {Nilavu.ComposerMessage} the composer message to display (or null)
  **/
  find: function(composer) {

    var data = { composerAction: composer.get('action') },
        topicId = composer.get('topic.id'),
        postId = composer.get('post.id');

    if (topicId) { data.topic_id = topicId; }
    if (postId)  { data.post_id = postId; }
    alert('find ');
    return Nilavu.ajax('/launchables.json', { data: data }).then(function (messages) {
      //return messages.regions.map(function (message) {
        return Nilavu.ComposerMessage.create(messages);
    //  });
    });
  }

});
