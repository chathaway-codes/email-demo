#!/bin/bash

# Configuration source: http://flurdy.com/docs/postfix/#install


echo "Installing packages..."

export DEBIAN_FRONTEND=noninteractive

echo "--> sudo apt-get update"
sudo apt-get update
echo "--> sudo apt-get upgrade"
sudo apt-get -y upgrade

echo "--> sudo apt-get install mysql-client mysql-server"
echo "mysql-server-5.6 mysql-server/root_password password " | sudo debconf-set-selections
echo "mysql-server-5.6 mysql-server/root_password_again password " | sudo debconf-set-selections 
echo "mysql-server-5.5  mysql-server/root_password_again    password" | sudo debconf-set-selections
echo "mysql-server-5.5  mysql-server/root_password  password" | sudo debconf-set-selections
sudo apt-get -y install mysql-client mysql-server

echo "--> sudo apt-get install postfix postfix-mysql"
echo "postfix postfix/mailname string localhost" | sudo debconf-set-selections
echo "postfix postfix/main_mailer_type string 'Internet Site'" | sudo debconf-set-selections
sudo apt-get -y install postfix postfix-mysql

echo "--> sudo apt-get install courier-base courier-authdaemon courier-authlib-mysql courier-imap courier-imap-ssl courier-ssl"
echo "courier-ssl   courier-ssl/certnotice  note" | sudo debconf-set-selections
echo "courier-base  courier-base/webadmin-configmode    boolean false" | sudo debconf-set-selections
sudo apt-get -y install courier-base courier-authdaemon courier-authlib-mysql courier-imap courier-imap-ssl courier-ssl

echo "--> sudo apt-get install roundcube roundcube-mysql roundcube-plugins"
echo "roundcube-core    roundcube/database-type select  mysql" | sudo debconf-set-selections
echo "roundcube-core    roundcube/dbconfig-install  boolean true" | sudo debconf-set-selections
echo "roundcube-core    roundcube/mysql/admin-pass  password" | sudo debconf-set-selections
echo "roundcube-core    roundcube/app-password-confirm  password" | sudo debconf-set-selections
sudo apt-get -y install roundcube roundcube-mysql roundcube-plugins

echo "Configuring things..."

echo "--> Configuring database..."
cat /vagrant/database.sql | mysql -u root

# Enable networking on MySQL...
# -> The latest my.cnf enables networking by default

echo "--> Configuring Postfix"
echo "localhost" | sudo tee /etc/mailname
sudo cp /vagrant/etc/postfix/* /etc/postfix/
sudo cp /etc/aliases /etc/postfix/aliases
sudo postalias /etc/postfix/aliases

sudo mkdir /var/spool/mail/virtual 
sudo groupadd --system virtual -g 5000 
sudo useradd --system virtual -u 5000 -g 5000 
sudo chown -R virtual:virtual /var/spool/mail/virtual

echo "--> Configuring courier"
sudo cp /vagrant/etc/courier/* /etc/courier/

echo "--> Configuring roundcube"
sudo cp /vagrant/etc/roundcube/* /etc/roundcube/
sudo ln -s /etc/php5/mods-available/mcrypt.ini /etc/php5/apache2/conf.d/20-mcrypt.ini


echo "Restarting services..."
echo "--> sudo /etc/init.d/mysql restart"
sudo /etc/init.d/mysql restart
echo "--> sudo /etc/init.d/courier-imap restart"
sudo /etc/init.d/courier-imap restart
echo "--> sudo /etc/init.d/postfix restart"
sudo /etc/init.d/postfix restart
echo "--> sudo /etc/init.d/apache2 restart"
sudo /etc/init.d/apache2 restart
