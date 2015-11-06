FROM quay.io/baselibrary/java:8
MAINTAINER ShawnMa <qsma@thoughtworks.com>

## Version
ENV MESOS_MAJOR   0.25.0
ENV MESOS_VERSION 0.25.0-0.2.70.ubuntu1404

## Repository
RUN \
  apt-key adv --keyserver keyserver.ubuntu.com --recv-keys E56151BF &&\
  echo "deb http://repos.mesosphere.com/ubuntu trusty main" > /etc/apt/sources.list.d/mesosphere.list

## Packages
RUN \
  apt-get update &&\
  apt-get install -y mesos=$MESOS_VERSION &&\
  rm -rf /var/lib/apt/lists/*

## Scripts
ADD docker-entrypoint.sh /docker-entrypoint.sh
RUN chmod a+x            /docker-entrypoint.sh

EXPOSE 5050

VOLUME ["/var/lib/mesos"]

ENTRYPOINT ["tini", "--", "/docker-entrypoint.sh"]

CMD ["mesos"]


