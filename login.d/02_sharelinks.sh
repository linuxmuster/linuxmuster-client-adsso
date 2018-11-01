# create share links in documents folder
#
# thomas@linuxmuster.net
# 20181031
#

# only if SROLE was defined earlier
if [ -n "$SROLE" ]; then

  SHAREFOLDER="$HOME/$share_folder"
  mkdir -p "$SHAREFOLDER"
  ln -srf "$SCHOOLSHARE" "$SHAREFOLDER/$school_share"
  [ "$SROLE" = "student" ] && ln -srf "$CLASSSHARE" "$SHAREFOLDER"
  [ "$SROLE" = "teacher" ] && ln -srf "$TEACHERSHARE" "$SHAREFOLDER/$teachers_share"

fi
