#!/bin/sh


if [ -f "/data/rtk/entrypoint.sh" ]; then
chmod a+x /data/rtk/entrypoint.sh
/data/rtk/entrypoint.sh
else 
chmod a+x /usr/local/bin/entrypoint.sh
/usr/local/bin/entrypoint.sh
fi

exec "$@"
