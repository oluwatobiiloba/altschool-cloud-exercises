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


echo "Creating folders $d_dir..."
sudo mkdir -p $d_dir >> $logfile


echo "Creating system user '$sysuser'"
sudo adduser --system $sysuser >> $logfile


echo "Pull postgreSQL from $psql_repo"
git clone $psql_repo >> $logfile


echo "Configuring PostgreSQL"
~/postgresql/configure --prefix=$instal_dir --datarootdir=$d_dir >> $logfile

echo "Making PostgreSQL"
make >> $logfile

echo "installing PostgreSQL"
sudo make install >> $logfile

echo "Giving system user '$sysuser' control over the $d_dir folder"
sudo chown postgres $d_dir >> $logfile

echo "Running initdb"
sudo -u postgres $instal_dir/bin/initdb -D $d_dir/db >> $logfile


echo "Starting PostgreSQL"
sudo -u postgres $instal_dir/bin/pg_ctl -D $d_dir/db -l $d_dir/logfilePSQL start >> $logfile


echo "Set PostgreSQL to launch on startup"
sudo sed -i '$isudo -u postgres /postgres/bin/pg_ctl -D /postgres/data/db -l /postgres/data/logfilePSQL start' /etc/rc.local >> $logfile

echo "Writing PostgreSQL environment variables to /etc/profile"
cat << EOL | sudo tee -a /etc/profile
# PostgreSQL Environment Variables
LD_LIBRARY_PATH=/postgres/lib
export LD_LIBRARY_PATH
PATH=/postgres/bin:$PATH
export PATH
EOL


echo "Wait for PostgreSQL to finish starting up..."
sleep 5

echo "Running script"
$instal_dir/bin/psql -U postgres -f $laravalscript

