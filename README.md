# contrast_agent_failsafe
Init container for contrast agent to use in the manifest files


to build the docker : 

docker build . -t yourorg/contrast_agent_failsafe:latest


docker push yourorg/contrast_agent_failsafe:latest


Define a secret file in your Kubernetes/ECS


        apiVersion: v1
        kind: Secret
        metadata:
          name: contrast-loader
        type: Opaque
        stringData:
          url: "https://app.contrastsecurity.com"
          api_key: "<apikey>"
          service_key: "<service key>"
          user_name: "<>agent username>"
          authorization: "<personal auth header>"
          org_id: "<org id>"
  
  
  
   add the initcontainer in your application manifest and a volume that is an empty dir
  

      initContainers:
      - name: init-contrast-agent
        image: yourorg/contrast_agent_failsafe:latest
        env:
        - name: "CONTRAST_AGENT_URL"
          valueFrom:
            secretKeyRef:
              name: contrast-loader
              key: url
        - name: "CONTRAST_AGENT_APIKEY"
          valueFrom:
            secretKeyRef:
              name: contrast-loader
              key: api_key
        - name: "CONTRAST_AGENT_SERVICEKEY"
          valueFrom:
            secretKeyRef:
              name: contrast-loader
              key: service_key
        - name: "CONTRAST_AGENT_USERNAME"
          valueFrom:
            secretKeyRef:
              name: contrast-loader
              key: user_name
        - name: "CONTRAST_AUTHORIZATION"
          valueFrom:
            secretKeyRef:
              name: contrast-loader
              key: authorization
        - name: "CONTRAST_ORGID"
          valueFrom:
            secretKeyRef:
              name: contrast-loader
              key: org_id
        volumeMounts:
        - name: contrast-agent-pv-volume
          mountPath: /tmp/contrast
      volumes:
      - name: contrast-agent-pv-volume
        emptyDir: {}

once the init container is added and working
add a volume into your existing container

        volumeMounts:
        - name: contrast-agent-pv-volume
          mountPath: "/mnt/contrast"
          readOnly: true

Finally you can add Env variable JAVA_TOOL_OPTIONS or NODE_OPTIONS to activate the agent.

env:
- name: "JAVA_TOOL_OPTIONS"
          value: "-javaagent:/tmp/contrast/contrast.jar -Dcontrast.config.path=/tmp/contrast/contrast_security.yaml -Dcontrast.agent.contrast_working_dir=/tmp"
