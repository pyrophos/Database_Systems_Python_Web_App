#!/bin/sh

. /vagrant/vgresources/util.sh

# Upgrade packages and install needed software
export DEBCONF_FRONTEND=noninteractive
cmd -x apt-get update
cmd -x apt-get -qy upgrade
cmd -x apt-get -qy install postgresql oidentd
cmd -x apt-get -qy install python-virtualenv python-psycopg2 python-pip python-flask python-bcrypt
cmd -x apt-get -qy install ipython vim-nox

# Set up PostgreSQL authentication
PG_CONF=/etc/postgresql/9.3/main
cmd cp /vagrant/vgresources/pg_ident.conf $PG_CONF/pg_ident.conf
cmd cp /vagrant/vgresources/pg_hba.conf $PG_CONF/pg_hba.conf
cmd sed -i -e "s/^#listen_addresses = '.*'/listen_addresses = '*'/" $PG_CONF/postgresql.conf
cmd /etc/init.d/postgresql restart
cmd -x sudo -u postgres psql <<EOF
DROP DATABASE IF EXISTS scratch;
CREATE DATABASE scratch;
ALTER ROLE postgres PASSWORD 'cs4332';
EOF

