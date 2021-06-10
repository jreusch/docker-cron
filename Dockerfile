FROM ubuntu:latest
MAINTAINER docker@ekito.fr

#Install packages and clean downloaded packages in the lowest layer
RUN apt-get update && apt-get -y install cron rsyslog && rm -rf /var/lib/apt/lists/*

# Add crontab file in the cron directory
COPY crontab /etc/cron.d/hello-cron

# Give execution rights on the cron job and create the log file to tail in the next layer
RUN chmod 0644 /etc/cron.d/hello-cron && touch /var/log/cron.log && chown syslog /var/log/cron.log

COPY rsyslog.conf /etc/
COPY 50-default.conf /etc/rsyslog.d/

# Run the command on container startup see this post as to why we modify the file before tailing it http://stackoverflow.com/a/43807880/329496
#CMD echo "starting" && (cron) && echo "tailing..." && : > /var/log/cron.log && tail -f /var/log/cron.log
CMD echo "starting" && : > /var/log/cron.log && ( tail -f /var/log/cron.log & ) && rsyslogd && cron -f
