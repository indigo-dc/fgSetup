#!/bin/bash
#
# FutureGateway database brew version setup script
#
# Author: Riccardo Bruno <riccardo.bruno@ct.infn.it>
#

source .fgprofile/commons
source .fgprofile/config

FGLOG=fgdb.log

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

# Install a given brew package
# $1 package name
install_brew() {
    PKGNAME=$1
    out "Installing package: '"$PKGNAME"' ... " 1
    $BREW ls $PKGNAME >/dev/null 2>/dev/null
    BREWRES=$?
    if [ $BREWRES -ne 0 ]; then
        out "(installing) " 1 1
        # Package is not installed; try toinstall it
        $BREW install $PKGNAME
        BREWRES=$?        
    else
        out "(existing) " 1 1
    fi
    RES=$?
    if [ $RES -ne 0 ]; then
        out "failed" 0 1
        break
    else
        out "done" 0 1
    fi
    return $BREWRES
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


out "Starting FutureGateway database brew versioned setup script"

BREW=$(which brew)
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
for pkg in ${BREWPACKAGES[@]}; do    
    install_brew $pkg     
done

# Continue only if packages have been installed correctly
if [ $RES -eq 0 ]; then
    out "Starting mysql service ... " 1
    # Using restart since mysql could be already running
    sudo $BREW services restart mysql 2>$STD_ERR >$STD_OUT
    RES=$?
    if [ $RES -ne 0 ]; then
        out "failed" 0 1
        out "Output:"
        out "$(cat $STD_ERR)"
        out "Error:"
        out "$(cat $STD_ERR)"
    else
        out "done" 0 1    
    fi
    
    # Check mysql client
    out "Looking up mysql client ... " 1
    MYSQL=$(which mysql)
    if [ "$MYSQL" = "" ]; then
      out "failed" 0 1
      out "Did not find mysql command"
      exit 1
    fi
    out "done ($MYSQL)" 0 1
        
    #Check connectivity
    out "Checking mysql connectivity ... " 1
    $MYSQL -h $FGDB_HOST -P $FGDB_PORT -u root $([ "$FGDB_ROOTPWD" != "" ] && echo "-p$FGDB_ROOTPWD") -e "select version()" >/dev/null 2>/dev/null
    RES=$?
    if [ $RES -ne 0 ]; then
        out "failed" 0 1
        out "Missing mysql connectivity"
        exit 1
    fi
    out "done" 0 1    
fi

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
    
    if [ -d $FGDB_GITREPO ]; then
      out "Repository exists!"
      cd $FGDB_GITREPO
      git pull origin $FGDB_GITTAG
      RES=$?
      if [ $RES -ne 0 ]; then
          out "Unable to pull $FGDB_GITREPO sources"
          exit 1
      else
          out "Reposiroty successfully pulled"
      fi
      cd - 2>/dev/null >/dev/null
    else
      out "Cloning from: $GIT_BASE/$FGDB_GITREPO tag/branch: $FGDB_GITTAG"
      $GIT clone -b $FGDB_GITTAG $GIT_BASE/$FGDB_GITREPO.git
      RES=$?
      if [ $RES -ne 0 ]; then
          out "Unable to clone '"$FGDB_GITREPO"'"
          exit 1
      fi
    fi
fi 

# Environment setup
if [ $RES -eq 0 ]; then

   out "Preparing the environment ..."
   
   # Check for db mandatory functions
   out "Checking for mysql macro functions ... "
   out "  asdbr ... " 1   
   declare -F asdbr &>/dev/null && out "found" 0 1 || (echo "not found" 0 1; RES=1)
   out "  asdb ... " 1
   declare -F asdb &>/dev/null && out "found" 0 1 || (echo "not found" 0 1; RES=1)
   out "  dbcn ... " 1
   declare -F dbcn &>/dev/null && out "found" 0 1 || (echo "not found" 0 1; RES=1)
   if [ $RES -ne 0 ]; then
       out "Macro function test check failed!"
       out "At lease one of the mandatory functions is missing"
       exit 1
   fi
   ASDB_OPTS="-sN"

   out "Checkig APIServer database exists ... " 1
   ASDB_OPTS="-sN"
   ASDBCOUNT=$(asdbr "select count(*) from information_schema.schemata where schema_name = 'fgapiserver';")
   RES=$?
   if [ $RES -ne 0 ]; then
       out "failed" 0 1
       out "Did not check if APIServer database exists"
       exit 1
   else
       out "done" 0 1
       if [ $ASDBCOUNT -ne 0 ]; then
           # Database do not exists; install it
           out "APIServerDatabase exists; deterimne its version ... " 1
           ASDBVER=$(asdb "select version from db_patches order by 1 desc limit 1;")
           RES=$?
           if [ $RES -ne 0 ]; then
               out "failed" 0 1
               out "Did not check if APIServerDatabase exists"
               exit 1
           fi
           # Database exists; it's time to update it
           out "done ($ASDBVER)" 0 1
           out "Attempting to patch APIServer database ... " 
           cd $FGDB_GITREPO/db_patches
           chmod +x patch_apply.sh
           ./patch_apply.sh
           RES=$?
           if [ $RES -ne 0 ]; then
               out "failed" 0 1
               out "Error applying database patch"
               exit 1
           fi
           out "Patch successfully applied"
           cd - 2>/dev/null >/dev/null 
       else
           # Database does not exist; create it
           out "APIServer database does not exists; creating  it... "
           cd $FGDB_GITREPO
           asdbr "-x fgapiserver.sql"
           RES=$?
           if [ $RES -ne 0 ]; then
               out "failed" 0 1
               out "Error creating database"
               exit 1
           fi
           out "APIServer database successfully created"
           cd - 2>/dev/null >/dev/null            
       fi
   fi
   
   # Now take care of environment settings
   out "Setting up '"$FGDB_HOSTUNAME"' user profile ..."
   
   # Preparing user environment in .fgprofile/fgdb file
   #   BGDB variables
   #   DB macro functions
   FGDBENVFILEPATH=.fgprofile/fgdb
   cat >$FGDBENVFILEPATH <<EOF
#!/bin/bash
#
# fgdb Environment setting configuration file
#
# Very specific FGDB service components environment must be set here
#
# Author: Riccardo Bruno <riccardo.bruno@ct.infn.it>
EOF
   #for vgdbvar in ${FGDB_VARS[@]}; do
   #    echo "$vgdbvar=${!vgdbvar}" >> $FGDBENVFILEPATH
   #done
   ## Now place functions from setup_commons.sh
   #declare -f asdb  >> $FGDBENVFILEPATH
   #declare -f asdbr >> $FGDBENVFILEPATH
   #declare -f dbcn  >> $FGDBENVFILEPATH
   #out "done" 0 1
   out "User profile successfully created"
fi

# Report installation termination
if [ $RES -ne 0 ]; then
  OUTMODE="Unsuccesfully"
else
  OUTMODE="Successfully"
fi
out "$OUTMODE finished FutureGateway database brew versioned setup script"
exit $RES
