#/usr/bin/env bash

#ridiculously simple shell provisioning

# array of debian packages to install
APTGET_INSTALL=(  "nginx"
                  "git" 
                  "curl"
                  "htop"
                  "unzip"
                  "python-pip"
                  "python-dev")

# array of pip packages to install globally
PIP_INSTALL=( "virtualenv"
              "virtualenvwrapper"
              "uwsgi")

# array for virtual pip install
VENV_INSTALL=( "django" )

apt-get -y update
apt-get -y upgrade 

# install debian packages
for i in "${APTGET_INSTALL[@]}"
do

    echo "apt-get -y install ${i}"
    # for installing mysql set root pw
    if [ "${i}" = "mysql-server" ]
    then
        echo " ******* set selections ******** "
        debconf-set-selections <<< 'mysql-server mysql-server/root_password password djangoDev'
        debconf-set-selections <<< 'mysql-server mysql-server/root_password_again password djangoDev'
    fi    
    apt-get -y install "${i}"
done

# install pip stuff globally
for i in "${PIP_INSTALL[@]}"
do

    echo "pip install ${i}"
    pip install "${i}"
done

# setup django project
mkdir -p  /srv/apps/project

# nginx configure : link site config file with nginx folder structure
# echo "nginx configure **********************"
cp /vagrant/project /etc/nginx/sites-available/
ln -s /etc/nginx/sites-available/project /etc/nginx/sites-enabled/
cp /vagrant/uwsgi_params /etc/nginx/
cp /vagrant/project.ini /etc/uwsgi/sites/
cp /vagrant/uwsgi.conf /etc/init/

# echo "start services **********************"
#  service nginx restart
