#!/bin/sh

if [ -f "/etc/rtk/entrypoint.sh" ]; then
chmod a+x /etc/rtk/entrypoint.sh
/etc/rtk/entrypoint.sh
else 
/usr/local/bin/ntripcaster /etc/ntripcaster/config.json
/usr/local/bin/rtkrcv -p 8077 -m 8078 -o /etc/rtk/rtkrcv.conf
fi
