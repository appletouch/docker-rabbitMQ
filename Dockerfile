FROM centos:centos7
MAINTAINER Peter van de Koolwijk  <iphone@appletouch.nl>

RUN yum -y update; yum clean all

RUN yum -y install wget; yum clean all

# Initialize rabbitmq repos and install rabbitmq
RUN wget https://bintray.com/rabbitmq/rabbitmq-server-rpm/rpm -O /etc/yum.repos.d/bintray-rabbitmq-rabbitmq-server-rpm.repo
RUN rpm --import https://www.rabbitmq.com/rabbitmq-release-signing-key.asc
RUN wget https://bintray.com/rabbitmq/erlang/rpm -O /etc/yum.repos.d/bintray-rabbitmq-erlang.repo
RUN yum install -y Erlang rabbitmq-server; yum clean all

# Enable management plugin
RUN /usr/lib/rabbitmq/bin/rabbitmq-plugins enable rabbitmq_management

# Enable MQTT adapter
RUN /usr/lib/rabbitmq/bin/rabbitmq-plugins enable rabbitmq_mqtt

# Copy configuration file
ADD rabbitmq.config /etc/rabbitmq

# 5672 rabbitmq-server - amqp port
# 15672 rabbitmq-server - for management plugin
# 4369 epmd - for clustering
# 25672 rabbitmq-server - for clustering
# 1883 mqtt
# 8883 mqtt over ssl
EXPOSE 5672 15672 4369 25672 1883 8883

CMD ["/sbin/rabbitmq-server"]

