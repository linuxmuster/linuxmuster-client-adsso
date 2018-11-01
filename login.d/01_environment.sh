# create user environment
#
# thomas@linuxmuster.net
# 20181031
#

if [ -s "$userinfo" ]; then

  UNIXHOME="$(grep ^unixHomeDirectory "$userinfo" | awk '{ print $2 }')"
  SCHOOL="$(grep ^sophomorixSchoolname "$userinfo" | awk '{ print $2 }')"

  if [ -n "$UNIXHOME" -a -n "$SCHOOL" ]; then

    PGROUP="$(grep ^sophomorixAdminClass "$userinfo" | awk '{ print $2 }')"
    SROLE="$(grep ^sophomorixRole "$userinfo" | awk '{ print $2 }')"

    SCHOOLDIR="/srv/samba/schools/$SCHOOL"
    SHAREDIR="$SCHOOLDIR/share"
    CLASSSHARES="$SHAREDIR/classes"
    CLASSSHARE="$CLASSSHARES/$PGROUP"
    TEACHERSHARE="$SHAREDIR/teachers"
    PROJECTSHARES="$SHAREDIR/projects"
    SCHOOLSHARE="$SHAREDIR/school"

  fi

fi
