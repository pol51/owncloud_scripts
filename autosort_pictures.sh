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
    OIFS=$IFS; IFS=': '
    set -- $(exiv2 -g Exif.Image.DateTime -Pv ${filename})
    IFS=$OIFS;
    if [ -n "$1" ]
    then
      outgoing_relative_path=$(realpath --relative-to=$(dirname ${filename}) ${OUTGOING_FOLDER})
      mkdir -p ${OUTGOING_FOLDER}/$1/$2/$3
      exiv2 -T ${filename}
      exiv2 mv ${filename} -r ${outgoing_relative_path}/%Y/%m/%d/IMG_%Y%m%d_%H%M%S
    fi
  fi
done
