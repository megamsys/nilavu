import NilavuURL from 'nilavu/lib/url';
import {buildSubPanel} from 'nilavu/components/sub-panel';
import computed from 'ember-addons/ember-computed-decorators';
import FlavorCost from 'nilavu/models/flavor_cost';

export default buildSubPanel('ondemand', {
    need: ['biller'],
    productName: Nilavu.SiteSettings.whmcs_ondemand_product,
    payment: Nilavu.SiteSettings.whmcs_ondemand_payment_method,
    billingcycle: Nilavu.SiteSettings.whmcs_ondemand_billingcycle,

    products: function() {
        return this.filterProduct(this.get('productName'));
    }.property('model.products'),

    payments: function() {
        return this.filterPayment(this.get('payment'));
    }.property('model.paymentMethods'),

    filterProduct: function(name) {
        return this.get('model.products').filter(function(e) {
            if (e.description === name) {
                return e;
            }
        });
    },

    filterPayment: function(name) {
        return this.get('model.paymentMethods').filter(function(e) {
            if (e.module === name) {
                return e;
            }
        });
    },

    productId: function() {
        const filteredProducts = this.get('products');
        if (filteredProducts.length > 0) {
            return filteredProducts.get('firstObject.pid');
        }
    }.property('products'),

    paymentMethod: function() {
        const filteredPayments = this.get('payments');
        if (filteredPayments.length > 0) {
            return filteredPayments.get('firstObject.module');
        }
    }.property('payments'),

    actions: {
        save() {
            const self = this;
            const v = this.get('paymentMethod');
            return Nilavu.ajax("/billers", {
                data: {
                    pid: this.get('productId'),
                    paymentmethod: this.get('paymentMethod'),
                    billingcycle: this.get('billingcycle')
                },
                type: 'POST'
            }).then(function(result) {
                if (result.success == true) {
                    window.location.replace(result.whmcsurl);
                } else {
                    self.notificationMessages.error(I18n.t('error'));
                }
            });
        }
    }
});
