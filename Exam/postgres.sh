#!/bin/bash -ex

echo "Creating variables for installation"
init_packages=('git' 'gcc' 'tar' 'gzip' 'libreadline5' 'make' 'zlib1g' 'zlib1g-dev' 'flex' 'bison' 'perl' 'python3' 'tcl' 'gettext' 'odbc-postgresql' 'libreadline6-dev')
instal_dir='/postgres'
d_dir='/postgres/data'
psql_repo='git://git.postgresql.org/git/postgresql.git'
sysuser='postgres'
laravalscript='laravel.sql'
logfile='psqlinstall-log'


echo "Updating server..."
sudo apt-get update -y >> $logfile

echo "Installing PostgreSQL dependencies"
sudo apt-get install ${init_packages[@]} -y >> $logfile

echo "Installing PostgreSQL packages"
sudo apt install postgresql postgresql-contrib

echo "Start services"
sudo systemctl start postgresql.service

echo "create user"
sudo -u postgres createuser --ubuntu -y

echo "create db"
sudo -u postgres createdb ubuntu

echo "connect to db"
sudo -u ubuntu psql







