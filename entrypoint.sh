#!/bin/sh

set -e

cp /eLocus/src/kolekti_server/kolekti.ini /etc
cp /eLocus/src/kolekti_server/db.sqlite3.ref /eLocus/src/kolekti_server/db.sqlite3
LC_ALL=C PYTHONPATH=/eLocus/vendor:/eLocus/src:/eLocus/src/kolekti_server python eLocus/src/kolekti_server/manage.py runserver 0.0.0.0:8000
