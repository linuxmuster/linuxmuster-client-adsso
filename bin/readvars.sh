# read_ini.sh
#
# thomas@linuxmuster.net
# GPL v3
# 20181031
#
# sources setup values for shell scripts

# read setup values
SETUPINI="/etc/linuxmuster-client-adsso.conf"
if [ -e "$SETUPINI" ]; then
 eval "$(grep ^[a-z] "$SETUPINI" | sed 's| = |="|g' | awk -F\# '{ print $1 }' | sed 's/[[:space:]]*$//' | sed 's|$|"|g')"
fi
