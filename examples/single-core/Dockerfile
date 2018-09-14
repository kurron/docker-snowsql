# Follows guidance from http://www.projectatomic.io/docs/docker-image-author-guidance/

FROM dockerazuljdk8_azul-jdk:latest

MAINTAINER Ron Kurr <kurr@kurron.org>

ADD launch-jvm.sh /home/microservice/launch-jvm.sh
RUN chmod a+x /home/microservice/launch-jvm.sh
ADD Hello.class /home/microservice/Hello.class

# Switch to the non-root user and the home directory
USER microservice

# Run the simple program
ENTRYPOINT ["/home/microservice/launch-jvm.sh", "Hello"]
