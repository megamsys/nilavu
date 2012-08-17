#!/bin/bash
# This command will automatically bring down the required migration versions and bring it up.
# also will perform the required cleanup.
#
#
IDP_SCRIPT_PATH=
IDP_CD_PATH=
IDP_INSTALL_PATH=
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

for item in "$@"
do
    case $item in
        --[hH][eE][lL][pP])
            help
            ;;
	('/?')
            help
            ;;
         --[cC][lL][eE][aA][nN])
echo "Cleaning up tmp and assets..."
            clean
            ;;
 	--[pP][rR][eE][cC][oO][mM])
echo "Cleaning up tmp and assets, precompiling..."
echo "perform precom"
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
    echo "	--help    : prints the help message."
    echo "	--verify  : does a git status."
    echo "	--clean   : cleans up the temp files."
    echo "	--precom  : cleans up the temp files and precompiles asset."
    echo "	--dbclean : cleans up the db."
exitScript 0
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
rake db:migrate:up  VERSION=20120319153913
#create identities
rake db:migrate:up VERSION=20120319154255
#create organization
rake db:migrate:up VERSION=20120811145124
#alter organization - logo
rake db:migrate:up VERSION=20120811145726
#create cloud_identities
rake db:migrate:up VERSION=20120817045502

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
