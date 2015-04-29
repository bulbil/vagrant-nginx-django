#/usr/bin/env bash

INSTALL=(  "mysql-server"
           "php5-fpm"
           "php5-mysql"
      	   "nginx"
           "git" 
           "imagemagick" 
           "curl"
           "htop"
           "unzip" )

apt-get -y update

for i in "${INSTALL[@]}"
do

    echo "apt-get -y install ${i}"
    if [ "${i}" = "mysql-server" ]
    then
        echo " ******* set selections ******** "
        debconf-set-selections <<< 'mysql-server mysql-server/root_password password omekaDev'
        debconf-set-selections <<< 'mysql-server mysql-server/root_password_again password omekaDev'
    fi    
    apt-get -y install "${i}"
done

echo "sed **********************"
 sed -i s/\;cgi\.fix_pathinfo\s*\=\s*1/cgi.fix_pathinfo\=0/ /etc/php5/fpm/php.ini
 service php5-fpm restart

echo "nginx configure **********************"
 mv /etc/nginx/sites-available/default /etc/nginx/sites-available/default.bak
 cp /vagrant/default /etc/nginx/sites-available/default


echo "start services **********************"
 service nginx restart

echo "wget omeka"
 wget https://github.com/omeka/Omeka/archive/master.zip -P /vagrant/webroot/
 unzip /vagrant/webroot/master.zip -d /vagrant/webroot/
 mv /vagrant/webroot/Omeka-master/* /vagrant/webroot/
 rm -r /vagrant/webroot/Omeka-master
 rm /vagrant/webroot/db.ini.changeme
 cp /vagrant/db.ini /vagrant/webroot/
 rm /vagrant/webroot/application/config/config.ini.changeme
 cp /vagrant/config.ini /vagrant/webroot/application/config/
 mv /vagrant/webroot/application/config/logs/errors.log.empty /vagrant/webroot/application/config/logs/errors.log
 chmod -R 775 /vagrant/webroot/application/logs
 cp /vagrant/.htaccess /vagrant/webroot/

echo "mysql setup"
mysql -u root -pomekaDev --execute="CREATE DATABASE IF NOT EXISTS omeka CHARACTER SET utf8 COLLATE utf8_unicode_ci";
mysql -u root -pomekaDev --execute="GRANT ALL PRIVILEGES ON omeka.* TO 'omeka'@'localhost' IDENTIFIED BY 'omeka'";
