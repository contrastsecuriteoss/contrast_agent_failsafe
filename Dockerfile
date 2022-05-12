FROM alpine:latest 
RUN apk update && apk add curl  bash
RUN addgroup -S contrast && adduser -S contrast -G contrast
RUN mkdir -p /tmp/app
RUN mkdir -p /tmp/contrast
WORKDIR /tmp/app
COPY contrast.jar.backup /tmp/app/contrast.jar.backup
COPY fetch_latest_agent.sh /tmp/app/fetch_latest_agent.sh
RUN chgrp -R contrast /tmp/app/
RUN chgrp -R contrast /tmp/contrast/
RUN chmod 777 /tmp/app/
RUN chmod 777 /tmp/contrast/
RUN chmod +x /tmp/app/fetch_latest_agent.sh
USER contrast
CMD /tmp/app/fetch_latest_agent.sh
