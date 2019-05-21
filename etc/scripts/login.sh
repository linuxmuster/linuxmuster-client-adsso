#!/bin/bash
#
# thomas@linuxmuster.net
# 20181203
# login script for ad users
#

# read setup values
source /etc/linuxmuster-client/scripts/readvars.sh || exit 1
ad_sysvol_path="/var/lib/samba/sysvol/$ad_domain"


# hook function
function run_hook() {
    # source login hookdir
    if ls "$login_hookdir"/*.sh &> /dev/null; then
      for i in "$login_hookdir"/*.sh; do
        echo "Executing $i ..."
	source "$i"
      done
    fi
}

# test ad connection
host "$servername.$ad_domain" | grep -q "$serverip" && ad_connected="yes"

# run the scripts from the hookdir
run_hook

# finally source serverside login script if present
loginscript="$ad_sysvol_path/scripts/$SCHOOL/linux/login.script"
if [ -e "$loginscript" ]; then
  echo "Sourcing login script $loginscript ..."
  echo
  source "$loginscript" || true
fi
