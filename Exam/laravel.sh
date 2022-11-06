#!/bin/bash -ex

laravel_repo='https://github.com/f1amy/laravel-realworld-example-app.git'

echo "Pull laravel sample from $laravel_repo"
git clone $laravel_repo 

sudo mv laravel-realworld-example-app myapp
cd myapp
composer install
sudo mv myapp /var/www/html
sudo chown -R www-data:www-data /var/www/html/myapp
sudo chmod -R 775 /var/www/html/myapp/storage
