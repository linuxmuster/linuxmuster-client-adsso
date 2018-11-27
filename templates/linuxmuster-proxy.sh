# /etc/profile.d/linuxmuster-proxy.sh
#
# thomas@linuxmuster.net
# 20181127
# sets proxy environment variables
#

export no_proxy=127.0.0.0/8,10.0.0.0/8,192.168.0.0/16,172.16.0.0/12,localhost,.local,.@@domainname@@
export http_proxy=@@proxy_url@@
export ftp_proxy=@@proxy_url@@
export https_proxy=@@proxy_url@@
