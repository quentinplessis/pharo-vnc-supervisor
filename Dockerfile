FROM consol/ubuntu-icewm-vnc
LABEL maintainer="Masashi Umezawa <ume@softumeya.com>"

## Change to root
USER 0

## Install prerequisites
RUN apt-get update && apt-get install -y \
    software-properties-common \
    python-software-properties \
    supervisor \
    && rm -rf /var/lib/apt/lists/*

# --------------------
# Pharo
# --------------------
ARG PHARO_IMAGE_VERSION=61
ENV PHARO_MODE='gui'
ENV PHARO_IMAGE='Pharo.image'
ENV PHARO_START_SCRIPT=''

RUN mkdir pharo && cd pharo \
  && apt-get update && apt-get install -y --no-install-recommends \
    curl \
    unzip \
  && curl https://get.pharo.org/64/$PHARO_IMAGE_VERSION+vm | bash \
  && mv ../pharo /usr/local/bin/ \
  && apt-get remove -y \
    unzip \
  && rm -rf /var/lib/apt/lists/*

ENV PATH="/usr/local/bin/pharo:${PATH}"

# --------------------
# Setup scripts
# --------------------
ADD ./launch-pharo.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/launch-pharo.sh
ADD ./setup.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/setup.sh

# --------------------
# Workspace
# --------------------
WORKDIR /root/data

RUN cp /usr/local/bin/pharo/Pharo*.* /root/data

VOLUME [ "/root/data" ]

EXPOSE 9000

# --------------------
# Supervisor
# --------------------
ENV PHARO_SUPERVISOR_LOG_NAME=pharo-supervisord.log
COPY pharo-supervisord.conf /etc/supervisor/conf.d/pharo-supervisord.conf

# --------------------
# Locale
# --------------------
ENV LANG=C.UTF-8
ENV LC_ALL=C.UTF-8
ARG TZ='Asia/Tokyo'
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

# --------------------
# ENTRYPOINT
# --------------------
ENTRYPOINT [ "/bin/bash", "-l", "-c", "/usr/local/bin/setup.sh && /usr/bin/supervisord -n" ]
