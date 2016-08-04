import { propertyEqual } from 'nilavu/lib/computed';

export default Em.Component.extend({
    tagName: 'tr',

    showBrandImage: function() {
        const brandImageUrl = this.get('resultType.logo');

        if (Em.isNone(brandImageUrl)) {
            return `<img src="../images/brands/dummy.png" />`.htmlSafe();
        }

        return `<img src="../images/brands/${brandImageUrl}" />`.htmlSafe();
    }.property('resultType.logo'),

    selectionStatus: function() {
        if (this.get('submitDisabled')) return I18n.t('customapp.prepackeble_selected');

        return I18n.t('customapp.prepackeble_select');
    }.property('submitDisabled'),

    submitDisabled: function() {
        if (!this.get('category.versionoption')) return;
        return (this.get('category.versionoption') || this.get('category.versionoption').length >= 1);
    }.property('versionOption'),

    actions: {

        edit() {
            this.notificationMessages.success(this.get('resultType.name').toLowerCase() + ' selected.');
            this.set('category.versionoption', this.get('resultType.name').toLowerCase());
            this.set('category.versiondetail', this.get('resultType'));
            this.set('category.sourceidentifier', this.get('resultType.provider'));
            this.set('category.sourceurl', this.get('resultType.name'));
            this.set('versionOption', true);
            this.set('gotoSummarize', true);
        }

    }
});
