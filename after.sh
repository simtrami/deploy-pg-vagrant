#!/bin/sh -e

##
# © Copyright 2021 Clément Taverne (a.k.a. Simtrami)
##

DB_USER=vagrant
DB_PASSWORD=secret
DB_NAME=project

# Function copied from jackdb/pg-app-dev-vm then modified
# https://github.com/jackdb/pg-app-dev-vm/blob/master/Vagrant-setup/bootstrap.sh
print_db_usage() {
    echo "Your PostgreSQL database has been setup and can be accessed on your local machine on the forwarded port"
    echo "  Host: localhost"
    echo "  Port: 54321"
    echo "  Database: $DB_NAME"
    echo "  Username: $DB_USER"
    echo "  Password: $DB_PASSWORD"
    echo ""
    echo "Admin access to postgres user via VM:"
    echo "  vagrant ssh"
    echo "  sudo su - postgres"
    echo ""
    echo "psql access to app database user via VM:"
    echo "  vagrant ssh"
    echo "  sudo su - postgres"
    echo "  PGUSER=$DB_USER PGPASSWORD=$DB_PASSWORD psql -h localhost $DB_NAME"
    echo ""
    echo "Env variable for application development:"
    echo "  DATABASE_URL=postgresql://$DB_USER:$DB_PASSWORD@localhost:54321/$DB_NAME"
    echo ""
    echo "Local command to access the database via psql:"
    echo "  PGUSER=$DB_USER PGPASSWORD=$DB_PASSWORD psql -h localhost -p 54321 $DB_NAME"
}

PROVISIONED_ON=/etc/vm_provision_on_timestamp
if [ -f "$PROVISIONED_ON" ]
then
  echo "VM was already provisioned at: $(cat $PROVISIONED_ON)"
  echo "To run system updates manually login via 'vagrant ssh' and run 'apt update && apt upgrade'"
  echo ""
  print_db_usage
  exit
fi

# Script copied from creyesmirman/Vagrantfile then modified
# https://gist.github.com/creyesmirman/448c0d73eae518e7ab026bf5ba4f9040#file-vagrantfile
echo "-------------------- updating package lists"
apt-get update -y
echo "-------------------- installing postgres"
apt-get install postgresql-12 -y
# fix permissions
echo "-------------------- fixing listen_addresses on postgresql.conf"
sudo sed -i "s/#listen_address.*/listen_addresses '*'/" /etc/postgresql/12/main/postgresql.conf
echo "-------------------- fixing postgres pg_hba.conf file"
sudo cat >>/etc/postgresql/12/main/pg_hba.conf <<EOF
  # Accept all IPv4 connections - FOR DEVELOPMENT ONLY!!!
  host    all         all         0.0.0.0/0             md5
EOF
echo "-------------------- restarting so that all new config is loaded"
service postgresql restart
echo "-------------------- creating postgres $DB_USER role with password $DB_PASSWORD"
sudo su postgres -c "psql -c \"CREATE ROLE vagrant SUPERUSER LOGIN PASSWORD '$DB_PASSWORD'\" "
echo "-------------------- creating $DB_NAME database"
sudo su postgres -c "createdb -E UTF8 -T template0 --locale=en_US.utf8 -O $DB_USER $DB_NAME"
# Tag the provision time:
date > "$PROVISIONED_ON"
echo "-------------------- successfully created PostgreSQL dev virtual machine."
echo ""
print_db_usage
