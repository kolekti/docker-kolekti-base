#!/bin/sh

set -e

export LC_ALL=C
export PYTHONPATH=/eLocus/src:/eLocus/src/kolekti_server

cp /eLocus/src/kolekti_server/kolekti.ini /etc

python eLocus/src/kolekti_server/manage.py syncdb --noinput
python eLocus/src/kolekti_server/manage.py runserver 0.0.0.0:8000
