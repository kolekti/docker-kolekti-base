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
#      ghostscript \
      gsfonts \
#      gulp \
      python-dev \   
      gunicorn \
      pandoc \
      python-lxml \
      python-pil \
      python-pip \
      python-pypdf2 \
      python-sparqlwrapper \
      python-svn \
      python-whoosh \
      python-unidecode \
      python-mysqldb \
      w3c-sgml-lib \
      subversion \
      rabbitmq-server \
      libfontconfig1 \
      libffi-dev \
      apache2-utils \
      && apt-get clean \
      && rm -rf /var/lib/apt/lists/* 

# Install python packages
ADD requirements.txt /requirements.txt
RUN pip install -r /requirements.txt 

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

# Install ghostscript 9.20 (from tarball)
RUN wget https://github.com/ArtifexSoftware/ghostpdl-downloads/releases/download/gs920/ghostscript-9.20-linux-x86_64.tgz \
    && tar xf ghostscript-9.20-linux-x86_64.tgz -C /opt \
    && update-alternatives --force --install /usr/bin/gs gs /opt/ghostscript-9.20-linux-x86_64/gs-920-linux_x86_64 999


# Install nodejs
RUN wget https://deb.nodesource.com/setup_lts.x \
    && bash ./setup_lts.x \
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


# Install PrinceXML
ENV PRINCE=prince_13.5-1_debian9_amd64.deb
RUN wget https://www.princexml.com/download/$PRINCE \
  && dpkg -i $PRINCE \
  && rm -r $PRINCE



ADD entrypoint.sh /
ADD kolekti.ini /etc/kolekti.ini

CMD /entrypoint.sh

ENV LANG C.UTF-8

EXPOSE 80
EXPOSE 443
