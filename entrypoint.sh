#!/bin/sh

set -e

PYTHONPATH=/kolekti/src:/kolekti/src/kolekti_server python /kolekti/src/kolekti_server/manage.py syncdb --noinput

if [ -z "$UID" ] ; then
  UID=0
fi

gunicorn -b 0.0.0.0:8000 --pythonpath /kolekti/src --chdir /kolekti/src/kolekti_server --user=${UID} ${GUNICORN_OPTS} kolekti_server.wsgi
