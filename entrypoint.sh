#!/bin/sh

if [ -f "/data/rtk/entrypoint.sh" ]; then
  echo "$:prepare for the local entrypoint file..."
  chmod a+x /data/rtk/entrypoint.sh
  echo "$:start exec local entrypoint file."
  /data/rtk/entrypoint.sh
else 
  echo "$:start entrypoint from build-in entrypoint."
  if [ $ntripcaster -eq 1 ]; then
    echo "$:ntripcaster started."
    /usr/local/bin/ntripcaster /etc/ntripcaster/config.json > /dev/null &
  fi
  if [ $AUTORUN -eq 1 ]; then
    echo "$:start rtkrcv..."
    echo "$:the following logs from rtkrcv."
    /usr/local/bin/rtkrcv2 -d $type -in $path -s --rate $rate --posmode $posmode --msm $msm
  fi
fi
