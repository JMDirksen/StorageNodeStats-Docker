FROM httpd
RUN apt-get update && apt-get install -y curl jq
EXPOSE 80
ENV INTERVAL=3h
ENV HOSTS=localhost:14002,otherhost:14002
COPY --chmod=700 run.sh /usr/local/bin/run.sh
COPY --chmod=700 bg.sh /usr/local/bin/bg.sh
ENTRYPOINT ["/usr/local/bin/run.sh"]
