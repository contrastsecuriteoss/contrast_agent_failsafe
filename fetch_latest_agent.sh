#!/bin/bash
echo "[CONTRAST INIT CONTAINER] STARTING DOWNLOAD (running with user `whoami`)"


#Protection against new line space and other special characters                
#                                                                              
#                                                                                
CONTRAST_AGENT_URL=${CONTRAST_AGENT_URL//[$'\n\r\t' \`]/}                          
CONTRAST_AGENT_APIKEY=${CONTRAST_AGENT_APIKEY//[$'\n\r\t' \`]/}                    
CONTRAST_AGENT_SERVICEKEY=${CONTRAST_AGENT_SERVICEKEY//[$'\n\r\t' \`]/}            
CONTRAST_AGENT_USERNAME=${CONTRAST_AGENT_USERNAME//[$'\n\r\t' \`]/}                
CONTRAST_AUTHORIZATION=${CONTRAST_AUTHORIZATION//[$'\n\r\t' \`]/}                  
CONTRAST_ORGID=${CONTRAST_ORGID//[$'\n\r\t' \`]/}                                  
CONTRAST_URL=${CONTRAST_URL//[$'\n\r\t' \`]/}                                      
#                                                                                                      
#                                                                                                                                                                                           
#  

echo "api:">/tmp/app/contrast_security.yaml
echo "  url: $CONTRAST_AGENT_URL/Contrast">>/tmp/app/contrast_security.yaml
echo "  api_key: $CONTRAST_AGENT_APIKEY">>/tmp/app/contrast_security.yaml
echo "  service_key: $CONTRAST_AGENT_SERVICEKEY">>/tmp/app/contrast_security.yaml
echo "  user_name: $CONTRAST_AGENT_USERNAME">> /tmp/app/contrast_security.yaml

if [ $CONTRAST_AUTHORIZATION ] && [ $CONTRAST_ORGID ]
then
if [ ! $CONTRAST_APIKEY ];then CONTRAST_APIKEY=$CONTRAST_AGENT_APIKEY;fi
if [ ! $CONTRAST_URL ];then CONTRAST_URL=$CONTRAST_AGENT_URL;fi

	echo "[CONTRAST INIT CONTAINER] STARTING DOWNLOAD from your teamserver url is ( $CONTRAST_URL)"
	curl -L --output /tmp/app/contrast.jar --header "Api-Key: $CONTRAST_APIKEY" --header "Authorization: $CONTRAST_AUTHORIZATION" "$CONTRAST_URL/Contrast/api/ng/$CONTRAST_ORGID/agents/default/JAVA"
else
	echo "[CONTRAST INIT CONTAINER] STARTING DOWNLOAD from maven central "
	curl -L --output /tmp/app/contrast.jar "https://repository.sonatype.org/service/local/artifact/maven/redirect?r=central-proxy&g=com.contrastsecurity&a=contrast-agent&v=LATEST"
fi
if [ -f /tmp/app/contrast.jar ]
then
     size=`wc -c /tmp/app/contrast.jar | awk '{print $1}'` 
     if [ $size -lt  10000000 ]
     then
	echo [CONTRAST INIT CONTAINER] download failed using failsafe agent
	cp /tmp/app/contrast.jar.backup /tmp/app/contrast.jar
     else
	echo [CONTRAST INIT CONTAINER] download SUCCESS
     fi
else
       echo [CONTRAST INIT CONTAINER] download failed using failsafe agent
       cp /tmp/app/contrast.jar.backup /tmp/app/contrast.jar
fi
cp /tmp/app/contrast.jar /tmp/contrast/contrast.jar
cp /tmp/app/contrast_security.yaml /tmp/contrast/contrast_security.yaml
