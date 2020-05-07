#!/bin/bash
#
# thomas@linuxmuster.net
# 20181203
# logout script for ad users
#


# read setup values
source /etc/linuxmuster-client/scripts/readvars.sh || exit 1
ad_sysvol_path="/var/lib/samba/sysvol/$ad_domain"

logger -t linuxmuster-client "logout.sh executed"


# hook function
function run_hook() {
    # source logout hookdir
    if ls "$logout_hookdir"/*.sh &> /dev/null; then
	for i in "$logout_hookdir"/*.sh; do
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
logoutscript="$ad_sysvol_path/scripts/$SCHOOL/lmn/linux/logout.script"
if [ -e "$logoutscript" ]; then
    echo "Sourcing logout script $logoutscript ..."
    echo
    source "$logoutscript" || true
fi

