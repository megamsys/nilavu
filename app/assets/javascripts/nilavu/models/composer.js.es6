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


  // whether to submit the topic if there is balance or not
  cantSubmitTopic: function() {

    // can't submit while loading
    if (this.get('loading')) return true;

      // reply is always required
    if (this.get('missingBalanceInKitty') > 0) return true;

    return false;
  }.property('loading', 'missingBalanceInKitty'),


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

  _setupComposer: function() {
  }.on('init'),

  /*
     Open a composer

     opts:
       action   - The action we're performing: edit, reply or createTopic
       topic    - The topic we're replying to, if present
*/
  open(opts) {

    if (!opts) opts = {};
    this.set('loading', false);

    const composer = this;

    if (opts.action === REPLY && this.get('action') === EDIT) this.set('reply', '');

    this.setProperties({
      composeState: opts.composerState || OPEN,
      action: opts.action,
      topic: opts.topic
    });


    this.setProperties({
      metaData: opts.metaData ? Em.Object.create(opts.metaData) : null
    });

    return false;
  },


  save(opts) {
    if (!this.get('cantSubmitTopic')) {
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
    alert(JSON.stringify(opts));
    alert(JSON.stringify(this.get('model')));
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


/////////////////////////////

/*save: function() {
    var url = "/categories";
    if (this.get('id')) {
      url = "/categories/" + this.get('id');
    }

    return Nilavu.ajax(url, {
      data: {
        name: this.get('name'),
        slug: this.get('slug'),
        color: this.get('color'),
        text_color: this.get('text_color'),
        secure: this.get('secure'),
        permissions: this.get('permissionsForUpdate'),
        auto_close_hours: this.get('auto_close_hours'),
        auto_close_based_on_last_post: this.get("auto_close_based_on_last_post"),
        position: this.get('position'),
        email_in: this.get('email_in'),
        email_in_allow_strangers: this.get('email_in_allow_strangers'),
        parent_category_id: this.get('parent_category_id'),
        logo_url: this.get('logo_url'),
        background_url: this.get('background_url'),
        allow_badges: this.get('allow_badges'),
        custom_fields: this.get('custom_fields'),
        topic_template: this.get('topic_template'),
        suppress_from_homepage: this.get('suppress_from_homepage')
      },
      type: this.get('id') ? 'PUT' : 'POST'
    });
  },
  */
///////////////////////////////////////////////////////////

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
