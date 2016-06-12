import NilavuURL from 'nilavu/lib/url';

export default Ember.Controller.extend({
    currentUsage: "$10.50",
    currentBalance: "$9.00",
    regions: [{
        name: "sydney",
        value: "sydney",
        ram: "1024",
        flavors: {
            micro: "1 GB,1 Core,24 GB",
            medium: "2 GB,2 Cores,48 GB",
            large: "3 GB,4 Cores,96 GB",
        }
    }, {
        name: "chennai",
        value: "chennai",
        ram: "1034",
        flavors: {
            micro: "1 GB,1 Core,24 GB",
            medium: "2 GB,2 Cores,36 GB",
            large: "3 GB,3 Cores,48 GB",
        }
    }, {
        name: "dar_e_salaam",
        value: "dar_e_salaam",
        ram: "1068",
        flavors: {
            micro: "1 GB,1 Core,24 GB",
            medium: "4 GB,2 Cores,96 GB",
            large: "8 GB,2 Cores,192 GB",
        }

    }],
    billingRegionoption: function() {
        return "chennai";
    }.property(),

    resources: function() {
        const _regionOption = this.get('billingRegionoption');
        const fullFlavor = this.get('regions').filter(function(c) {
            if (c.name == _regionOption) {
                return c;

            }
        });
        if (fullFlavor.length > 0) {
          const fl=fullFlavor.get('firstObject').flavors;
          alert("firstObject"+JSON.stringify(fl));

            this.set('unitFlavor', fullFlavor.get('firstObject').flavors);
        }

    }.observes('billingRegionoption'),


});
