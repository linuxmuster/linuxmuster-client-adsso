#!/bin/bash
#
# do onboot stuff
#
# thomas@linuxmuster.net
# 20181103
#

# read setup values
source /usr/share/linuxmuster-client-adsso/bin/readvars.sh || exit 1

if [ ! -s "$sssd_conf" ]; then
  echo "$sssd_conf does not exist or is not valid!"
  exit 1
fi

# test ad connection
host "$servername.$ad_domain" | grep -q "$serverip" && ad_connected="yes"

# if ad connection is present
if [ -n "$ad_connected" ]; then
  # switch sssd configuration to ad connected
  echo "Connected to ad server $servername.$ad_domain."
  # set proxy profile
  if [ -n "$proxy_url" -a -n "$proxy_profile" -a -n "$proxy_template" ]; then
    echo "Creating proxy environment."
    sed -e "s|@@network@@|$network|
            s|@@domainname@@|$ad_domain|
            s|@@proxy_url@@|$proxy_url|g" "$proxy_template" > "$proxy_profile"
  fi
else
  # local mode
  echo "Not connected to ad server $servername.$ad_domain!"
  # remove proxy environment
  if [ -n "$proxy_profile"]; then
    echo "Removing proxy environment."
    rm -f "$proxy_profile"
  fi
fi

# source onboot hookdir
if ls "$onboot_hookdir"/*.sh &> /dev/null; then
  echo "Sourcing onboot hookdir:"
  for i in "$onboot_hookdir"/*.sh; do
    echo "* $(basename $i) ..."
    source "$i"
  done
fi

exit 0
