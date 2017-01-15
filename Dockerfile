FROM gitlab/gitlab-ce:8.15.4-ce.1
MAINTAINER Daniel Eagle

VOLUME /etc/gitlab/ssl

# Copy SSL files
COPY config/ssl/server.crt /etc/gitlab/ssl/server.crt
COPY config/ssl/server.key /etc/gitlab/ssl/server.key

# Remove write access from SSL files to protect from accidental damage
RUN chmod -v 0444 /etc/gitlab/ssl/server.crt \
  && chmod -v 0444 /etc/gitlab/ssl/server.key
