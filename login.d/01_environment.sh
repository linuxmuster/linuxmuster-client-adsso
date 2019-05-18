# create user environment
#
# thomas@linuxmuster.net
# 20181127
#

function write2log() {
    logger -t linuxmuster-client "$1"
}

if [ -s "$userinfo" ]; then
  write2log "Getting userinfo."

  UNIXHOME="$(grep ^unixHomeDirectory "$userinfo" | awk '{ print $2 }')"
  SCHOOL="$(grep ^sophomorixSchoolname "$userinfo" | awk '{ print $2 }')"
  STUDENTGROUPS="$(grep ^memberOf "$userinfo" | grep 'OU=Students' | awk '{ print $2 }' | awk -F\, '{ print $1 }' | awk -F\= '{ print $2 }')"
  PROJECTGROUPS="$(grep ^memberOf "$userinfo" | grep 'OU=Projects' | awk '{ print $2 }' | awk -F\, '{ print $1 }' | awk -F\= '{ print $2 }')"

  if [ -n "$UNIXHOME" -a -n "$SCHOOL" ]; then

    # pivot local homedir to serverside homedir
    [ "$force_localhome" = "no" -a -d "$UNIXHOME" ] && export HOME="$UNIXHOME"
    cd "$HOME"

    SHAREFOLDER="$HOME/$share_folder"
    PGROUP="$(grep ^sophomorixAdminClass "$userinfo" | awk '{ print $2 }')"
    SROLE="$(grep ^sophomorixRole "$userinfo" | awk '{ print $2 }')"

    SCHOOLDIR="/srv/samba/schools/$SCHOOL"
    STUDENTHOMES="$SCHOOLDIR/students"
    SHAREDIR="$SCHOOLDIR/share"
    CLASSSHARES="$SHAREDIR/classes"
    TEACHERSHARE="$SHAREDIR/teachers"
    PROJECTSHARES="$SHAREDIR/projects"
    SCHOOLSHARE="$SHAREDIR/school"

  fi
  write2log "Userinfo ok"

fi
