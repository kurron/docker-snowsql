# Follows guidance from http://www.projectatomic.io/docs/docker-image-author-guidance/

FROM dockerazuljdk8_azul-jdk:latest

MAINTAINER Ron Kurr <kurr@kurron.org>

#ADD launch-jvm.sh /home/microservice/launch-jvm.sh
#RUN chmod a+x /home/microservice/launch-jvm.sh
#ADD Hello.class /home/microservice/Hello.class

USER root

RUN apt-get install --yes software-properties-common
RUN apt-add-repository --yes ppa:ansible/ansible
RUN apt-get update --yes
RUN apt-get install --yes ansible

# Switch to the non-root user and the home directory
USER microservice

CMD ["/usr/bin/ansible", "all", "--inventory=localhost,", "--verbose", "--connection=local", "-m setup"]
