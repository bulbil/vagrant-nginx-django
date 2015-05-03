#/usr/bin/env bash

# ridiculously simple shell provisioning

# project name
PROJECT="iceland"

# array of debian packages to install
APTGET_INSTALL=(  "nginx"
                  "git" 
                  "curl"
                  "htop"
                  "unzip"
                  "python3-pip"
                  "python3-dev"
                  "libpq-dev"
                  "postgresql"
                  "postgresql-contrib" )

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
    python3 -m pip install "${i}"
done

# virtualenv configure
mkdir /usr/local/lib/venvs
chown -R vagrant:vagrant /usr/local/lib/venvs

# nginx configure : link site config file with nginx folder structure
echo "nginx/uwsgi configure **********************"
cp /vagrant/files/$PROJECT-nginx /etc/nginx/sites-available/$PROJECT
ln -s /etc/nginx/sites-available/$PROJECT /etc/nginx/sites-enabled/
cp /vagrant/files/uwsgi_params /srv/apps/$PROJECT

# uwsgi configure
mkdir -p /etc/uwsgi/sites
cp /vagrant/files/$PROJECT.ini /etc/uwsgi/sites/
cp /vagrant/files/uwsgi.conf /etc/init/
mkdir -p /run/uwsgi/app/$PROJECT
chown -R www-data:www-data /run/uwsgi/app

echo "export VIRTUALENVWRAPPER_PYTHON=/usr/bin/python3" >> /home/vagrant/.bashrc
echo "export WORKON_HOME=/usr/local/lib/venvs" >> /home/vagrant/.bashrc
echo "source /usr/local/bin/virtualenvwrapper.sh" >> /home/vagrant/.bashrc
source /home/vagrant/.bashrc

# echo "start services **********************"
#  service nginx restart
