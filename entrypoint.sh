#!/bin/bash

/usr/local/bin/ntripcaster /etc/ntripcaster/config.json
/usr/local/bin/rtkrcv -p 8077 -m 8078 -o /data/rtk/rtkrcv.conf
