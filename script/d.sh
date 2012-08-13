#!/usr/bin/sh
# This command will automatically bring down the required migration versions and bring it up.
# also will perform the required cleanup.
rake assets:clean
rake tmp:clear
rake assets:precompile

#remove logo
rake db:migrate:down VERSION=20120811145726
#drop organizations
rake db:migrate:down VERSION=20120811145124
#drop identities
rake db:migrate:down VERSION=20120319154255
#drop users
rake db:migrate:down VERSION=20120319153913

#create users
rake db:migrate:up  VERSION=20120319153913
#create identities
rake db:migrate:up VERSION=20120319154255
#create organization
rake db:migrate:up VERSION=20120811145124
#alter organization - logo
rake db:migrate:up VERSION=20120811145726











