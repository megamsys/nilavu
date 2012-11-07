#remove products
heroku run rake db:migrate:down VERSION=20120829143151
#remove apps_items
heroku run rake db:migrate:down VERSION=20120824094944
#remove cloud_apps
heroku run rake db:migrate:down VERSION=20120824063657
#remove cloud_identities
heroku run rake db:migrate:down VERSION=20120817045502
#remove logo
heroku run rake db:migrate:down VERSION=20120811145726
#drop organizations
heroku run rake db:migrate:down VERSION=20120811145124
#drop identities
heroku run rake db:migrate:down VERSION=20120319154255
#drop users
heroku run rake db:migrate:down VERSION=20120319153913

#create users
heroku run rake db:migrate:up VERSION=20120319153913
#create identities
heroku run rake db:migrate:up VERSION=20120319154255
#create organization
heroku run rake db:migrate:up VERSION=20120811145124
#alter organization - logo
heroku run rake db:migrate:up VERSION=20120811145726
#create cloud_identities
heroku run rake db:migrate:up VERSION=20120817045502
#create cloud_apps
heroku run rake db:migrate:up VERSION=20120824063657
#create apps_items
heroku run rake db:migrate:up VERSION=20120824094944
#create products
heroku run rake db:migrate:up VERSION=20120829143151

heroku run rake db:seed


