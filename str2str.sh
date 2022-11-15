#!/bin/bash

PID="/home/linaro/str2str_6799.pid"
EXEC="/usr/local/bin/str2str"
BIN="busybox start-stop-daemon"
DEV="ttyUSB0"
PORT=6799

if [ -e "/dev/${DEV}" ];then
  if [ "$1" = "start" ];then
    $BIN -x $EXEC -b -m -p $PID --start -- -in serial://${DEV}:115200 -out tcpsvr://:${PORT} -b 1
  elif [ "$1" = "stop" ];then
    $BIN -p $PID -K
  else
    echo "arg is not valid."
  fi
else
  echo "device(${DEV}) not available"
fi

                                                                                                                                                                                                                      13,0-1        All
