# Follows guidance from http://www.projectatomic.io/docs/docker-image-author-guidance/

# Base image off of the official Ubuntu-based image
FROM azul/zulu-openjdk:8

MAINTAINER Ron Kurr <kurr@kurron.org>

# Create non-root user
RUN groupadd --system microservice --gid 444 && \
useradd --uid 444 --system --gid microservice --home-dir /home/microservice --create-home --shell /sbin/nologin --comment "Docker image user" microservice && \
chown -R microservice:microservice /home/microservice

# default to being in the user's home directory
WORKDIR /home/microservice

# Set standard Java environment variables
ENV JAVA_HOME /usr/lib/jvm/zulu-8-amd64
ENV JDK_HOME /usr/lib/jvm/zulu-8-amd64

# show the JVM version, by default
CMD ["java", "-version"]

# remember to switch to the non-root user in child images
# Switch to the non-root user
# USER microservice
