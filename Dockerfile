FROM ubuntu:latest
MAINTAINER docker@ekito.fr

#Install packages and clean downloaded packages in the lowest layer
RUN apt-get update && apt-get -y install cron && rm -rf /var/lib/apt/lists/*

# Add crontab file in the cron directory
ADD crontab /etc/cron.d/hello-cron

# Give execution rights on the cron job and create the log file to tail in the next layer
RUN chmod 0644 /etc/cron.d/hello-cron && touch /var/log/cron.log

# Run the command on container startup
CMD echo "srarting" && echo "continuing" && (cron) && echo "tailing..."  && tail -f /var/log/cron.log
