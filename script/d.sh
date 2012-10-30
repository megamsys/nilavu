#!/bin/bash
# This command will automatically bring down the required migration versions and bring it up.
# also will perform the required cleanup.
#
#
IDP_SCRIPT_PATH=
IDP_CD_PATH=
IDP_INSTALL_PATH=
IDP_GIT_COMMIT_MASTER=
IDP_GIT_MASTER=master
IDP_GIT_ORIGIN=origin
#--------------------------------------------------------------------------
#initialize the environment variables.
#IDP_INSTALL_PATH => the rails application installation directory. 
#--------------------------------------------------------------------------
initialize(){


    if [ -f "$PWD/app" ] ; #this for the symbolic linked build390USS.ksh
        then
        echo "WARNING !                                                 "
        echo "        Recommended  mode  to  start  the script is by running"
        echo "        d.sh  from  the  script  directory.!!!!"
            IDP_CD_PATH=$PWD
        else
            IDP_CD_PATH=../
	fi

cd $IDP_CD_PATH

IDP_INSTALL_PATH=$PWD

IDP_SCRIPT_PATH=$IDP_INSTALL_PATH/script
}
#
#
#
#--------------------------------------------------------------------------
#parse the input parameters. 
# Pattern in case statement is explained below.
# a*)  The letter a followed by zero or more of any
# *a)  The letter a preceded by zero or more of any 
#--------------------------------------------------------------------------
parseParameters()   {
#integer index=0
if [ $# -lt 1 ]
then
	help
        exitScript 0
fi
IDP_GIT_COMMIT_MASTER=$2

for item in "$@"
do
    case $item in
        --[hH][eE][lL][pP])
            help
            ;;
	('/?')
            help
            ;;
            --[mM][yY])
	    echo "Howdy $IDP_GIT_MASTER. Enjoy committing local to <master> - Github..."
            mystuff
            ;;
            --[oO][mM][yY])
	    echo "Howdy $IDP_GIT_ORIGIN. Enjoy committing local to <origin> - Github..."
            origin_stuff
            ;;
            --[uU][pP][dD])
	    echo "Howdy $IDP_GIT_MASTER.enjoy merging <origin> to local..."
            uptodate
            ;;
            --[fF][iI][nN][iI][sS][hH])
            finish
            ;;
         --[cC][lL][eE][aA][nN])
	    echo "Cleaning up tmp and assets..."
            clean
            ;;
 	--[pP][rR][eE][cC][oO][mM])
	    echo "Cleaning up tmp and assets, precompiling..."
            precom
            ;;
 	--[dD][bB][cC][lL][eA][aA][nN])
	    echo "Cleaning up db..."
            dbclean
            ;;         
        --[vV][eE][rR][sS][iI][oO][nN])
	   version
            ;;
        '--verify')
	   verify
            ;;         
        *)
	    echo "Unknown option : $item - refer help."
            help	
            ;;
esac
index=$(($index+1))
done
}
#
#
#--------------------------------------------------------------------------
#prints the help to out file.
#--------------------------------------------------------------------------
help(){
    echo "Usage : d.sh [Options]"
    echo "--help     : prints the help message."
    echo "--verify   : does a git status."
    echo "--my       : does a add, commit and push of my master."
    echo "--omy      : does a add, commit and push to origin."
    echo "--upd      : does a fetch from origing and merge to my master."
    echo "--finish   : does a push of anothers users master to origin"
    echo "             (committer only)"
    echo "--clean    : cleans up the temp files."
    echo "--precom   : cleans up the temp files and precompiles asset."
    echo "--dbclean  : cleans up the db."
    
exitScript 0
}
#--------------------------------------------------------------------------
# verify the installation
# this pretty much dumps the environment variables., java path and arguments
#-------------------------------------------------------------------------
verify(){
	echo "========================================================="
	printf "%-20s=>\t%s\n" git remote
	echo "========================================================="
	git remote -v
	echo "========================================================="
	printf "%-20s=>\t%s\n" git status 
	echo "========================================================="
	git status
	echo "========================================================="
	exitScript 1
}
#--------------------------------------------------------------------------
# git add all the files,commits to the local repos.
# performs a push to the users master in github.
#-------------------------------------------------------------------------
mystuff(){

	echo -n "Do you want to add/commit files [y/n]? "
	read -n 1 addcommit
	echo

	if [[ $addcommit =~ ^[Yy]$ ]]
	then
		echo "========================================================="
		git add .
		git commit .
	fi
	echo "========================================================="
	echo -n "Do you want to push to your master [y/n]? "
	read -n 1 pmstr
	echo
	if [[ $pmstr =~ ^[Yy]$ ]]
	then
		echo "========================================================="
		git push master	
		echo "========================================================="
	fi
	verify
	exitScript 1
}
#--------------------------------------------------------------------------
# git add all the files,commits to the local repos.
# performs a push to the committers origin in github.
#-------------------------------------------------------------------------
origin_stuff(){

	echo -n "Do you want to add/commit files [y/n]? "
	read -n 1 addcommit
	echo

	if [[ $addcommit =~ ^[Yy]$ ]]
	then
		echo "========================================================="
		git add .
		git commit .
	fi
	echo "========================================================="
	echo -n "Do you want to push to your origin [y/n]? "
	read -n 1 pmstr
	echo
	if [[ $pmstr =~ ^[Yy]$ ]]
	then
		echo "========================================================="
		git push origin	
		echo "========================================================="
	fi
	verify
	exitScript 1
}
#--------------------------------------------------------------------------
# git add all the files,commits to the local repos.
# performs a push to the users master in github.
#-------------------------------------------------------------------------
uptodate(){
	echo -n "Do you want to add/commit files [y/n]? "
	read -n 1 addcommit
	echo

	if [[ $addcommit =~ ^[Yy]$ ]]
	then
		echo "========================================================="
		git add .
		git commit .
	fi
	echo "========================================================="
	echo -n "Do you want to rebase from origin [y/n]? "
	read -n 1 pmstr
	echo
	if [[ $pmstr =~ ^[Yy]$ ]]
	then
		echo "========================================================="
		git fetch origin
		git merge origin
		echo "========================================================="
	fi
	exitScript 1
}
#--------------------------------------------------------------------------
# git add all the files,commits to the local repos.
# performs a push to the users master in github.
#-------------------------------------------------------------------------
finish(){
	if [ -z $IDP_GIT_COMMIT_MASTER ]
	then
		echo "Missing parameter <master repository name>."
		help
        	exitScript 1
	else
        echo "Howdy committer.Enjoy merging <$IDP_GIT_COMMIT_MASTER> to origin..."
		echo "========================================================="
		echo -n "Do you want to add/commit files [y/n]? "
		read -n 1 addcommit
		echo

		if [[ $addcommit =~ ^[Yy]$ ]]
		then
			echo "========================================================="
			git add .
			git commit .
		fi
		echo "========================================================="
		echo -n "Do you want to commit $IDP_GIT_COMMIT_MASTER to your origin [y/n]? "
		read -n 1 pmstr
		echo
		if [[ $pmstr =~ ^[Yy]$ ]]
		then
			echo "========================================================="
			git fetch $IDP_GIT_COMMIT_MASTER
			git merge $IDP_GIT_COMMIT_MASTER/master
			git push -u origin $IDP_GIT_COMMIT_MASTER/master
			echo "========================================================="
		fi
	verify
	exitScript 0
	fi
}
#
#
#
#
#--------------------------------------------------------------------------
#This command will automatically cleanup the assests and the tmp directory.
#--------------------------------------------------------------------------
clean(){
# 
# 
clear
rake assets:clean
rake tmp:clear
rm -r public/system
exitScript 0
}
#
#
#
#
#--------------------------------------------------------------------------
#This command will automatically cleanup the assests and the tmp directory.
#and run a precompile of the assets.
#--------------------------------------------------------------------------
precom(){
# 
# 
clear
rake assets:clean
rake tmp:clear
rake assets:precompile
exitScript 0
}
#
#
#
#--------------------------------------------------------------------------
#This command will automatically bring down the required migration versions and bring it up.
#also will perform the required cleanup.
#--------------------------------------------------------------------------
dbclean(){

#remove products
rake db:migrate:down VERSION=20120829143151
#remove apps_items
rake db:migrate:down VERSION=20120824094944
#remove cloud_apps
rake db:migrate:down VERSION=20120824063657
#remove cloud_identities
rake db:migrate:down VERSION=20120817045502
#remove logo
rake db:migrate:down VERSION=20120811145726
#drop organizations
rake db:migrate:down VERSION=20120811145124
#drop identities
rake db:migrate:down VERSION=20120319154255
#drop users
rake db:migrate:down VERSION=20120319153913

#create users
rake db:migrate:up VERSION=20120319153913
#create identities
rake db:migrate:up VERSION=20120319154255
#create organization
rake db:migrate:up VERSION=20120811145124
#alter organization - logo
rake db:migrate:up VERSION=20120811145726
#create cloud_identities
rake db:migrate:up VERSION=20120817045502
#create cloud_apps
rake db:migrate:up VERSION=20120824063657
#create apps_items
rake db:migrate:up VERSION=20120824094944
#create products
rake db:migrate:up VERSION=20120829143151

rake db:seed

exitScript 0
}
#
#
#
#--------------------------------------------------------------------------
#print the version.
#--------------------------------------------------------------------------
version(){
echo "Nothing to show as version now."
exitScript 0
}
#
#
#
exitScript(){
exit $@
}
#
#
#
#--------------------------------------------------------------------------
# main entry
#--------------------------------------------------------------------------
initialize
#parse parameters
parseParameters "$@"
