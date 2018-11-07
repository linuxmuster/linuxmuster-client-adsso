# linuxmuster-client-adsso
---
Scripts and configuration for ubuntu clients to connect to the linuxmuster.net 7 active directory server.
---
Konfigurationsskripte zur Anbindung von Ubuntu-Clients an den linuxmuster.net 7 Server.

Features:
- Domänenanmeldung mit Single-Sign-On mit transparenter Proxy-Authentifizierung.
- Automatisches Einbinden des Server-Homeverzeichnisses.
- Verlinkung der Tauschverzeichnisse im Home.
- Link zu den Schülerhomes im Home der Lehrkräfte.
- Passwort-Caching/Offline-Anmeldung.

Läuft mit:
- Ubuntu 18.04
  - Dateimanager Nautilus kommt mit serverseitigen Links nicht klar.
  - Abhilfe: Stattdessen Nemo verwenden.
- Kubuntu 18.04
  - Windowmanager _sddm_ inkompatibel, Workaround:
  - _lightdm_ als Alternative installieren:
    - `# apt install lightdm slick-greeter --no-install-recommends`
    - in `/etc/lightdm/lightdm.d/50-linuxmuster.conf` _user-session_ Zeile aktivieren
- Xubuntu 18.04
- Ubuntu Mate Edition 18.04
- Lubuntu 18.10
  - Windowmanager _sddm_ muss wie bei Kubuntu durch _lightdm_ ersetzt werden.  
Generell sollten alle Ubuntu-Derivate der Versionen 18.04/18.10 unterstützt werden (Ausnahme: _Linuxmint_).

Technische Infos (s. https://help.ubuntu.com/lts/serverguide/sssd-ad.html):
- Setup richtet alle Dienste ein, die für Single-Sign-On benötigt werden:
  - samba: `/etc/samba/smb.conf`
  - sssd: `/etc/sssd/sssd.conf`
  - krb5.user: `/etc/krb5.conf`
  - keyutils: `/etc/request-key.d/cifs.spnego.conf`
  - pam_mount: `/etc/security/pam_mount.conf.xml`
  - chrony: `/etc/chrony/chrony.conf`
- Domänenanmeldung über Kerberosticket:
  - `# kinit global-admin`
  - `# net ads join --no-dns-updates`
- Serverhome des Users und Samba-Sysvol-Verzeichnis werden bei Domänenanmeldung per pam_mount eingebunden:
  - `/var/lib/samba/sysvol`
  - `/srv/samba/schools/default-school`
- Serverzertifikat wird nach `/var/lib/samba/private/tls` kopiert und von Samba eingebunden.
- Ein Onboot-Systemd-Event, der u.a. die Proxy-Umgebungsvariable setzt (s.u.), ist in `/etc/systemd/system/linuxmuster-client-adsso.service` definiert.

Installation (mit Netzwerkverbindung zum lmn7-Server):
- linuxmuster.net-Repo einbinden:
  - `# wget http://fleischsalat.linuxmuster.org/repo.key -O - | apt-key add -`
  - `# echo 'deb http://fleischsalat.linuxmuster.org/bionic/ ./' > /etc/apt/sources.list.d/lmn.list`
  - `# apt update`
- Paket installieren:
  - `# apt install linuxmuster-client-adsso`
  - Frage nach "Voreingestellter Realm für Kerberos Version 5" einfach mit [ENTER] beantworten.
- Setup mit Befehl:
  - `# linuxmuster-client-adsso-setup`
  - Für die Domänenanmeldung muss im Verlauf des Skripts das Passwort des _global-admin_ eingegeben werden.
  - Anschließend den Client neu starten.
- Installation kann per Linbo-Image auf andere Clients ausgerollt werden.

Praxis:
- Der Onboot-Systemd-Service ruft das Skript `/usr/share/linuxmuster-client-adsso/bin/onboot.sh` auf, das etwaige weitere Skripte einliest, die unter `/var/lib/linuxmuster-client-adsso/onboot.d` abgelegt sind (z.B. Linbo-Postsync-Skripte).
- Besteht beim Bootvorgang Verbindung zum lmn7-Server, wird über `/etc/profile.d/linuxmuster-proxy.sh` die entsprechende Umgebungsvariable für den Proxy gesetzt. Umgekehrt wird bei Offline-Boot bzw. ohne Verbindung zum Server kein Proxy gesetzt.
- Falls bei Serververbindung ein abweichender oder kein Proxy benutzt werden soll, kann das in `/etc/linuxmuster-client-adsso.conf` über die Variable `proxy_url` angepasst werden.
- Nach der Anmeldung an der Domäne findet der User die gesamte Schulfreigabe samt Home unter `/srv/samba/schools/default-school` eingehängt.
- Die Sysvol-Freigabe des Servers ist unter `/var/lib/samba/sysvol` eingehängt.
- Beim Anmeldevorgang wird das Skript `/usr/share/linuxmuster-client-adsso/bin/login.sh` aufgerufen, das wiederum die Skripte unter `/var/lib/linuxmuster-client-adsso/login.d` einliest.
- Eigene Skripte können dort zusätzlich oder anstatt der vom Paket installierten abgelegt werden.
- Ist auf dem Server ein Skript unter `/var/lib/samba/sysvol/scripts/linux/login.script` abgelegt, wird das nach den lokalen Loginskripten eingelesen.
- In der Konfigurationsdatei `/etc/linuxmuster-client-adsso.conf` können in der Sektion `[names]` die Namen der vom Loginskript angelegten Links angepasst werden.
- Bei der ersten Domänenanmeldung eines Users wird dessen Passworthash lokal gespeichert, sodass er sich danach auch offline bzw. ohne Verbindung zum lmn7-Server lokal anmelden kann. In dem Fall befindet sich sein Homeverzeichnis unter `/home/<username>`.
-

ToDo:
- Automatik, um dem User ein Defaultprofil zu verpassen.
- Könnte man z. Bsp. auf dem Server unter `/var/lib/samba/sysvol/profile/linux/` ablegen und beim Anmelden von dort einlesen. Dann müsste man bei einer Profiländerung kein Image erzeugen und ausrollen.
- Wäre eine zu vergebende Aufgabe.
