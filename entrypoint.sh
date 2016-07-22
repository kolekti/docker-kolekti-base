#!/bin/sh

set -e

cp /eLocus/src/kolekti_server/kolekti.ini /etc
LC_ALL=C PYTHONPATH=/eLocus/vendor:/eLocus/src:/eLocus/src/kolekti_server python eLocus/src/kolekti_server/manage.py runserver 0.0.0.0:8000
