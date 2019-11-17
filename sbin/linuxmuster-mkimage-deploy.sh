#!/bin/bash

## SSS stuff
# this might break login for the image producer
# deletes all current cachefiles and domain-related files
systemctl stop sssd 
rm -rf /var/lib/samba/private/tls/*
rm -rf /var/log/sssd/*
rm -rf /var/lib/sss/pubconf/krb5.include.d/domain_realm*
rm -rf /var/lib/sss/db/cache_*
rm -rf /var/lib/sss/db/ccache_*
rm -rf /var/lib/sss/db/timestamps_*
rm -rf /var/lib/sss/pipes/private/*

