# Dieses Script verlinkt Konfigurationsdateien im Serverhome
# (unter Einstellungen) mit dem lokalen Home,
# in dem die Programme nach den Konfigurationen suchen.

# Rainer Rössler (roesslerrr-at-web.de)
# Frank Schiebel (frank@linuxmuster.net)
# License: Free Software (License GPLv3)

if [ -e $HOME/$link_homedir ]; then
  cd $HOME/$link_homedir

  if [ ! -d $server_settings ]; then
    mkdir $server_settings
  fi

fi
