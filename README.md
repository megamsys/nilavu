=========================================================================
Megam Vertice [https://www.megam.io](https://www.megam.io)
=========================================================================

[![Build Status](https://travis-ci.org/megamsys/nilavu.png?branch=1.5)](https://travis-ci.org/megamsys/nilavu)

Nilavu is a [Rails 4.2.x](http://guides.rubyonrails.org/) ember.js browser based user interface for [Vertice - PaaS for the hosting industry](https://www.megam.io).


# Wanna host your own VPS ?

Contact our partner [DET.io](http://det.io) and stay ahead of cluggy/old `SolusVM`.

# Try out:


# Features

[vertice.megam.io](https://vertice.megam.io)

* Launch apps, services(db, queue, nosql..) in hybrid cloud in seconds.

* Launch a micro service (public or on premise) in a giant swarm cluster with replication and scaling

* Integrated billing with WHMCS

* Launch 100's of Bitnami apps in a second

* Launch 1000's of Docker registry using an intuitive search

## Requirements

1. [Ruby 2.3.x](http://ruby-lang.org)
4. [Vertice Gateway](https://github.com/megamsys/vertice_gateway)


## What does this product look like ?

The UX/UI design was done by [enixel](http://enixel.com) and our parnter [DET.io](http://det.io)

###Sneakpeak of the product

![Dashboard](https://github.com/megamsys/nilavu/blob/1.5/public/sneakpeak/megam_vertice_dashboard.png)

###Pre-signup
![Presignup](https://github.com/megamsys/nilavu/blob/1.5/public/sneakpeak/megam_vertice_presignup.png)

###Billing integration (*WHMCS*, Blesta, ...)
![Billing Integration WHMCS](https://github.com/megamsys/nilavu/blob/1.5/public/sneakpeak/megam_vertice_subscription.png)

###Multi region cluster (You can have Datacenters in `chennai`, `sydney`...)
![Multi region/Cluster launcher WHMCS](https://github.com/megamsys/nilavu/blob/1.5/public/sneakpeak/megam_vertice_multiregion_launcher.png)

###Marketplace
![Marketplace](https://github.com/megamsys/nilavu/blob/1.5/public/sneakpeak/megam_vertice_mktplace.png)

###Management
![Management](https://github.com/megamsys/nilavu/blob/1.5/public/sneakpeak/megam_vertice_management.png)

###Log/Activity
![Log activity and Monitoring](https://github.com/megamsys/nilavu/blob/1.5/public/sneakpeak/megam_vertice_logs.png)

###Billing usage
![Billing usage and selector](https://github.com/megamsys/nilavu/blob/1.5/public/sneakpeak/megam_vertice_pricing_billing_whmcs.png)

## Compile from source

You'll need `ruby 2.x` and [vertice_gateway](https://github.com/megamsys/vertice_gateway.git) setup.

### Fork

After you have forked a copy of https://github.com/megamsys/vertice_gateway.git

### Steps

```

git clone https://github.com/<your_github_id>/nilavu.git

cd nilavu

cp ./hooks ./git/.hooks

bundle update

bundle install

```

Now you are all set.

# Contribution

For [contribution] (https://github.com/megamsys/vertice/blob/master/CONTRIBUTING.md)

# Documentation

For [documentation] (http://docs.megam.io)
    [wiki] (https://github.com/megamsys/vertice/wiki)

# License

MIT


# Authors

Maintainers Megam (<info@megam.io>)
