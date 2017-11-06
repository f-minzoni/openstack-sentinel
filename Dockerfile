FROM ubuntu:xenial

RUN apt-get update && \
    apt-get -y install python-setuptools gcc make ruby-dev libffi-dev && \
    gem install fpm 

ADD . /src/sentinel 

WORKDIR /src/sentinel         
RUN fpm -f -s python -t deb \
        --depends apache2 \ 
        --depends python-pecan \
        --depends python-keystoneclient \
        --depends python-novaclient \
        --depends python-neutronclient \
        --depends python-cinderclient \
        --depends python-ceilometerclient \
        --depends python-oslo.config \
        --depends python-stevedore \
        .

FROM ubuntu:xenial

RUN apt-get update && \
    apt-get install -y software-properties-common curl telnet

RUN add-apt-repository cloud-archive:ocata && \
    apt-get update && \
    apt-get -y dist-upgrade && \
    apt-get install -y apache2 libapache2-mod-wsgi keystone \
    python-pecan python-keystoneclient python-novaclient \ 
    python-neutronclient python-cinderclient python-ceilometerclient \ 
    python-oslo.config python-stevedore \
    python-openstackclient python-memcache python-pymysql && \
    apt-get clean

WORKDIR /root/
COPY --from=0 /src/sentinel/python-sentinel_0.0.1_all.deb .

RUN dpkg -i python-sentinel_0.0.1_all.deb

ADD etc/sentinel /etc/sentinel
ADD certs/ /etc/sentinel/ssl/easy-rsa/easyrsa3/pki/
RUN mkdir -p /var/log/sentinel && chown www-data /var/log/sentinel
ADD scripts /root

RUN rm /etc/apache2/sites-available/keystone.conf 
RUN rm /etc/apache2/sites-enabled/keystone.conf
ADD etc/apache2/vhost.000.keystone.conf /etc/apache2/sites-enabled/000-keystone.conf
ADD etc/apache2/apache.ports.conf /etc/apache2/ports.conf

ADD etc/keystone /etc/keystone

RUN a2enmod ssl && a2enmod wsgi && \
    a2dissite 000-default && \
    rm /etc/apache2/sites-available/000-default.conf

ADD init/start.sh /opt/init-keystone.sh
RUN chmod +x /opt/init-keystone.sh

EXPOSE 4567
EXPOSE 5000
EXPOSE 35357

ENTRYPOINT ["/opt/init-keystone.sh"]