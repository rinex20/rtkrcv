#!/bin/bash

PID="/home/linaro/str2str_6799.pid"
EXEC="/usr/local/bin/str2str"
BIN="busybox start-stop-daemon"

if [ "$1" = "start" ];then
  $BIN -x $EXEC -b -m -p $PID --start -- -in serial://ttyUSB0:115200 -out tcpsvr://:6799 -b 1
elif [ "$1" = "stop" ];then
  $BIN -p $PID -K
else
  echo "arg is not valid."
fi

                                                                                                                                                                                                                      13,0-1        All
