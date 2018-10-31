# /etc/profile.d/linuxmuster-proxy.sh
#
# thomas@linuxmuster.net
# 20181031
# sets proxy environment variables
#

no_proxy=localhost,127.0.0.0/8,*.local,@@network@@,*.@@domainname@@
http_proxy=@@proxy_url@@
ftp_proxy=@@proxy_url@@
https_proxy=@@proxy_url@@
