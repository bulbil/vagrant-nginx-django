#/usr/bin/env bash

APTGET_INSTALL=(  "mysql-server"
      	          "nginx"
                  "git" 
                  "curl"
                  "htop"
                  "unzip" )

PIP_INSTALL=( "Django"
              "pillow"
              "uwsgi" )
           
apt-get -y update

for i in "${APTGET_INSTALL[@]}"
do

    echo "apt-get -y install ${i}"
    if [ "${i}" = "mysql-server" ]
    then
        echo " ******* set selections ******** "
        debconf-set-selections <<< 'mysql-server mysql-server/root_password password djangoDev'
        debconf-set-selections <<< 'mysql-server mysql-server/root_password_again password djangoDev'
    fi    
    apt-get -y install "${i}"
done

echo "sed **********************"
 sed -i s/\;cgi\.fix_pathinfo\s*\=\s*1/cgi.fix_pathinfo\=0/ /etc/php5/fpm/php.ini
 service php5-fpm restart

echo "nginx configure **********************"
 ln -s /vagrant/site.conf etc/nginx/sites-enabled/


echo "start services **********************"
 service nginx restart
