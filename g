#!/bin/bash

#This is a hack to make sure we pull and use stuff from the bundle we built

set -u
set -e

nil_dir="/usr/share/megam/megamnilavu"

HOST="127.0.0.1"

LOGF="/var/log/megam/megamnilavu/megamnilavu.log"

PIDF="/var/run/megam/megamnilavu.pid"

export GEM_HOME="$nil_dir/vendor/bundle/ruby/2.2.0/gems"

export PATH="$nil_dir/vendor/ruby-2.2.2/bin:$PATH"

CMD="bundle exec passenger start -a $HOST -p 8080 -d -e production --log-file $LOGF --pid-file $PIDF"

$CMD
