FROM debian

RUN apt-get update && apt-get install -y \
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

COPY entrypoint.sh /
CMD /entrypoint.sh
