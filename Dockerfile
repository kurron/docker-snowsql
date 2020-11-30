FROM ubuntu:18.04

MAINTAINER Ron Kurr <kurr@kurron.org>

RUN apt-get update && apt-get --assume-yes install  curl

# Create non-root user
RUN groupadd --system snowflake --gid 444 && \
useradd --uid 444 --system --gid snowflake --home-dir /home/snowflake --create-home --shell /sbin/nologin --comment "Docker image user" snowflake && \
chown -R snowflake:snowflake /home/snowflake

# default to being in the user's home directory
WORKDIR /home/snowflake

ENV LC_ALL=C.UTF-8
ENV LANG=C.UTF-8
ENV VERSION 1.1.62
ENV SNOWSQL_DEST /usr/local/bin
ENV SNOWSQL_LOGIN_SHELL /home/snowflake/.bashrc

# grab the installation script
RUN curl -o snowsql-${VERSION}-linux_x86_64.bash http://s3-us-west-2.amazonaws.com/sfc-snowsql-updates/bootstrap/1.1/linux_x86_64/snowsql-${VERSION}-linux_x86_64.bash

# Install the tool
RUN bash snowsql-${VERSION}-linux_x86_64.bash

# Switch to the non-root user
USER snowflake

# Run the SnowSQL client once, allowing it to auto-upgrade to the latest version.
# See https://docs.snowflake.com/en/user-guide/snowsql-install-config.html#label-understanding-auto-upgrades
RUN snowsql -v

ENTRYPOINT ["snowsql"]

CMD ["-v"]
