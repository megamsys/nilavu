import RestModel from 'nilavu/models/rest';
import Topic from 'nilavu/models/topic';
import {
    throwAjaxError
} from 'nilavu/lib/ajax-error';
import computed from 'ember-addons/ember-computed-decorators';

const CLOSED = 'closed',
    SAVING = 'saving',
    OPEN = 'open',

    // The actions the composer can take
    CREATE_TOPIC = 'createTopic',

    // A default hack to say the user can launch.
    IAM_KING = 1,

    ONECLICK = "oneclick",

    // When creating, these fields can be serialzed

    _create_serializer = {
        random_name: 'random_name',
        domain: 'domain',
        region: 'regionoption',
        unit: 'unitoption',
        number_of_units: 'number_of_units',
        storagetype: 'storagetype',
        selectionoption: 'selectionoption',
        keypairoption: 'keypairoption',
        keypairname: 'keypairname',
        enable_ipv6: 'enable_ipv6',
        enable_privnetwork: 'enable_privnetwork'
    };

const Composer = RestModel.extend({

    creatingTopic: Em.computed.equal('action', CREATE_TOPIC),

    viewOpen: Em.computed.equal('composeState', OPEN),

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


    justName: function() {
        var split = this.get('metaData.versionoption').split('_');
        if (split.length > 1) {
            return split[0];
        }
        return this.get('metaData.versionoption');
    }.property('metaData.versionoption'),

    justVersion: function() {
        var split = this.get('metaData.versionoption').split('_');
        if (split.length > 1) {

            return split[1];
        }
        return this.get('metaData.versionoption');
    }.property('metaData.versionoption'),

    //cattype
    categoryType: Ember.computed.alias('metaData.versiondetail.cattype'),

    oneClick: function() {
        const opts = this.get('metaData.versiondetail.options');

        if (opts && opts.length > 0) {
            return (opts.filter((f) => f.key == ONECLICK)).length > 0
        }
        return false;
    }.property('metaData.versiondetail.options'),

    options: Ember.computed.alias('metaData.versiondetail.options'),

    enviRonment: Ember.computed.alias('metaData.versiondetail.envs'),


    // Determine if the kitty is available for the user.
    missingBalanceInKitty: function() {
        const balances = this.get('balances');
        //have a site setting allow_if_nobalance

        return IAM_KING > 0; //so who is the queen ? :)
    }.property('balances'),


    // whether to submit the topic if there is balance or not
    cantSubmitTopic: function() {

        // can't submit while loading
        if (this.get('loading')) return true;

        // reply is always required
        if (!this.get('missingBalanceInKitty')) return true;

        return false;
    }.property('loading', 'missingBalanceInKitty'),


    hasMetaData: function() {
        const metaData = this.get('metaData');
        return metaData ? Em.isEmpty(Em.keys(this.get('metaData'))) : false;
    }.property('metaData'),

    /**
      Did the user make changes to the launcher?

      @property launcherDirty
    **/
    launcherDirty: function() {
        return this.get('launcher') !== this.get('originalText');
    }.property('launcher', 'originalText'),

    _setupComposer: function() {
        this.setProperties({ itemsLoaded: 0, content: [] });
    }.on('init'),


    //     Open a composer and initialize its metaData
    open(opts) {

        if (!opts) opts = {};
        this.set('loading', false);

        const composer = this;

        this.setProperties({
            composeState: opts.composerState || OPEN,
            action: opts.action,
        });

        this.setProperties({
            metaData: opts.metaData ? Em.Object.create(opts.metaData) : null
        });

        return false;
    },


    save(opts) {
        if (!this.get('cantSubmitTopic')) {
            return this.createTopic(opts);
        }
    },

    /**
      Clear any state we have in preparation for a new composition.

      @method clearState
    **/
    clearState() {
        this.setProperties({
            random_name: '',
            metaData: {
              launchoption: '',
              domain: '',
              regionoption: '',
              resourceoption: '',
              unitoption: '',
              number_of_units: 1,
              storagetype: '',
              selectionoption: '',
              keypairoption: '',
              keypairname: '',
              enable_ipv6: false,
              enable_privnetwork: true
            }
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
        const composer = this.metaData;

        composer.set('composeState', SAVING);

        var url = "/launchers.json";

        if (this.get('id')) {
            url = 'launchers/' + this.get('id') + ".json";
        }

        return Nilavu.ajax(url, {
            data: {
                mkp_name: this.get('justName'),
                version: this.get('justVersion'),
                cattype: this.get('categoryType'),
                assemblyname: composer.get('random_name'),
                domain: composer.get('domain'),
                keypairoption: composer.get('keypairoption'),
                keypairname: composer.get('keypairnameoption'),
                region: composer.get('regionoption'),
                resource: composer.get('resourceoption'),
                resourceunit: composer.get('unitoption.flavor.value'),
                storagetype: composer.get('storageoption'),
                oneclick: this.get('oneClick'),
                options: this.get('options'),
                envs: this.get('enviRonment'),
                ipv6: composer.get('ipv6option'),
                privnetwork: composer.get('privnetworkoption')
                    // boostertype:  this.get('launchoption'),
            },
            type: this.get('id') ? 'PUT' : 'POST'
        });

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

    // The actions the composer can take
    CREATE_TOPIC,

});

export default Composer;
