#!/bin/sh

. /vagrant/vgresources/util.sh

cmd -x apt-get -qy install unzip openjdk-7-jre-headless 

# Set up TeamPostgreSQL
cd /srv
if status teampostgresql |grep -q running; then
    cmd -x stop teampostgresql
fi
TEAMPG_ZIP=teampostgresql_multiplatform.zip
if [ -f "/vagrant/$TEAMPG_ZIP" ]; then
    TEAMPG_ZIP="/vagrant/$TEAMPG_ZIP"
elif [ ! -f "$TEAMPG_ZIP" ]; then
    cmd -x wget -q -O "$TEAMPG_ZIP.tmp" \
        http://cdn.webworks.dk/download/teampostgresql_multiplatform.zip
    mv "$TEAMPG_ZIP.tmp" "$TEAMPG_ZIP"
fi
cmd -x unzip -u "$TEAMPG_ZIP"
cmd -x chmod +x teampostgresql/*.sh
cmd -x cp /vagrant/vgresources/teampostgresql.conf /etc/init
cmd -x cp /vagrant/vgresources/teampostgresql-config.xml /srv/teampostgresql/webapp/WEB-INF
cmd -x start teampostgresql
