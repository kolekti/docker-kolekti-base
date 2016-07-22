FROM debian:jessie

env APACHE_RUN_USER    www-data
env APACHE_RUN_GROUP   www-data
env APACHE_PID_FILE    /var/run/apache2.pid
env APACHE_RUN_DIR     /var/run/apache2
env APACHE_LOCK_DIR    /var/lock/apache2
env APACHE_LOG_DIR     /var/log/apache2
env LANG               C

RUN apt-get update && apt-get install -y \
      apache2-mpm-worker         \
      libapache2-mod-wsgi        \
      libapache2-svn             \
      python-bootstrapform       \
      python-django              \
      python-django-registration \
      python-lxml                \
      python-pil                 \
      python-pip                 \
      python-pypdf2              \
      python-sparqlwrapper       \
      python-svn                 \
      python-whoosh              \
    && rm -rf /var/lib/apt/lists/*

RUN pip install pygal

ADD entrypoint.sh /
ADD kolekti.ini /etc/kolekti.ini

ADD kolekti.conf /etc/apache2/conf-available/kolekti.conf
RUN a2enconf kolekti

CMD /entrypoint.sh

EXPOSE 80
EXPOSE 443
