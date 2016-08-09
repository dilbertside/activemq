#!/bin/bash

cd $(dirname $0)

DEFAULT_VERSION=5.14.0

usage() {
  echo "usage: $0 [repo] [version]"
  echo "       param1 [repo] your docker repository identifier"
  echo "       param2 optional [version] ActiveMQ package to download default=$DEFAULT_VERSION"
}

#print a user msg confirmation before executing a command
#@param 1: command to run with all arguments
#@return: 4 if no confirmation
function confirm() {
  local defaultMsg="nothing to do..."
  #alert the user what they are about to do.
  local fnCmd="$1"
  fnCmd=${fnCmd//_/ }
  echo "About to $fnCmd...";
  #confirm with the user
  read -r -p "Are you sure? [Y/n] " response
  case "$response" in
    [yY][eE][sS]|[yY])
      #if yes, then execute the passed parameters
       "$@"
       ;;
    *)
      #Otherwise exit...
      echo $defaultMsg
      return 4
      ;;
  esac
}

if [ $# -eq 0 ]; then
  usage;
  exit 1;
fi
DOCK_REPO=${1}
ACTIVEMQ_VERSION=${2:-$DEFAULT_VERSION}

ACTIVEMQ=apache-activemq-$ACTIVEMQ_VERSION

FILE=$ACTIVEMQ-bin.tar.gz

if [ -f $FILE ];
then
  echo "File $FILE exists, skipping download"
else
  echo "File $FILE does not exist, downloading..."
  curl -O http://archive.apache.org/dist/activemq/$ACTIVEMQ_VERSION/$FILE
fi

docker build --build-arg=ACTIVEMQ_VERSION="$ACTIVEMQ_VERSION" --tag "$DOCK_REPO/activemq:$ACTIVEMQ_VERSION" --tag "$DOCK_REPO/activemq:latest" .

docker inspect "$DOCK_REPO/activemq:$ACTIVEMQ_VERSION"

docker push "$DOCK_REPO/activemq:$ACTIVEMQ_VERSION"

echo "docker push $DOCK_REPO/activemq:$ACTIVEMQ_VERSION as latest?"
confirm docker push "$DOCK_REPO/activemq:latest"

echo "All done"

