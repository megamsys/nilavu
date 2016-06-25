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

  actions: {
  }
});
