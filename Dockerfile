FROM debian:jessie

RUN apt-get update && apt-get install -y \
      wget \
      git \
      make \
      libcurl3 \
      libgif4 \
      ghostscript \
      gsfonts \
      gunicorn \
      python-lxml \
      python-pil \
      python-pip \
      python-pypdf2 \
      python-sparqlwrapper \
      python-svn \
      python-whoosh \
      w3c-dtd-xhtml \
      subversion \
      rabbitmq-server \
      libfontconfig1 \
      && apt-get clean \
      && rm -rf /var/lib/apt/lists/* 

# Install fonts
# NOTE: must enable contrib apt repository for msttcorefonts
# NOTE: must remove bitmap-fonts.conf due to fontconfig bug
RUN sed -i 's/$/ contrib/' /etc/apt/sources.list \
  && apt-get update && apt-get install --assume-yes \
     fontconfig \
     msttcorefonts \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/* \
  && rm /etc/fonts/conf.d/10-scale-bitmap-fonts.conf

# Install PrinceXML
ENV PRINCE=prince_11.1-1_debian8.0_amd64.deb
RUN wget https://www.princexml.com/download/$PRINCE \
  && dpkg -i $PRINCE \
  && rm -r $PRINCE

RUN python -c 'from urllib import urlretrieve; urlretrieve("https://bitbucket.org/ariya/phantomjs/downloads/phantomjs-2.1.1-linux-x86_64.tar.bz2","/tmp/phantomjs.bz2")' && \
      tar jxvfO /tmp/phantomjs.bz2 phantomjs-2.1.1-linux-x86_64/bin/phantomjs > /usr/bin/phantomjs && chmod +x /usr/bin/phantomjs && rm /tmp/phantomjs.bz2

ADD requirements.txt /requirements.txt

RUN pip install -r /requirements.txt

ADD entrypoint.sh /
ADD kolekti.ini /etc/kolekti.ini

CMD /entrypoint.sh

ENV LANG C.UTF-8

EXPOSE 80
EXPOSE 443
