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
  - `echo "export WORKON_HOME=/opt/venvs" >> ~/.bashrc`
  - `echo "source /usr/local/bin/virtualenvwrapper.sh" >> ~/.bashrc`
  - plus don't forget `-p` flag with `mkvirtualenv` to denote python3
- Remove link to default in `etc/nginx/sites-enabled/default`
- Unless specifically configured, Vagrantfile only points traffic from guest port 80 -- so any debugging using other ports won't forward
