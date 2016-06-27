import { propertyEqual } from 'nilavu/lib/computed';

export default Em.Component.extend({

    showBrandImage: function() {
        const brandImageUrl = this.get('results.logo');

        if (Em.isNone(brandImageUrl)) {
            return `<img src="../images/brands/dummy.png" />`.htmlSafe();
        }

        return `<img src="../images/brands/${brandImageUrl}.png" />`.htmlSafe();
    }.property('results.logo'),

    actions: {}
});
