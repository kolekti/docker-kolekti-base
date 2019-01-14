#!/bin/sh

set -e

if [ -z "$UID" ] ; then
  UID=0
fi

[ -e /var/log/kolekti ] && chown -R ${UID}:${GID} /var/log/kolekti
[ -e /projects ]        && chown -R ${UID}:${GID} /projects
[ -e /svn ]             && chown -R ${UID}:${GID} /svn 
[ -e /static ]          && chown -R ${UID}:${GID} /static
[ -e /db ]              && chown -R ${UID}:${GID} /db

export LD_LIBRARY_PATH=/usr/local/lib

cd /kolekti/src/kolekti_server
sudo -E -H -u \#${UID} PYTHONPATH=/kolekti/src:/kolekti/src/kolekti_server python /kolekti/src/kolekti_server/manage.py migrate --noinput
sudo -E -H -u \#${UID} PYTHONPATH=/kolekti/src:/kolekti/src/kolekti_server python /kolekti/src/kolekti_server/manage.py collectstatic --noinput

gunicorn -b 0.0.0.0:8000 --pythonpath /kolekti/src --chdir /kolekti/src/kolekti_server --user=${UID} ${GUNICORN_OPTS} kolekti_server.wsgi
