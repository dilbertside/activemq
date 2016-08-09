# docker-activemq
Light footprint ActiveMQ image with

* busybox as OS container
* openjdk-8-jdk-alpine

## how to use

`docker pull diside/docker-activemq`

## example how to run

```bash
docker pull diside/docker-activemq
 docker run --name='activemq' -d \
-e 'ACTIVEMQ_REMOVE_DEFAULT_ACCOUNT=true' \
-e 'ACTIVEMQ_ADMIN_LOGIN=admin' -e 'ACTIVEMQ_ADMIN_PASSWORD=password' \
-e 'ACTIVEMQ_MIN_MEMORY=1024' -e  'ACTIVEMQ_MAX_MEMORY=4096' \
-e 'ACTIVEMQ_ENABLED_SCHEDULER=true' \
-p 8161:8161 \
-p 61616:61616 \
-p 61613:61613 \
diside/docker-activemq
```

#to change default password web console

`docker-edit activemq /var/lib/activemq/conf/jetty-realm.properties`


### to create your own ActiveMQ image

`./build.sh diside`

or with specific ActiveMQ version

`./build.sh diside 5.14.0`


## script util to edit file in a container
```bash
sudo tee /usr/bin/docker-edit <<-'EOF'
#!/bin/bash
EDITOR="${EDITOR:-vim}"
IFS=$'\n\t'
set -euox pipefail
CNAME="$1"
FILE_PATH="$2"
TMPFILE="$(mktemp)"
docker exec "$CNAME" cat "$FILE_PATH" > "$TMPFILE"
$EDITOR "$TMPFILE"
cat "$TMPFILE" | docker exec -i "$CNAME" sh -c 'cat > '"$FILE_PATH"
rm "$TMPFILE"
EOF
sudo chmod +x /usr/bin/docker-edit
```
