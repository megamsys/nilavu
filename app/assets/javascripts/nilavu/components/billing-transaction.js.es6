import { longDate } from 'nilavu/lib/formatter';

export default Ember.Component.extend({
    tagName: 'tr',

    gateway: Ember.computed.alias('transaction.gateway'),

    accounts_id: Ember.computed.alias('transaction.accounts_id'),

    amountOut: Ember.computed.alias('transaction.amountout'),

    tranDate: longDate(Ember.computed.alias('transaction.trandate')),

    tranCurrency: Ember.computed.alias('tranasaction.currency_type')


});
