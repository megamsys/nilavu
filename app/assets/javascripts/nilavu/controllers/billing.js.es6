import NilavuURL from 'nilavu/lib/url';

export default Ember.Controller.extend({
    currentUsage: "$10.50",
    currentBalance: "$9.00",
    regions: [{
        name: "sydney",
        value: "sydney"
    }, {
        name: "chennai",
        value: "chennai"
    }, {
        name: "dar_e_salaam",
        value: "dar_e_salaam"
    }],
    ram: "1024",
    core: "1",
    bandwidth: "24",
    ssd: "1",
    ipv4: "1",

    ram_cost_per_hour: "0.02",
    ramcosthour:null,
    billingRegionoption: function() {
        console.log("111111111");
        return "chennai";
    }.property(),


});
