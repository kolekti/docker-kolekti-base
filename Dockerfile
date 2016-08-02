FROM debian:jessie

RUN apt-get update && apt-get install -y \
      gunicorn                   \
      locales                    \
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
      subversion                 && \
      rm -rf /var/lib/apt/lists/* && \
      echo "fr_FR.UTF-8 UTF-8" > /etc/locale.gen && \
      locale-gen

RUN pip install pygal

ADD entrypoint.sh /
ADD kolekti.ini /etc/kolekti.ini

CMD /entrypoint.sh

ENV LANG C.UTF-8

EXPOSE 80
EXPOSE 443
