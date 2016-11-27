#!/bin/bash
#
# FutureGateway fgAPIServer brew version setup script
#
# Author: Riccardo Bruno <riccardo.bruno@ct.infn.it>
#

source .fgprofile/commons
source .fgprofile/brew_commons
source .fgprofile/config

FGLOG=fgAPIServer.log
ASDB_OPTS="-sN"

# The array above contains any global scope temporaty file
TEMP_FILES=() 

# Create temporary files
cleanup_tempFiles() {
  echo "Cleaning temporary files:"
  for tempfile in ${TEMP_FILES[@]}
  do
    #echo "Viewing '"$tempfile"':"
    #cat $tempfile
    printf "Cleaning up '"$tempfile"' ... "
    rm -rf $tempfile
    echo "done"
  done
}

#
# Script body
#

# Cleanup global scope temporary files upon exit
trap cleanup_tempFiles EXIT

# Local temporary files for SSH output and error files
STD_OUT=$(mktemp -t stdout.XXXXXX)
STD_ERR=$(mktemp -t stderr.XXXXXX)
TEMP_FILES+=( STD_OUT )
TEMP_FILES+=( STD_ERR )

out "Starting FutureGateway fgAPIServer brew versioned setup script"

out "Verifying package manager and fgAPIServer user ..."

# Check for brew and install it eventually
check_and_setup_brew

# Check for FutureGateway fgAPIServer unix user
check_and_create_user $FGAPISERVER_HOSTUNAME

# Mandatory packages installation
if [ "$BREW" = "" ]; then
  out "Did not find brew package manager"
  exit 1
fi
out "Brew is on: '"$BREW"'"

out "Installing packages ..."

# Mandatory packages installation
BREWPACKAGES=(
  git
  wget
  coreutils
  jq
  mysql
  python
)
for pkg in ${BREWPACKAGES[@]}; do    
    install_brew $pkg     
done

# Python dependencies
out "Installing python dependencies ..." 1
RES=0
sudo easy_install pip &&
sudo pip install --upgrade pip &&
sudo pip install flask &&
sudo pip install flask-login &&
sudo pip install mysql-python &&
sudo pip install crypto &&
sudo pip install pyopenssl &&
RES=0
if [ $RES -ne 0 ]; then
    out "failed" 0 1
    out "Unable to install python depenencies"
fi
out "done" 0 1
out "Python dependencies successfully installed"

    
# Check mysql client
out "Looking up mysql client ... " 1
MYSQL=$(which mysql)
if [ "$MYSQL" = "" ]; then
    out "failed" 0 1
    out "Did not find mysql command"
    exit 1
fi
out "done ($MYSQL)" 0 1
        
#Check connectivity with fgdb
out "Checking mysql connectivity with FutureGateway DB ... " 1
ASDBVER=$(asdb "select version from db_patches order by 1 desc limit 1;")
RES=$?
if [ $RES -ne 0 ]; then
    out "failed" 0 1
    out "Missing mysql connectivity"
    exit 1
fi
out "done ($ASDBVER)" 0 1    

# Environment setup
if [ $RES -eq 0 ]; then
   out "Extracting software ..."
   out "Checking for git command ..." 1
   GIT=$(which git)
    if [ "$GIT" = "" ]; then
      out "failed" 0 1 
      out "Did not find git command"
      exit 1
    fi
    out "done ($GIT)" 0 1
    
    if [ -d $FGAPISERVER_GITREPO ]; then
      out "Repository exists!"
      cd $FGAPISERVER_GITREPO
      git pull origin $FGAPISERVER_GITTAG
      RES=$?
      if [ $RES -ne 0 ]; then
          out "Unable to pull $FGAPISERVER_GITREPO sources"
          exit 1
      else
          out "Reposiroty successfully pulled"
      fi
      cd - 2>/dev/null >/dev/null
    else
      out "Cloning from: $GIT_BASE/$FGAPISERVER_GITREPO tag/branch: $FGAPISERVER_GITTAG"
      $GIT clone -b $FGAPISERVER_GITTAG $GIT_BASE/$FGAPISERVER_GITREPO.git
      RES=$?
      if [ $RES -ne 0 ]; then
          out "Unable to clone '"$FGAPISERVER_GITREPO"'"
          exit 1
      fi
      cd $FGAPISERVER_GITREPO
      # Add execution rights to fgAPIServer, wsgi execution and PTV and TOSCA simulator
      chmod +x fgapiserver.py fgapiserver.wsgi fgapiserver_ptv.py
      cd - 2>/dev/null >/dev/null
    fi
fi 

# Environment setup
if [ $RES -eq 0 ]; then

   out "Preparing the environment ..."
   
   # Take care of config values to setup fgapiserver.conf properly
   
   # WSGI or screen configuration
   ####### !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
   ###### change below -eq 0 in -ne 0; testing launchd
   if [ $FGAPISERVER_WSGI -eq 0 ]; then
       out "Configuring fgAPIServer for wsgi ..."
   else
       out "Configuring fgAPIServer for stand-alone execution ..."
       CURRDIR=$(pwd)
       APISERVERDAEMON_LAUNCHDFILE=$(mktemp launchd.XXXXXX)
       TEMP_FILES+=( $APISERVERDAEMON_LAUNCHDFILE )
       sudo chown root:Admin /Library/LaunchDaemons
       sudo chmod g+w /Library/LaunchDaemons
       sudo cat >/Library/LaunchDaemons/it.infn.ct.fgAPIServer.plist <<EOF
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
	<dict>
		<key>Label</key>
		<string>it.infn.ct.fgAPIServer</string>
		<key>Program</key>
		<string>$CURRDIR/$FGAPISERVER_GITREPO/fgapiserver.py</string>
		<key>KeepAlive</key>
		<true/>
		<key>UserName</key>
		<string>$FGAPISERVER_HOSTUNAME</string>
		<key>WorkingDirectory</key>
		<string>$CURRDIR/$FGAPISERVER_GITREPO</string>
	</dict>
</plist>
EOF
       # Executing fgAPIServer service
       sudo chown root:wheel /Library/LaunchDaemons
       sudo chmod g-w /Library/LaunchDaemons
       sudo chown root /Library/LaunchDaemons/it.infn.ct.fgAPIServer.plist
       sudo chgrp wheel /Library/LaunchDaemons/it.infn.ct.fgAPIServer.plist
       sudo chmod o-w /Library/LaunchDaemons/it.infn.ct.fgAPIServer.plist
       sudo launchctl load -w /Library/LaunchDaemons/it.infn.ct.fgAPIServer.plist
   fi
   # Now take care of environment settings
   out "Setting up '"$FGAPISERVER_HOSTUNAME"' user profile ..."
   
   # Preparing user environment in .fgprofile/APIServerDaemon file
   #   BGDB variables
   #   DB macro functions
   FGAPISERVERENVFILEPATH=.fgprofile/APIServerDaemon
   cat >$FGAPISERVERENVFILEPATH <<EOF
#!/bin/bash
#
# APIServerDaemon Environment setting configuration file
#
# Very specific APIServerDaemon service components environment must be set here
#
# Author: Riccardo Bruno <riccardo.bruno@ct.infn.it>
EOF
   #for vgdbvar in ${FGAPISERVER_VARS[@]}; do
   #    echo "$vgdbvar=${!vgdbvar}" >> $FGAPISERVERENVFILEPATH
   #done
   ## Now place functions from setup_commons.sh
   #declare -f asdb  >> $FGAPISERVERENVFILEPATH
   #declare -f asdbr >> $FGAPISERVERENVFILEPATH
   #declare -f dbcn  >> $FGAPISERVERENVFILEPATH
   #out "done" 0 1
   out "User profile successfully created"
   
   # Now configure fgAPIServer accordingly to configuration settings
   out "Configuring fgAPIServer ... " 1
   cd $FGAPISERVER_GITREPO
   FGAPISERVER_CONFVALUES=(
    "fgapisrv_host=\"$FGAPISERVER_HOST\""
    "fgapisrv_debug=\"$FGAPISERVER_DEBUG\""
    "fgapisrv_port=\"$FGAPISERVER_PORT\""
    "fgapisrv_iosandbox=\"$FGAPISERVER_IOPATH\""
    "fgapisrv_db_port=\"$FGDB_PORT\""
    "fgapisrv_db_pass=\"$FGDB_PASSWD\""
    "fgapisrv_db_host=\"$FGDB_HOST\""
    "fgapisrv_db_name=\"$FGDB_HOST\""
    "fgapisrv_geappid=\"$UTDB_FGAPPID\""
    "fgapiver=\"$FGAPISERVER_APIVER\""
    "fgapisrv_notoken=\"$FGAPISERVER_NOTOKEN\""
    "fgapisrv_lnkptvflag=\"$FGAPISERVER_PTVFLAG\""
    "fgapisrv_ptvendpoint=\"$FGAPISERVER_PTVENDPOINT\""
    "fgapisrv_ptvmapfile=\"$FGAPISERVER_PTVMAPFILE\""
    "fgapisrv_ptvuser=\"$FGAPISERVER_PTVUSER\""
    "fgapisrv_ptvpass=\"$FGAPISERVER_PTVPASS\""
   )
   for confvalue in ${FGAPISERVER_CONFVALUES[@]}; do
       replace_line fgapiserver.conf "fgapisrv_host=" "$confvalue"
   done
   cd - 2>/dev/null >/dev/null
   out "done" 0 1
fi

# Report installation termination
if [ $RES -ne 0 ]; then
  OUTMODE="Unsuccesfully"
else
  OUTMODE="Successfully"
fi
out "$OUTMODE finished FutureGateway fgAPIServer brew versioned setup script"
exit $RES
