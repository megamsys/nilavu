import ComboboxView from 'nilavu/components/combo-box';
import computed from 'ember-addons/ember-computed-decorators';
import {
    observes,
    on
} from 'ember-addons/ember-computed-decorators';
import {
    customappBadgeHTML
} from 'nilavu/helpers/customapp-link';

var get = Em.get;

export default ComboboxView.extend({
    classNames: ['combobox category-combobox'],
    dataAttributes: ['id', 'logo', 'description_text'],
    valueBinding: Ember.Binding.oneWay('source'),
    overrideWidths: true,
    castInteger: true,

    @computed("customapps")
    content(customapps) {
        return customapps;
    },

    didInsertElement: function() {
        if (!Em.isEmpty(this.get("selectedItem"))) {
            if (!Em.isEmpty(this.get("customapps"))) {
                const filtApp = this.get('customapps').filter((f) => f.name == this.get('selectedItem.flavor'));
                if (filtApp.get('firstObject')) {
                    this.set('value', filtApp.get('firstObject').id);
                }
            }
        }
    },

    _updateCustomApps: function() {
        var rval = [];
        const ca = this.get('customapps');

        if (ca.length > 0) {
            ca.forEach(function(a) {
                rval.addObject({
                    id: a.id,
                    name: a.name,
                    logo: '../images/brands/' + a.logo,
                    description_text: a.description
                })
            });
        }
        this.set('content', rval);
    }.observes('customapps'),


    @computed("rootNone") none(rootNone) {
        return 'customapp.choose';
    },

    comboTemplate(item) {
        let customapp = item;

        if (Ember.isEmpty(customapp.id)) {
            return customapp.text
        }

        let result = customappBadgeHTML(customapp, {
            link: false
        }) + customapp.text;

        return result;
    }

});
