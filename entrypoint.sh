#!/bin/sh

set -e

export LC_ALL=C
export PYTHONPATH=/kolekti/src:/kolekti/src/kolekti_server

cp /kolekti/src/kolekti_server/kolekti.ini /etc

python /kolekti/src/kolekti_server/manage.py syncdb --noinput

gunicorn -b 0.0.0.0:8000 --pythonpath /kolekti/src --chdir /kolekti/src/kolekti_server kolekti_server.wsgi
