FROM debian:jessie

RUN apt-get update && apt-get install -y \
      gunicorn                   \
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

CMD /entrypoint.sh

EXPOSE 80
EXPOSE 443
