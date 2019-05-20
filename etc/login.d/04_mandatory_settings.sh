# Rainer Rössler (rainer@linuxmuster.net)
# Frank Schiebel (frank@linuxmuster.net)
# License: Free Software (GPLv3)


if [ -f /etc/linuxmuster-client/userprofile.conf ]; then 

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

            # no config exists on server:
	    # move and link
	    if [ ! -d $ziel ] && [ ! -f $ziel ]; then
		    if [ -d $lokal ] || [ -f $lokal ]; then
			    write2log "mv + ln: $lokal $ziel"
			    mv $lokal $ziel
			    ln -srf $ziel $lokal
		    fi
	    fi

            # config exists on server:
	    # remove local an link from server
	    if [ -d $ziel ] || [ -f $ziel ]; then
	            write2log "rm $lokal + ln to $ziel"
		    rm -rf ${lokal}.lmnbackup
		    [[ -e $lokal ]] && mv $lokal ${lokal}.lmnbackup
		    ln -srf $ziel $lokal
	    fi

	done < /etc/linuxmuster-client/userprofile.conf
else
	write2log "Config file /etc/linuxmuster-client/userprofile.conf not readable?"
fi
