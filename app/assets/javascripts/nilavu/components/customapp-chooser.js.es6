import ComboboxView from 'nilavu/components/combo-box';
import computed from 'ember-addons/ember-computed-decorators';
import { observes, on } from 'ember-addons/ember-computed-decorators';
import { customappBadgeHTML } from 'nilavu/helpers/customapp-link';

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

    @on("init")
    _updateCustomapps() {
        if (!this.get('customapps')) {
            /*    const customapps = Nilavu.CustomApps.list();  */

            const customapps = [
                { id: '1', name: 'Java Web Application - Tomcat', logo: '../images/brands/java.png', description_text: 'webapp' },
                { id: '2', name: 'Ruby on Rails Framework', logo: '../images/brands/rails.png', description_text: 'webapp' },
                { id: '3', name: 'Node.js V8 Javascript         ', logo: '../images/brands/nodejs.png', description_text: 'webapp' },
                { id: '4', name: 'Playframework (Scala)', logo: '../images/brands/play.png', description_text: 'webapp' }
            ];

            this.set('customapps', customapps);
        }
    },

    @computed("rootNone")
    none(rootNone) {
        return 'launcher.customapp_choose';
    },

    comboTemplate(item) {
        let customapp = item;

        const customapps = [
            { id: '1', name: 'Java Web Application - Tomcat', logo: '../images/brands/java.png', description_text: 'Java Web Application' },
            { id: '2', name: 'Ruby on Rails', logo: '../images/brands/rails.png', description_text: 'Ruby on Rails' },
            { id: '3', name: 'Node.js V8 Javascript', logo: '../images/brands/nodejs.png', description_text: 'Node.js V8 Javascript' },
            { id: '4', name: 'Playframework (Scala)', logo: '../images/brands/play.png', description_text: 'Playframework (Scala)' }
        ];

        if (Ember.isEmpty(customapp.id)) {
            return customapp.text
        }

        const customappArray = customapps.filter((f) => f.id == item.id);

        customapp = customappArray.get('firstObject');

        let result = customappBadgeHTML(customapp, { link: false }) + customapp.description_text;
        return result;

    }

});
