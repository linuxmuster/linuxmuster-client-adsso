# get user info from ad and save it in /tmp
#
# thomas@linuxmuster.net
# 20181031
#

if [ -n "$ad_connected" ]; then

  userinfo="/tmp/$USER"
  [ -e "$userinfo" ] && rm -f "$userinfo"

  date > "$userinfo"

  # ad query
  ldbsearch -k yes -H ldaps://$servername.$ad_domain "(&(samaccountname=$USER))" | tee "$userinfo"
  chown "$USER" "$userinfo"
  chmod 400 "$userinfo"

fi
