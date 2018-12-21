####################################################################################################
FROM centos:6 as cacti-old

RUN yum -y install httpd php php-pecl-zendopcache php-snmp php-mysql rrdtool

COPY old/yy-php.ini /etc/php.d/yy-php.ini
COPY old/cacti.conf /etc/httpd/conf.d/cacti.conf

RUN rm -f /var/log/httpd/access_log &&\
    rm -f /var/log/httpd/error_log &&\
    ln -sfn /dev/stderr /var/log/httpd/access_log &&\
    ln -sfn /dev/stderr /var/log/httpd/error_log

####################################################################################################
FROM centos:7 as cacti-new

RUN sed -i '/^tsflags=nodocs$/d' /etc/yum.conf
RUN yum -y install epel-release
RUN yum -y install cacti php php-pecl-zendopcache

RUN sed -i 's/Require host localhost/require all granted/' /etc/httpd/conf.d/cacti.conf

COPY new/yy-php.ini /etc/php.d/yy-php.ini
COPY new/config.php /usr/share/cacti/include/config.php

RUN rm -f /var/log/httpd/access_log &&\
    rm -f /var/log/httpd/error_log &&\
    ln -sfn /dev/stderr /var/log/httpd/access_log &&\
    ln -sfn /dev/stderr /var/log/httpd/error_log

CMD [ "/usr/sbin/httpd", "-DFOREGROUND" ]
