export default Nilavu.Route.extend({

  /*  model() {

      return {
            regions:
            [ {
                    flag: "images/regions/au.png",
                    currency: "&#128;",
                    cpu_cost_per_hour: "0.01",
                    ram_cost_per_hour: "0.02",
                    storage_cost_per_hour: "0.01",
                    max_cpu: "10",
                    max_ram: "256 GB",
                    max_storage: "500 GB",
                    name: "sydney",
                    flavors: {
                        micro: "1 GB,1 Core,24 GB",
                        small: "2 GB,2 Cores,48 GB",
                        medium: "3 GB,4 Cores,96 GB",
                    }

                }

                {
                    flag: "images/regions/in.png",
                    currency: "&#8377;",
                    cpu_cost_per_hour: "0.009",
                    ram_cost_per_hour: "0.019",
                    storage_cost_per_hour: "0.019",
                    max_cpu: "10",
                    max_ram: "128 GB",
                    max_storage: "256 GB",
                    name: "Chennai",
                    flavors: {
                        micro: "1 GB,2 Cores,24 GB",
                        medium: "2 GB,2 Cores,36 GB",
                        large: "3 GB,3 Cores,48 GB",

                    }

                },

                {
                    flag: "images/regions/tz.png",
                    currency: "TZS",
                    cpu_cost_per_hour: "0.008",
                    ram_cost_per_hour: "0.021",
                    storage_cost_per_hour: "0.018",
                    max_cpu: "5",
                    max_ram: "100 GB",
                    max_storage: "1024 GB",
                    name: "dar_e_salaam",
                    flavors: {
                        small: "4 GB,1 Cores,48 GB",
                        medium: "4 GB,2 Cores,96 GB",
                        large: "8 GB,2 Cores,192 GB",
                    }

                }
            ]

    }
}
    billing_data() {
        cosole.log("************");
      const billingdata = Nilavu.ajax("/billings.json", {
           type: 'GET',
        }).then(function(result) {
            if (result.success) return result;
            return result;
        });
        return billingdata;
    }

    data: null,
    beforModel(){
      var _this = this;
      this.billing_data().then(function(result){
        console.log("*****************");
    _this.set('data', result);
      });
    },*/
});
