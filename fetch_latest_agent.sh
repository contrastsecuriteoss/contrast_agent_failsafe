#!/bin/bash

echo [CONTRAST INIT CONTAINER] STARTING DOWNLOAD
echo "api:">/app/contrast_security.yaml
echo "  url: $CONTRAST_AGENT_URL/Contrast">>/app/contrast_security.yaml
echo "  api_key: $CONTRAST_AGENT_APIKEY">>/app/contrast_security.yaml
echo "  service_key: $CONTRAST_AGENT_SERVICEKEY">>/app/contrast_security.yaml
echo "  user_name: $CONTRAST_AGENT_USERNAME">> /app/contrast_security.yaml

if [ $CONTRAST_AUTHORIZATION ] && [ $CONTRAST_ORGID ]
then
if [ ! $CONTRAST_APIKEY ];then CONTRAST_APIKEY=$CONTRAST_AGENT_APIKEY;fi
if [ ! $CONTRAST_URL ];then CONTRAST_URL=$CONTRAST_AGENT_URL;fi

	echo [CONTRAST INIT CONTAINER] STARTING DOWNLOAD from your teamserver org
	curl -L --output /app/contrast.jar --header "Api-Key: $CONTRAST_APIKEY" --header "Authorization: $CONTRAST_AUTHORIZATION" "$CONTRAST_URL/Contrast/api/ng/$CONTRAST_ORGID/agents/default/JAVA"
else
	echo [CONTRAST INIT CONTAINER] STARTING DOWNLOAD from maven central
	curl -L --output /app/contrast.jar "https://repository.sonatype.org/service/local/artifact/maven/redirect?r=central-proxy&g=com.contrastsecurity&a=contrast-agent&v=LATEST"
fi
if [ -f /app/contrast.jar ]
then
     size=`wc -c /app/contrast.jar | awk '{print $1}'` 
     if [ $size -lt  10000000 ]
     then
	echo [CONTRAST INIT CONTAINER] download failed using failsafe agent
	cp /app/contrast.jar.backup /app/contrast.jar
     else
	echo [CONTRAST INIT CONTAINER] download SUCCESS
     fi
else
       echo [CONTRAST INIT CONTAINER] download failed using failsafe agent
       cp /app/contrast.jar.backup /app/contrast.jar
fi
cp /app/contrast.jar /mnt/contrast/contrast.jar
cp /app/contrast_security.yaml /mnt/contrast/contrast_security.yaml
