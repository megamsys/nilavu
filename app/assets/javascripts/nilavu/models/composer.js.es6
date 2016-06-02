import RestModel from 'nilavu/models/rest';
import Topic from 'nilavu/models/topic';
import { throwAjaxError } from 'nilavu/lib/ajax-error';
import computed from 'ember-addons/ember-computed-decorators';

const CLOSED = 'closed',
      SAVING = 'saving',
      OPEN = 'open',
      DRAFT = 'draft',

      // The actions the composer can take
      CREATE_TOPIC = 'createTopic',
      PRIVATE_MESSAGE = 'privateMessage',
      REPLY = 'reply',
      EDIT = 'edit',
      REPLY_AS_NEW_TOPIC_KEY = "reply_as_new_topic",

      // When creating, these fields are moved into the post model from the composer model
      _create_serializer = {
        raw: 'reply',
        title: 'title',
        category: 'categoryId',
        topic_id: 'topic.id',
        is_warning: 'isWarning',
        whisper: 'whisper',
        archetype: 'archetypeId',
        target_usernames: 'targetUsernames',
        typing_duration_msecs: 'typingTime',
        composer_open_duration_msecs: 'composerTime'
      },

      _edit_topic_serializer = {
        title: 'topic.title',
        categoryId: 'topic.category.id'
      };

const Composer = RestModel.extend({

  creatingTopic: Em.computed.equal('action', CREATE_TOPIC),
  creatingPrivateMessage: Em.computed.equal('action', PRIVATE_MESSAGE),
  notCreatingPrivateMessage: Em.computed.not('creatingPrivateMessage'),

  topicFirstPost: Em.computed.or('creatingTopic', 'editingFirstPost'),

  editingPost: Em.computed.equal('action', EDIT),
  replyingToTopic: Em.computed.equal('action', REPLY),

  viewOpen: Em.computed.equal('composeState', OPEN),
  viewDraft: Em.computed.equal('composeState', DRAFT),


  composeStateChanged: function() {
    var oldOpen = this.get('composerOpened');

    if (this.get('composeState') === OPEN) {
      this.set('composerOpened', oldOpen || new Date());
    } else {
      if (oldOpen) {
        var oldTotal = this.get('composerTotalOpened') || 0;
        this.set('composerTotalOpened', oldTotal + (new Date() - oldOpen));
      }
      this.set('composerOpened', null);
    }
  }.observes('composeState'),

  // view detected user is typing
  typing: _.throttle(function(){
    var typingTime = this.get("typingTime") || 0;
    this.set("typingTime", typingTime + 100);
  }, 100, {leading: false, trailing: true}),

  editingFirstPost: Em.computed.and('editingPost', 'post.firstPost'),
  canEditTitle: Em.computed.or('creatingTopic', 'creatingPrivateMessage', 'editingFirstPost'),
  canCategorize: Em.computed.and('canEditTitle', 'notCreatingPrivateMessage'),

  // Determine the appropriate title for this action
  actionTitle: function() {
    const topic = this.get('topic');

    let postLink, topicLink, usernameLink;
    if (topic) {
      const postNumber = this.get('post.post_number');
      postLink = "<a href='" + (topic.get('url')) + "/" + postNumber + "'>" +
        I18n.t("post.post_number", { number: postNumber }) + "</a>";
      topicLink = "<a href='" + (topic.get('url')) + "'> " + Nilavu.Utilities.escapeExpression(topic.get('title')) + "</a>";
      usernameLink = "<a href='" + (topic.get('url')) + "/" + postNumber + "'>" + this.get('post.username') + "</a>";
    }

    let postDescription;
    const post = this.get('post');

    if (post) {
      postDescription = I18n.t('post.' +  this.get('action'), {
        link: postLink,
        replyAvatar: Nilavu.Utilities.tinyAvatar(post.get('avatar_template')),
        username: this.get('post.username'),
        usernameLink
      });

      if (!this.site.mobileView) {
        const replyUsername = post.get('reply_to_user.username');
        const replyAvatarTemplate = post.get('reply_to_user.avatar_template');
        if (replyUsername && replyAvatarTemplate && this.get('action') === EDIT) {
          postDescription += " <i class='fa fa-mail-forward reply-to-glyph'></i> " + Nilavu.Utilities.tinyAvatar(replyAvatarTemplate) + " " + replyUsername;
        }
      }
    }

    switch (this.get('action')) {
      case PRIVATE_MESSAGE: return I18n.t('topic.private_message');
      case CREATE_TOPIC: return I18n.t('topic.create_long');
      case REPLY:
      case EDIT:
        if (postDescription) return postDescription;
        if (topic) return I18n.t('post.reply_topic', { link: topicLink });
    }

  }.property('action', 'post', 'topic', 'topic.title'),


  // whether to disable the post button
  cantSubmitPost: function() {

    // can't submit while loading
    if (this.get('loading')) return true;

    // title is required when
    //  - creating a new topic/private message
    //  - editing the 1st post
    if (this.get('canEditTitle') && !this.get('titleLengthValid')) return true;

    // reply is always required
    if (this.get('missingReplyCharacters') > 0) return true;

    if (this.get("privateMessage")) {
      // need at least one user when sending a PM
      return this.get('targetUsernames') && (this.get('targetUsernames').trim() + ',').indexOf(',') === 0;
    } else {
      // has a category? (when needed)
      return this.get('canCategorize') &&
            !this.siteSettings.allow_uncategorized_topics &&
            !this.get('categoryId') &&
            !this.user.get('admin');
    }
  }.property('loading', 'canEditTitle', 'titleLength', 'targetUsernames', 'replyLength', 'categoryId', 'missingReplyCharacters'),

  titleLengthValid: function() {
    if (this.user.get('admin') && this.get('post.static_doc') && this.get('titleLength') > 0) return true;
    if (this.get('titleLength') < this.get('minimumTitleLength')) return false;
    return (this.get('titleLength') <= this.siteSettings.max_topic_title_length);
  }.property('minimumTitleLength', 'titleLength', 'post.static_doc'),

  // The icon for the save button
  saveIcon: function () {
    switch (this.get('action')) {
      case EDIT: return '<i class="fa fa-pencil"></i>';
      case REPLY: return '<i class="fa fa-reply"></i>';
      case CREATE_TOPIC: return '<i class="fa fa-plus"></i>';
      case PRIVATE_MESSAGE: return '<i class="fa fa-envelope"></i>';
    }
  }.property('action'),

  // The text for the save button
  saveText: function() {
    switch (this.get('action')) {
      case EDIT: return I18n.t('composer.save_edit');
      case REPLY: return I18n.t('composer.reply');
      case CREATE_TOPIC: return I18n.t('composer.create_topic');
      case PRIVATE_MESSAGE: return I18n.t('composer.create_pm');
    }
  }.property('action'),

  hasMetaData: function() {
    const metaData = this.get('metaData');
    return metaData ? Em.isEmpty(Em.keys(this.get('metaData'))) : false;
  }.property('metaData'),

  /**
    Did the user make changes to the reply?

    @property replyDirty
  **/
  replyDirty: function() {
    return this.get('reply') !== this.get('originalText');
  }.property('reply', 'originalText'),

  /**
    Number of missing characters in the title until valid.

    @property missingTitleCharacters
  **/
  missingTitleCharacters: function() {
    return this.get('minimumTitleLength') - this.get('titleLength');
  }.property('minimumTitleLength', 'titleLength'),

  /**
    Minimum number of characters for a title to be valid.

    @property minimumTitleLength
  **/
  minimumTitleLength: function() {
    if (this.get('privateMessage')) {
      return this.siteSettings.min_private_message_title_length;
    } else {
      return this.siteSettings.min_topic_title_length;
    }
  }.property('privateMessage'),

  missingReplyCharacters: function() {
    const postType = this.get('post.post_type');
    if (postType === this.site.get('post_types.small_action')) { return 0; }
    return this.get('minimumPostLength') - this.get('replyLength');
  }.property('minimumPostLength', 'replyLength'),

  /**
    Minimum number of characters for a post body to be valid.

    @property minimumPostLength
  **/
  minimumPostLength: function() {
    if( this.get('privateMessage') ) {
      return this.siteSettings.min_private_message_post_length;
    } else if (this.get('topicFirstPost')) {
      // first post (topic body)
      return this.siteSettings.min_first_post_length;
    } else {
      return this.siteSettings.min_post_length;
    }
  }.property('privateMessage', 'topicFirstPost'),

  /**
    Computes the length of the title minus non-significant whitespaces

    @property titleLength
  **/
  titleLength: function() {
    const title = this.get('title') || "";
    return title.replace(/\s+/img, " ").trim().length;
  }.property('title'),

  _setupComposer: function() {
  }.on('init'),

  /*
     Open a composer

     opts:
       action   - The action we're performing: edit, reply or createTopic
       post     - The post we're replying to, if present
       topic    - The topic we're replying to, if present
*/
  open(opts) {

    if (!opts) opts = {};
    this.set('loading', false);

    const composer = this;

    if (opts.action === REPLY && this.get('action') === EDIT) this.set('reply', '');
    if (!opts.draftKey) throw 'draft key is required';
    if (opts.draftSequence === null) throw 'draft sequence is required';

    this.setProperties({
      draftKey: opts.draftKey,
      draftSequence: opts.draftSequence,
      composeState: opts.composerState || OPEN,
      action: opts.action,
      topic: opts.topic,
      targetUsernames: opts.usernames,
      composerTotalOpened: opts.composerTime,
      typingTime: opts.typingTime
    });



    this.setProperties({
      metaData: opts.metaData ? Em.Object.create(opts.metaData) : null
    });

    // We set the category id separately for topic templates on opening of composer
    this.set('categoryId', opts.categoryId || this.get('topic.category.id'));

    if (!this.get('categoryId') && this.get('creatingTopic')) {
      const categories = Nilavu.Category.list();
      if (categories.length === 1) {
        this.set('categoryId', categories[0].get('id'));
      }
    }

    return false;
  },


  save(opts) {
    if (!this.get('cantSubmitPost')) {
      return  this.createTopic(opts);
    }
  },

  /**
    Clear any state we have in preparation for a new composition.

    @method clearState
  **/
  clearState() {
    this.setProperties({
      originalText: null,
      reply: null,
      post: null,
      title: null,
      editReason: null,
      stagedPost: false,
      typingTime: 0,
      composerOpened: null,
      composerTotalOpened: 0
    });
  },

  serialize(serializer, dest) {
    dest = dest || {};
    Object.keys(serializer).forEach(f => {
      const val = this.get(serializer[f]);
      if (typeof val !== 'undefined') {
        Ember.set(dest, f, val);
      }
    });
    return dest;
  },

  // Create a new topic. What the heck is a topic ?
  // Lets just pay tribute to discourse friends.
  createTopic(opts) {
    const  topic = this.get('topic');
    //   user = this.user,
    //   postStream = this.get('topic.regions');

    let addedToStream = false;

    // Build the topic object
    const createdTopic = this.store.createRecord('topic', {
      name: opts.random_name,
      domain: opts.domain,
      //hostname: (opt.random_name + "." + opts.domain),
      region: opts.regionoption,
      resource: opts.resourceoption,
      number_of_units: opts.duplicateoption,
      cpu: 0,
      ram: 0,
      storage: 0,
      storagetype: opts.storagetypeoption,
      selectionoption: opts.selectionoption,
      keypairoption: "OLD",
      keypairname: "kkfirst",
      enable_ipv6: false,
      enable_privnetwork: true
    });

    this.serialize(_create_serializer, createdTopic);

    if (inputs) {
      /*createdTopic.setProperties({
        reply_to_post_number: post.get('post_number'),
        reply_to_user: {
          username: post.get('username'),
          avatar_template: post.get('avatar_template')
        }
      });*/
    }

    const composer = this;
    composer.set('composeState', SAVING);
    composer.set("stagedPost", state === "staged" && createdTopic);

    return createdTopic.save().then(function(result) {
      let saving = true;

      if (result.responseJson.action === "enqueued") {
        if (postStream) {
           postStream.undoPost(createdPost); }
        return result;
      }

      if (topic) {
        // It's no longer a new post
        topic.set('draft_sequence', result.target.draft_sequence);
        postStream.commitPost(createdPost);
        addedToStream = true;
      } else {
        // We created a new topic, let's show it.
        composer.set('composeState', CLOSED);
        saving = false;

        // Update topic_count for the category
        const category = composer.site.get('categories').find(function(x) { return x.get('id') === (parseInt(createdPost.get('category'),10) || 1); });
        if (category) category.incrementProperty('topic_count');
        Nilavu.notifyPropertyChange('globalNotice');
      }

      composer.clearState();
      composer.set('createdPost', createdPost);

      if (addedToStream) {
        composer.set('composeState', CLOSED);
      } else if (saving) {
        composer.set('composeState', SAVING);
      }

      return result;
    }).catch(throwAjaxError(function() {
      if (postStream) {
        postStream.undoPost(createdPost);
      }
      Ember.run.next(() => composer.set('composeState', OPEN));
    }));
  }
});

Composer.reopenClass({

  // TODO: Replace with injection
  create(args) {
    args = args || {};
    args.user = args.user || Nilavu.User.current();
    args.site = args.site || Nilavu.Site.current();
    args.siteSettings = args.siteSettings || Nilavu.SiteSettings;
    return this._super(args);
  },

  serializeToTopic(fieldName, property) {
    if (!property) { property = fieldName; }
    _edit_topic_serializer[fieldName] = property;
  },

  serializeOnCreate(fieldName, property) {
    if (!property) { property = fieldName; }
    _create_serializer[fieldName] = property;
  },

  serializedFieldsForCreate() {
    return Object.keys(_create_serializer);
  },

  // The status the compose view can have
  CLOSED,
  SAVING,
  OPEN,
  DRAFT,

  // The actions the composer can take
  CREATE_TOPIC,
  PRIVATE_MESSAGE,
  REPLY,
  EDIT,

  // Draft key
  REPLY_AS_NEW_TOPIC_KEY
});

export default Composer;
