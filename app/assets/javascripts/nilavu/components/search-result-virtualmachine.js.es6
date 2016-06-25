import { propertyEqual } from 'nilavu/lib/computed';

export default Em.Component.extend({
  tagName: 'tr',

  showBrandImage: function() {
    const brandImageUrl =  this.get('resultType.logo');

    if (Em.isNone(brandImageUrl)) {
       return  `<img src="../images/brands/dummy.png" />`.htmlSafe();
    }

    return  `<img src="../images/brands/${brandImageUrl}" />`.htmlSafe();
  }.property('resultType.logo'),

  submitDisabled: function() {
    if  (!this.get('category.versionoption')) return;
    return (this.get('category.versionoption') || this.get('category.versionoption').length >= 1);
  }.property('vertionOption'),

  actions: {

    edit() {
      this.set('category.versionoption', this.get('resultType.name').toLowerCase());
      this.set('category.versiondetail', this.get('resultType'));
      this.set('versionOption', true);
    }

  }
});
