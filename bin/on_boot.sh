#!/bin/bash
#
# do onboot stuff
#
# thomas@linuxmuster.net
# 20181031
#

# read setup values
source /usr/share/linuxmuster-client-adsso/bin/read_ini.sh || exit 1

if [ ! -s "$sssd_conf" ]; then
  echo "$sssd_conf does not exist or is not valid!"
  exit 1
fi

# test ad connection
host "$servername.$domainname" | grep -q "$serverip" && ad_connect="yes"

# if ad connection is present
if [ -n "$ad_connect" ]; then
  # switch sssd configuration to ad connected
  echo "Connected to ad server $servername.$domainname."
  # remove option if resent in config
  if grep -q ^"$homedir_option" "$sssd_conf"; then
    echo "Removing $homedir_option from $sssd_conf."
    sed -i "/^$homedir_option/ d" "$sssd_conf"
  fi
  # set proxy profile
  if [ -n "$proxy_profile" -a -n "$proxy_template" ]; then
    echo "Creating proxy environment."
    sed -e "s|@@network@@|$network|
            s|@@domainname@@|$ad_domain|
            s|@@proxy_url@@|$proxy_url|g" "$proxy_template" > "$proxy_profile"
  fi
else
  # local mode
  echo "Not connected to ad server $servername.$domainname!"
  # switch sssd configuration to local only
  if grep -q ^"$homedir_option" "$sssd_conf"; then
    echo "Changing $homedir_option to $homedir_value in $sssd_conf."
    sed -i "s|^$homedir_option .*|$homedir_option = $homedir_value|" "$sssd_conf"
  else
    echo "Adding \"$homedir_option = $homedir_value\" to $sssd_conf."
    echo "$homedir_option = $homedir_value" >> "$sssd_conf"
  fi
  # remove proxy environment
  if [ -n "$proxy_profile"]; then
    echo "Removing proxy environment."
    rm -f "$proxy_profile"
  fi
fi

exit 0
