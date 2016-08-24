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
      w3c-dtd-xhtml		 \
      subversion                 \
      libfontconfig1              && \
      rm -rf /var/lib/apt/lists/* && \

      python -c 'from urllib import urlretrieve; urlretrieve("https://bitbucket.org/ariya/phantomjs/downloads/phantomjs-2.1.1-linux-x86_64.tar.bz2","/tmp/phantomjs.bz2")' && \
      tar jxvfO /tmp/phantomjs.bz2 phantomjs-2.1.1-linux-x86_64/bin/phantomjs > /usr/bin/phantomjs && chmod +x /usr/bin/phantomjs && rm /tmp/phantomjs.bz2


RUN pip install pygal

ADD entrypoint.sh /
ADD kolekti.ini /etc/kolekti.ini

CMD /entrypoint.sh

ENV LANG C.UTF-8

EXPOSE 80
EXPOSE 443
