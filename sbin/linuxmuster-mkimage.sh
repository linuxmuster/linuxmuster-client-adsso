#!/bin/bash

# update
unset http_proxy https_proxy
apt update
apt full-upgrade -y
# clean up apt
apt autoremove -y
apt autoclean
apt clean
# var lists löschen
rm /var/lib/apt/lists/*  || true
# java reste löschen, falls vorhanden
rm /var/cache/oracle-jdk*-installer/jdk*.tar.gz || true

users=$(who | grep -v ^root)
if [ -n "$users" ]; then
    echo "Hey, da ist noch jemand eingeloggt, bitte ausloggen und $0 neu starten!"
    echo $user
    exit 1
fi
    
rm -rf /home/cache/*

echo "Wenn du möchtest starte linuxmuster-client-adsso-setup, um die domänenaufnahme zu erneuern. Das ist nicht zwingend."
echo "Dann: neustarten, create_cloop, upload_cloop"
