#!/bin/bash
#
# thomas@linuxmuster.net
# 20181031
# login script for ad users
#

# read setup values
source /usr/share/linuxmuster-client-adsso/bin/readvars.sh || exit 1
ad_sysvol_path="/var/lib/samba/sysvol/$ad_domain"

# test ad connection
host "$servername.$ad_domain" | grep -q "$serverip" && ad_connected="yes"

# source login hookdir
if ls "$login_hookdir"/*.sh &> /dev/null; then
  for i in "$login_hookdir"/*.sh; do
    echo "Executing $i ..."
    source "$i"
  done
fi

# finally source serverside login script if present
loginscript="$ad_sysvol_path/scripts/linux/login.script"
if [ -e "$loginscript" ]; then
  echo "Sourcing login script $loginscript ..."
  echo
  source "$loginscript" || true
fi
