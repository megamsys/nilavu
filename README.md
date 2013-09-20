# Ruby on Rails - www.megam.co

[![Build Status](https://travis-ci.org/indykish/nilavu.png?branch=master)](https://travis-ci.org/indykish/nilavu)

Nilavu is a [Rails4](http://guides.rubyonrails.org/) based [Megam Cloud](http://www.megam.co) Web App. 
We named it in dialect Tamil, which means "moon".

This will be our main WebApp for [Megam Cloud](http://www.megam.co) providing

* Launch Cloud Apps(books) from our Polygot PaaS 

* Cloud management for the launched apps using [megam_api](https://github.com/indykish/megam_api.git) which interfaces to 
  [megam_play](https://github.com/indykish/megam_play.git)
  
* Realtime Log for the launched Apps using Megam - using [tap](https://github.com/indykish/tap.git)

* Offline Log with metrics using [angularjs - kibana](http://www.elasticsearch.org/overview/kibana/) 

* Dash with Metering Monitoring using [angularjs](http://angularjs.org) Inspired by (https://github.com/fdietz/team_dashboard)

* Cloud App Connectors Preview [deccanplato](https://github.com/indykish/deccanplato.git)  

In general Nilavu supports the following basic features:

* This project provides a skeleton for a portal to be built using Ruby on Rails. 
 
* The basic requirements of home page, signin, signout are handled. The template approach using twitter-bootstrap/Less is available.

* Nilavu uses a two bootstrap themes named 
  [Measure](http://bit.ly/UDywP8) bought from [wrapbootstrap.com](http://wrapbootstrap.com) for the main pages. 
  [Unicorn](http://bit.ly/RpG9bh) bought from [wrapbootstrap.com](http://wrapbootstrap.com) for the dashboard.

This code uses a `single user license` of the above themes. Anybody who `forks this code shall buy a 
license` to use it for their own need.

### Requirements

> [Postgres 9.1 +](http://postgresql.org)
> [Ruby 2.0](http://ruby-lang.org)
> [Rails 4](http://guides.rubyonrails.org/4_0_release_notes.html)


### Configuration
```ruby

```

### Tested on Ubuntu 13.04, AWS - EC2

#### Unit Tests

*  Click all bottom static links

> Clean DB/ megam_play down, config.metric.source = demo, config.payment.gateway = demo
* Run the functional tests for Signin/Signup
* Update My Account, Organization, API Key, PW 
(1) Click Dashboard
(2) Login, click the left links 
* Cloud Book - (Error growls should appear) 
* Cloud Runs - Angular should get loaded correctly.
(3) Signout, Sign In, and perform 1, 2

> Clean DB/ megam_play up, config.metric.source = demo, config.payment.gateway = demo
* Run the functional tests for Signin/Signup
* Update My Account, Organization, API Key, PW
(1) Click Dashboard
(2) Login, click the left links
* Cloud Books - (Success growls should appear)
* Cloud Runs - Angular should get loaded correctly.
(3) Click "Create Cloud Books (Step 1, Step 2)"
(4) Signout, Sign In, and perform 1,2,3


### Unit Testing for user SIGNIN and SIGNUP

(1) Clean DB
(2) Develop test specs for our condition's, for example we use following conditions via spec

*  Sign up with all input parameters
*  Sign up with defferent values of password & password confirmation
*  login with valid credentials
*  login with invalid credentials 
                                 and etc...

(3) * These conditions check the given data, 
    * it'll not affect the original data, 
    * it'll not create any records in database for signup
    
(4) For login testcases fixtures data will be loaded to database      


### Getting Started

* Register here [http://www.megam.co](http://www.megam.co) - We'll launch soon.

![Megam Polygot PaaS](http://indykish.files.wordpress.com/2012/06/megam_landing_page.png?w=645&h=996 "Megam Polygot PaaS")


If you are interested in using this as a sample to build your Rails app, Go ahead.

1. Clone the Git code and At the command prompt:
       'git clone https://github.com/indykish/nilavu.git'

2. Change directory to 'nilavu' and start the web server:
       'rails server (run with --help for options)'
   Refer our rails cookbok in [chef-repo](https://github.com/indykish/chef-repo.git) for production deployment.

3. Change directory to 'scripts' and run:
       `./d dbinit` Initializes the postgres database.
              
4. Go to http://localhost:3000/ and you'll see:
       `Measure Theme page:` titled `Live Cloud(Cloud Identity)`

5. Follow the guidelines to start developing your application. You can find
the following resources handy:

* The Getting Started Guide: http://guides.rubyonrails.org
* Ruby on Rails Tutorial Book: http://www.railstutorial.org/


#### TO - DO

* Dashboard Metrics integration in progress using angular
* Integrate to Paypal, bitcoin, justpay.in
	
# License


|                      |                                          |
|:---------------------|:-----------------------------------------|
| **Author:**          | Thomal Alrin (<alrin@megam.co.in>)
|                      | Rajthilak (<rajthilak@megam.co.in>)
|		               | KishorekumarNeelamegam (<nkishore@megam.co.in>)
| **Copyright:**       | Copyright (c) 2012-2013 Megam Systems.
| **License:**         | Apache License, Version 2.0

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.

