# get user info from ad and save it in /tmp
#
# thomas@linuxmuster.net
# 20181031
#

if [ -n "$ad_connected" ]; then

  if [ $USER == $template_user ]; then 
    echo "Login as template user, no profile operations" >> /tmp/profile_exit
    unset https_proxy
    unset http_proxy
    unset ftp_proxy
    return
  fi 

  userinfo="/tmp/$USER"
  [ -e "$userinfo" ] && rm -f "$userinfo"

  date > "$userinfo"
  tmpuserinfo=`mktemp`
  # ad query
  ldbsearch -k yes -H ldaps://$servername.$ad_domain "(&(samaccountname=$USER))" | tee "$tmpuserinfo"
  OLDIFS=$IFS
  IFS=""  ## knock out field separator
  printline=""
  while read -r line; do
      if [ "${line:0:1}" != " " ]; then
	  echo $printline >> "$userinfo"
	  printline=$line
      else
	  ## concat all LDAP overfull lines
	  printline=$printline${line:1}
      fi
  done < "$tmpuserinfo"
  echo $printline >> "$userinfo" ## print last buffer
  echo $line >> "$userinfo" ## print last buffer, if file does not end with '\n'
  IFS=$OLDIFS ## restore Field separator
  rm -f $tmpuserinfo
  
  chown "$USER" "$userinfo"
  chmod 400 "$userinfo"

fi
