#!/bin/bash
#
# FutureGateway APIServerDaemon brew version setup script
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
TEMP_FILES+=( $STD_OUT )
TEMP_FILES+=( $STD_ERR )

out "Starting FutureGateway APIServerDaemon brew versioned setup script"

out "Verifying package manager and APIServerDaemon user ..."

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
)

    
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
    
    if [ -d $APISERVERDAEMON_GITREPO ]; then
      out "Repository exists!"
      cd $APISERVERDAEMON_GITREPO
      git pull origin $APISERVERDAEMON_GITTAG
      RES=$?
      if [ $RES -ne 0 ]; then
          out "Unable to pull $APISERVERDAEMON_GITREPO sources"
          exit 1
      else
          out "Reposiroty successfully pulled"
      fi
      cd - 2>/dev/null >/dev/null
    else
      out "Cloning from: $GIT_BASE/$APISERVERDAEMON_GITREPO tag/branch: $APISERVERDAEMON_GITTAG"
      $GIT clone -b $APISERVERDAEMON_GITTAG $GIT_BASE/$APISERVERDAEMON_GITREPO.git
      RES=$?
      if [ $RES -ne 0 ]; then
          out "Unable to clone '"$APISERVERDAEMON_GITREPO"'"
          exit 1
      fi
      cd $APISERVERDAEMON_GITREPO
      cd - 2>/dev/null >/dev/null
    fi
    # Get EIs repos
    # Compile APIServerDaemons and EIs 
fi 

# Environment setup
if [ $RES -eq 0 ]; then

   out "Preparing the environment ..."
   
   # Now take care of environment settings
   out "Setting up '"$APISERVERDAEMON_HOSTUNAME"' user profile ..."
   
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
   out "Configuring APIServerDaemon ... " 1
   cd $HOME/APISERVERDAEMON_GITREPO
   #replace_line fgapiserver.conf "fgapisrv_host" "fgapisrv_host = \"$FGAPISERVER_HOST\""
   cd - 2>/dev/null >/dev/null
   out "done" 0 1
fi

# Report installation termination
if [ $RES -ne 0 ]; then
  OUTMODE="Unsuccesfully"
else
  OUTMODE="Successfully"
fi
out "$OUTMODE finished FutureGateway APIServerDaemon brew versioned setup script"
exit $RES
