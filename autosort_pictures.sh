#!/bin/bash

INCOMING_FOLDER="${1}"
OUTGOING_FOLDER="${2}"

inotifywait -m -r -e create --format "%e|%w%f" "${INCOMING_FOLDER}" |
while read event
do
  event_type=`echo $event | sed s/\|.*$//`
  filename=`echo $event | sed s/^.*\|//`
  
  if [ "${event_type}" = 'CREATE' ]
  then
    echo "new file: ${filename}"
    mv -v ${filename} ${OUTGOING_FOLDER}
  fi
done