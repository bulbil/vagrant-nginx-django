### Test LEMP Stack for Local Django development

Takes <https://github.com/michaelck/puppet-lamp-stack-for-omeka> and makes it stupider -- only shell provisioning so far.

Relied on the following online tutorials:

- [Django Applications with uWSGI and Nginx, Justin Ellingwood](https://www.digitalocean.com/community/tutorials/how-to-serve-django-applications-with-uwsgi-and-nginx-on-ubuntu-14-04)
- [Setting up Nginx + Django + uWSGI, Richard O'Dwyer](http://blog.richard.do/index.php/2013/04/setting-up-nginx-django-uwsgi-a-tutorial-that-actually-works/)
- [uWSGI's readthedocs on Setting up Django and your web server with uWSGI and nginx](http://uwsgi-docs.readthedocs.org/en/latest/tutorials/Django_and_nginx.html)

### Notes:

- This setup relies on a few assumptions:
  - uWSGI is pip-installed globally while all other packages are pip-installed into virtualenvs
  - Python3 configuration: `echo "export VIRTUALENVWRAPPER_PYTHON=/usr/bin/python3`
  - `echo "export WORKON_HOME=~/venvs" >> ~/.bashrc`
  - `echo "source /usr/local/bin/virtualenvwrapper.sh" >> ~/.bashrc`
  - *YOU CANT USE PYTHON 3 unless uwsgi for python 3 installed globally! (hard won knowledge)*
  - (maybe try `python3 -m pip install uwsgi` in bootstrap.sh instead)
- Remove link to default in `etc/nginx/sites-enabled/default`
- Unless specifically configured, Vagrantfile only points traffic from guest port 80 -- so any debugging using other ports won't forward

Steps once vagrant is up:
- modify bashrc
- `mkvirtualenv --no-site-packages -i django -i <others> -p python3 <project>`
- `cd /srv/apps/<project>` & `django-admin.py startproject <project> [existing path]`
- `mkdir /srv/apps/<project>/static`
- `settings.py` 17:`STATIC_ROOT=os.path.join(BASE_DIR,'static')`
- `./manage.py migrate`
- `./manage.py collectstatic`
