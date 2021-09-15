# rtkrcv

Get the latest image:
`docker pull rinex20/rtkrcv:latest`

## 1. How to run?

### a. docker cli

<pre>
docker run -d --restart=unless-stopped --name=rtk \
   --network=bridge \ 
   -p 8001:2101 -p 8002-8005:8002-8005 \
   -p 8077-8078:8077-8078 \ 
   -v $PWD/conf:/data/rtk \
   -e ntripcaster=1 -e AUTORUN=1 \
   rinex20/rtkrcv:latest
</pre>

### b. docker-compose
<pre>
version: '3'
services:
  rtk:
    image: rinex20/rtkrcv:latest #private
    volumes:
      - $PWD/conf:/data/rtk
    restart: unless-stopped
    network_mode: bridge
    environment:
      - ntripcaster=1
      - AUTORUN=1
    ports:
      - 8077-8078:8077-8078
      - 8002-8005:8002-8005
      - 8001:2010
    container_name: rtk
</pre>
## 2. Configure

## 3. Others

