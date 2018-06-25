FROM debian:stretch

RUN apt-get update && apt-get install -y \
      sudo \
      apt-utils \
      wget \
      git \
      make \
      libcurl3 \
      libgif7 \
      libpixman-1-0 \
      ghostscript \
      gsfonts \
      python-dev \   
      gunicorn \
      python-lxml \
      python-pil \
      python-pip \
      python-pypdf2 \
      python-sparqlwrapper \
      python-svn \
      python-whoosh \
      python-unidecode \
      w3c-sgml-lib \
      subversion \
      rabbitmq-server \
      libfontconfig1 \
      apache2-utils \
      && apt-get clean \
      && rm -rf /var/lib/apt/lists/* 

# Install fonts
# NOTE: must enable contrib apt repository for msttcorefonts
# NOTE: must remove bitmap-fonts.conf due to fontconfig bug
RUN sed -i 's/$/ contrib/' /etc/apt/sources.list \
  && apt-get update && apt-get install --assume-yes \
     fontconfig \
     msttcorefonts \
     fonts-arphic-bkai00mp fonts-arphic-bsmi00lp fonts-arphic-gbsn00lp \
     fonts-ipafont-gothic fonts-ipafont-mincho fonts-lato fonts-lmodern fonts-sil-padauk fonts-unfonts-core fonts-unfonts-extra  \
     ttf-unifont \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/* \
  && rm /etc/fonts/conf.d/10-scale-bitmap-fonts.conf



# Install PrinceXML
ENV PRINCE=prince_20180328-1_debian9.1_amd64.deb
RUN wget https://www.princexml.com/download/$PRINCE \
  && dpkg -i $PRINCE \
  && rm -r $PRINCE

RUN python -c 'from urllib import urlretrieve; urlretrieve("https://bitbucket.org/ariya/phantomjs/downloads/phantomjs-2.1.1-linux-x86_64.tar.bz2","/tmp/phantomjs.bz2")' && \
      tar jxvfO /tmp/phantomjs.bz2 phantomjs-2.1.1-linux-x86_64/bin/phantomjs > /usr/bin/phantomjs && chmod +x /usr/bin/phantomjs && rm /tmp/phantomjs.bz2

ADD requirements.txt /requirements.txt
RUN pip install -r /requirements.txt \
    && pip install --ignore-installed six==1.10.0 

# RUN apt-get update \
#     && apt-get install -y pkg-config autoconf2.13 libtool gtk-doc-tools flex bison libpng-dev libpoppler-dev librsvg2-dev libharfbuzz-dev libfreetype6-dev libffi-dev \
#     && export LD_LIBRARY_PATH=/usr/local/lib \
#     && wget  http://cairographics.org/snapshots/cairo-1.15.8.tar.xz \
#     && tar xvfJ cairo-1.15.8.tar.xz \
#     && cd /cairo-1.15.8 \
#     && ./autogen.sh \
#     && ./configure \
#     && make install \
#     && cd / \
#     && wget http://ftp.gnome.org/pub/gnome/sources/pango/1.38/pango-1.38.1.tar.xz \
#     && tar xvfJ pango-1.38.1.tar.xz \
#     && cd /pango-1.38.1 \
#     && ./autogen.sh \
#     && ./configure \
#     && make install \
#     && cd / \
#     && apt-get purge -y python-cffi \
#     && pip install cffi cairocffi \
#     && apt-get clean \
#     && rm -rf /var/lib/apt/lists/*

RUN apt-get update \
     && apt-get install -y  libpng-dev libpoppler-dev librsvg2-dev libharfbuzz-dev libfreetype6-dev libffi-dev

RUN pip install WeasyPrint

# Install nodejs
RUN wget https://deb.nodesource.com/setup_8.x \
    && bash ./setup_8.x \
    && apt-get update && apt-get install -y nodejs \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*
          
# Install gulp
RUN npm install -g gulp-cli \
 && npm install gulp \
 && npm install gulp-load-plugins \
 && npm install gulp-csso \
 && npm install gulp-rename \
 && npm install gulp-less

# Install ghostscript 9.20 (from stretch)
# COPY apt-stretch-sources /etc/apt/sources.list.d/stretch.list
# COPY apt-preferences /etc/apt/preferences
# run apt-get update && apt-get install --reinstall -y \
#     ghostscript=9.20~dfsg-3.2+deb9u1 \
#     libgs9=9.20~dfsg-3.2+deb9u1 \
#     libgs9-common=9.20~dfsg-3.2+deb9u1


ADD entrypoint.sh /
ADD kolekti.ini /etc/kolekti.ini

CMD /entrypoint.sh

ENV LANG C.UTF-8

EXPOSE 80
EXPOSE 443
