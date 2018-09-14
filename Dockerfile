FROM ubuntu:18.04

MAINTAINER Ron Kurr <kurr@kurron.org>

# Create non-root user
RUN groupadd --system snowflake --gid 444 && \
useradd --uid 444 --system --gid snowflake --home-dir /home/snowflake --create-home --shell /sbin/nologin --comment "Docker image user" snowflake && \
chown -R snowflake:snowflake /home/snowflake

# default to being in the user's home directory
WORKDIR /home/snowflake

# show the JVM version, by default
CMD ["date"]

# remember to switch to the non-root user in child images
# Switch to the non-root user
# USER snowflake
