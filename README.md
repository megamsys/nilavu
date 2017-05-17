# Nilavu

[![Build Status](https://travis-ci.org/megamsys/nilavu.png?branch=1.5)](https://travis-ci.org/megamsys/nilavu)

Nilavu is a [Rails 4.2.x](http://guides.rubyonrails.org/) ember.js browser based user interface for [Vertice - PaaS for the hosting industry](https://www.megam.io).

# This project is actively developed in [gitlab.com](https://gitlab.com/megamsys/nilavu)

# Demo [link](http://demo.virtengine.com) Note: This is the 'Enterprise Edition' which is more recent version

This opensource repository will be refreshed periodically. Please watch this [thread](https://github.com/megamsys/nilavu/issues/1233) for updates.

# I am an individual or enterprise that would like to manage our internal infrastructure

1. Do you want to increase your efficiency in managing your infrastructure?
2. Would like to deploy applications (Custom or Pre-packaged) in seconds?
3. Optimize your infrastructure usage by automatically scaling these applications?
4. Have a self-hosted DigitalOcean like solution?
5. Do you need to convert raw harddisks to cloud storage in a jizzy?
6. Would love to have a fully redundant private cloud that just never goes down?

Visit [Megam](https://www.megam.io) and optimize your private cloud now!

We have an enterprise edition that also enhances our features!

# I am a hosting provider that would like to offer cloud solution.

1. Do you want a DigitalOcean/AWS/Azure like experience for your customers ?
2. Would like to be one of the first providers that offers Platform as a Service with scaling solutions?
3. Want to offer High Availability to your customers?

Visit [VirtEngine](http://virtengine.com) and stay ahead of cluggy/old `SolusVM`.

[VirtEngine](http://virtengine.com) has automation tools and offers integration with billing!

# Features

[Tour - docs.megam.io](https://docs.megam.io/overview/tour/)

##OpenSource

* Launch 100's of Bitnami apps in a second

* Launch 1000's of Docker registry using an intuitive search

* Launch apps, services(db, queue, nosql..) in hybrid cloud in seconds.


##Enterprise

* Integrated ondemand/recurring quota based billing with WHMCS 

* Cloud storage

* Containers (Swarm/Rancher)

* Secure containers

## Requirements

1. [Ruby 2.3.x](http://ruby-lang.org)
2. [Vertice Gateway](https://github.com/megamsys/vertice_gateway)


## What does this product look like ?

The UX/UI design was done by [enixel](http://enixel.com) and our partner [DET.io](http://det.io)

###Sneakpeak

![Dashboard](https://github.com/megamsys/nilavu/blob/1.5/public/sneakpeak/megam_vertice_dashboard.png)

###Pre-signup
![Presignup](https://github.com/megamsys/nilavu/blob/1.5/public/sneakpeak/megam_vertice_presignup.png)

###Marketplace
![Marketplace](https://github.com/megamsys/nilavu/blob/1.5/public/sneakpeak/megam_vertice_mktplace.png)

###Management
![Management](https://github.com/megamsys/nilavu/blob/1.5/public/sneakpeak/megam_vertice_management.png)

###Billing usage
![Billing usage and selector](https://github.com/megamsys/nilavu/blob/1.5/public/sneakpeak/megam_vertice_pricing_billing_whmcs.png)

##Enterprise Features

###Billing integration (*WHMCS*, Blesta, ...)
![Billing Integration WHMCS](https://github.com/megamsys/nilavu/blob/1.5/public/sneakpeak/megam_vertice_subcription.png)

###Multi region cluster (You can have Datacenters in `chennai`, `sydney`...)
![Multi region/Cluster launcher WHMCS](https://github.com/megamsys/nilavu/blob/1.5/public/sneakpeak/megam_vertice_multiregion_launcher.png)

## Compile from source

You'll need `ruby 2.3.x` and [vertice_gateway](https://github.com/megamsys/vertice_gateway.git) setup.

### Fork

After you have forked a copy of https://github.com/megamsys/nilavu.git

### Steps

```

git clone https://github.com/<your_github_id>/nilavu.git

cd nilavu

bundle update

bundle install

```

Type http://localhost:3000

Now you are all set.

# Contribution

For [contribution] (https://github.com/megamsys/vertice_dev_kit/blob/master/CONTRIBUTING.md)

# Documentation

For [documentation] (http://docs.megam.io)
    [wiki] (https://github.com/megamsys/vertice_dev_kit)

# License

MIT


# Authors

Maintainers: Megam Systems (<info@megam.io>)
Distributors (Public Cloud Edition): VirtEngine (DET.io) (<hello@virtengine.com>)
