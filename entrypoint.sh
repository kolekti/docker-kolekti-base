#!/bin/sh

set -e

export LC_ALL=C
export PYTHONPATH=/kolekti/src:/kolekti/src/kolekti_server

cp /kolekti/src/kolekti_server/kolekti.ini /etc

python /kolekti/src/kolekti_server/manage.py syncdb --noinput

/usr/sbin/apache2ctl -D FOREGROUND
