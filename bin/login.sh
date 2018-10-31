#!/bin/bash
#
# thomas@linuxmuster.net
# 20181031
# login script for ad users
#

# read setup values
source /usr/share/linuxmuster-client-adsso/bin/read_ini.sh || exit 1

# test if ad login was successfull if not leave
host "$servername.$domainname" | grep -q "$serverip" || exit 0

# sysvol path
ad_sysvol_path="/var/lib/samba/sysvol/$ad_domain"
if [ ! -d "$ad_sysvol_path" ]; then
  echo "$ad_domain is not the ad domain!"
  exit 0
fi

# invoke serverside login script if present
loginscript="$ad_sysvol_path/scripts/linux/login.script"
if [ -x "$loginscript" ]; then
  echo "Invoking login script $loginscript ..."
  echo
  "$loginscript" || true
fi
