# Ruby on Rails - www.megam.co

[![Build Status](https://travis-ci.org/indykish/nilavu.png?branch=master)](https://travis-ci.org/indykish/nilavu)

Nilavu is a [Rails4](http://edgeguides.rubyonrails.org/) based [Megam's](http://www.megam.co) SaaS portal. We named it in dialect Tamil, which means "moon".

Nilavu supports the following basic features:

* This project provides a skeleton for a portal to be built using Ruby on Rails. 
 
* The basic requirements of home page, signin, signout are handled. The template approach using twitter-bootstrap/Less is available.

* Nilavu uses a two bootstrap themes named 
  [Measure](http://bit.ly/UDywP8) bought from [wrapbootstrap.com](http://wrapbootstrap.com) for the main pages. 
  [Unicorn](http://bit.ly/RpG9bh) bought from [wrapbootstrap.com](http://wrapbootstrap.com) for the dashboard.

This code uses a `single user license` of the above themes. Anybody who `forks this code shall buy a 
license` to use it for their own need.

* UI for Cloud management approach using [megam_api](https://github.com/indykish/megam_api.git) which interfaces to 
  [megam_play](https://github.com/indykish/megam_play.git)
  
* UI for Cloud streaming using [tap](https://github.com/indykish/tap.git)

* UI for Live cloud `coming soon` [deccanplato](https://github.com/indykish/deccanplato.git)  

### Requirements

> [Postgres 9.1 +](http://postgresql.org)
> [Ruby 2.0]http://ruby-lang.org)
> [Rails 4](http://edgeguides.rubyonrails.org/4_0_release_notes.html)


### Tested on Ubuntu 12.10, 13.04, AWS - EC2

### Getting Started

* Register here [http://www.megam.co](http://www.megam.co) - We'll launch soon.

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

* The Getting Started Guide: http://edgeguides.rubyonrails.org
* Ruby on Rails Tutorial Book: http://www.railstutorial.org/


#### TO - DO

* Record Cloud Runs
* Stream Logs, Metrics
* Integrate to Paypal, bitcoin
* Interface to megam_api
	
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

