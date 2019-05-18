# Rainer Rössler (roesslerrr-at-web.de)
# Frank Schiebel (frank@linuxmuster.net)
# License: Free Software (License GPLv3)


if [ -f /etc/linuxmuster-client/allowed_userprofile.conf ]; then 

while read line
	do
	    cd $HOME

	    [[ "$line" =~ ^#.*$ ]] && continue
	    [[ ! "$line" =~ ^.*:.*$ ]] && continue

	    ziel=$(echo $line | cut -d: -f 2)
	    lokal=$(echo $line | cut -d: -f 1)

            [[ "$ziel" =~ ^.*:.*$ ]] && continue
            [[ "$lokal" =~ ^.*:.*$ ]] && continue

	    # make paths absolute
	    ziel=$HOME/$link_homedir/$server_settings/$ziel
            lokal=$HOME/$lokal

            # config exists on server:
	    # remove local an link from server
	    if [ -d $ziel ] || [ -f $ziel ]; then
	            write2log "Allowed: rm $lokal + ln to $ziel"
		    rm -rf ${lokal}.lmnbackup
		    [[ -e $lokal ]] && mv $lokal ${lokal}.lmnbackup
		    ln -srf $ziel $lokal
	    fi

	done < /etc/linuxmuster-client/allowed_userprofile.conf
else
	write2log "Config file /etc/linuxmuster-client/allowed_userprofile.conf not readable?"
fi
