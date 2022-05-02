FROM alpine:latest 
RUN mkdir -p /app/
RUN mkdir -p /mnt/contrast
WORKDIR /app
RUN apk update && apk add curl  bash
COPY contrast.jar.backup /app/contrast.jar.backup
COPY fetch_latest_agent.sh /app/fetch_latest_agent.sh
CMD /app/fetch_latest_agent.sh
