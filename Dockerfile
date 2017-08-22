FROM ubuntu:16.04
MAINTAINER Stefano Speretta

ENV LANG C.UTF-8

RUN apt-get update; apt-get install -y \
    apache2 \
    libapache2-modsecurity \
    wget \
    vim \
    openssl

RUN rm -rf /var/www/html/*; rm -rf /etc/apache2/sites-enabled/*; \
    mkdir -p /etc/apache2/external

ENV APACHE_RUN_USER www-data
ENV APACHE_RUN_GROUP www-data
ENV APACHE_LOG_DIR /var/log/apache2
ENV APACHE_SERVER_NAME localhost

RUN a2enmod ssl; \
    a2enmod headers; \
    echo "export APACHE_SERVER_NAME=localhost" >> /etc/apache2/envvars 

ADD 000-default.conf /etc/apache2/sites-enabled/000-default.conf
ADD 001-default-ssl.conf /etc/apache2/sites-enabled/001-default-ssl.conf
ADD apache2.conf /etc/apache2/apache2.conf
ADD security2.conf /etc/apache2/mods-enabled/security2.conf

RUN cp /etc/modsecurity/modsecurity.conf-recommended /etc/modsecurity/modsecurity.conf; \
    sed -i 's/^SecRuleEngine DetectionOnly/SecRuleEngine On/g' /etc/modsecurity/modsecurity.conf; \
    sed -i 's/^SecResponseBodyAccess On/SecResponseBodyAccess Off/g' /etc/modsecurity/modsecurity.conf
    
EXPOSE 80
EXPOSE 443

ADD entrypoint.sh /opt/entrypoint.sh
RUN chmod a+x /opt/entrypoint.sh

ENTRYPOINT ["/opt/entrypoint.sh"]
CMD ["/usr/sbin/apache2ctl", "-D", "FOREGROUND"]
