#!/bin/bash
##Set right permission for keystone directory
chown -R keystone:keystone /etc/keystone
chown -R keystone:keystone /var/log/keystone
chown keystone:keystone /usr/bin/keystone-wsgi-admin
chown keystone:keystone /usr/bin/keystone-wsgi-public
#Keystone DB Sync
su -s /bin/sh -c "keystone-manage db_sync" keystone
#Keystone token setup
su -s /bin/sh -c "keystone-manage fernet_setup --keystone-user keystone --keystone-group keystone"
su -s /bin/sh -c "keystone-manage credential_setup --keystone-user keystone --keystone-group keystone"
#Start apache process
rm -f /var/run/apache2/apache2.pid
/bin/bash -c "source /etc/apache2/envvars && exec /usr/sbin/apache2 -DFOREGROUND"
#End script