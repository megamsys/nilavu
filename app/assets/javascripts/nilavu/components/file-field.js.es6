import {
    on
} from 'ember-addons/ember-computed-decorators';
export default Ember.Component.extend(Ember.Evented, {
    tagName: 'input',
    type: 'file',
    attributeBindings: ['type', 'multiple'],
    multiple: false,

    @on('didInsertElement')
    _initialize() {
        Ember.$("input[type='file'").click();
    },

    change(event) {
        const input = event.target;
        if (!Ember.isEmpty(input.files)) {
            this.sendAction('action', input.files);
        }

    }
});
