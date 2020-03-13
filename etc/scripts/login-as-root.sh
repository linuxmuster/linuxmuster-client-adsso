#!/bin/bash
#
#
# t.kuechel@humboldt-ka.de
# 20191006
# login script for AD users, executed in root context from pam_exec
#

logger "login-as-root.sh: $PAM_RHOST $PAM_RUSER $PAM_SERVICE $PAM_TTY $PAM_USER $PAM_TYPE"
USER=$PAM_USER

##
## execute only, when login happens
##
if [ "$PAM_TYPE" != "open_session" ]; then
    return 0 ## if sourced
    exit 0   ## if executed
fi

# read setup values
source /etc/linuxmuster-client/scripts/readvars.sh || exit 1
ad_sysvol_path="/var/lib/samba/sysvol/$ad_domain"

# hook function
function run_hook() {
    # source login hookdir
    if ls "$login_as_root_hookdir"/*.sh &> /dev/null; then
      for i in "$login_as_root_hookdir"/*.sh; do
        echo "Executing $i ..."
        source "$i"
      done
    fi
}

# run the scripts from the hookdir
run_hook

# finally source serverside login script if present
loginscript="$ad_sysvol_path/scripts/$SCHOOL/linux/login-as-root.script"
if [ -e "$loginscript" ]; then
  echo "Sourcing login script $loginscript ..."
  echo
  source "$loginscript" || true
fi
