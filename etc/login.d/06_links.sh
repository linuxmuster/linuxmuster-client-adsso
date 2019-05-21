#!/bin/bash
# Frank Schiebel <frank@linuxmuster.net>
# License: Free Software (License GPLv3)

# Dieses Script erstellt Links nach den Einstellungen unter 
# /etc/linuxmuster-client/shares/links.conf
# dabei werden die Einträge vor dem Doppelpunkt als Ziel = Quelle angenommen 
# und Einträge nach dem Doppelpunkt als symbolischer Link 
# HOMEDIR bezeichnet das lokale Heimatverzeichnis

UNIXHOME=/srv/samba/schools/default-school/teachers/de

if [ -f /etc/linuxmuster-client/links.conf ]; then 

while read line
        do
	    [[ "$line" =~ ^#.*$ ]] && continue
    	    [[ ! "$line" =~ ^.*:.*$ ]] && continue

            linkname=$(echo $line | cut -d: -f 1)
	    linkziel=$(echo $line | cut -d: -f 2)
	    action=$(echo $line | cut -d: -f 3)
	    [[ "x$action" == "x" ]] && action="none"

            [[ "$linkname" =~ ^.*:.*$ ]] && continue
            [[ "$linkziel" =~ ^.*:.*$ ]] && continue
	    
	    # substitute HOMEDIR with $HOME
	    linkname=$(echo $linkname | sed "s#HOMEDIR#$HOME#g") 
	    linkziel=$(echo $linkziel | sed "s#HOMEDIR#$HOME#g") 
	    # substitute SERVERHOME with $UNIXHOME
	    linkname=$(echo $linkname | sed "s#SERVERHOME#$UNIXHOME#g") 
	    linkziel=$(echo $linkziel | sed "s#SERVERHOME#$UNIXHOME#g") 
	    # substitute USERNAME with $USER
	    linkname=$(echo $linkname | sed "s#USERNAME#$USER#g") 
	    linkziel=$(echo $linkziel | sed "s#USERNAME#$USER#g") 


 	    
	    # Wenn Ziel auf Server NICHT vorhanden, 
 	    # (weder als Verzeichnis -d noch als Datei -f)
 	    # aber als action ist "dir" oder "file" angegeben, 
	    # wird das Ziel erzeugt

	    if [ ! -f $linkziel ] && [ ! -d $linkziel ] && [ $action == "createdir" ]; then 
		    mkdir -p $linkziel
	    fi

	    if [ ! -f $linkziel ] && [ ! -d $linkziel ] && [ $action == "createfile" ]; then 
		    touch $linkziel
	    fi

	    if [ -f $linkziel ] || [ -d $linkziel ]; then 
	    	    echo "Linking $linkziel to $linkname"
		    [[ -L $linkname ]] && rm $linkname
		    [[ -d $linkname ]] && mv $linkname ${linkname}-entfernt
		    [[ -f $linkname ]] && mv $linkname ${linkname}-entfernt
		    [[ -r $linkziel ]] && ln -sf $linkziel $linkname
	    fi

	done < /etc/linuxmuster-client/links.conf
else
        write2log "Config file /etc/linuxmuster-client/links.conf not readable?"
fi
