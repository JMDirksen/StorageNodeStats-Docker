FROM ubuntu
RUN apt-get update && apt-get install -y curl jq
USER 1000:1000
COPY --chown=1000:1000 --chmod=750 run.sh .

# Storage node host:port list - comma separated
ENV HOSTS=localhost:14002,otherhost:14002

# Webstore URL - See: https://github.com/JMDirksen/WebStore
ENV WEBSTORE=

CMD ["/bin/bash", "run.sh"]
