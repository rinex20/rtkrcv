FROM ubuntu:18.04 as builder

ENV RTK_VER=demo5
ARG CONF_URL=https://raw.githubusercontent.com/rinex20/gnss_tools/master/conf/rtkrcv.conf
ARG NTRIP_CFG=https://raw.githubusercontent.com/rinex20/another_ntripcaster/main/config.json
ARG RTKLIB_URL=https://github.com/rtklibexplorer/RTKLIB.git
ARG NTRIP_URL=https://github.com/tisyang/ntripcaster.git
# get conf file

WORKDIR /root

RUN apt-get update \
  && apt-get install -y build-essential g++ \
  && apt-get install -y git wget gfortran cmake tar libev-dev \
#   && mkdir -p /data/rtk \
#   && mkdir -p /etc/ntripcaster \
#   && wget ${CONF_URL} -O /data/rtk/rtkrcv.conf \
#   && wget ${NTRIP_CFG} -O /etc/ntripcaster/config.json \
   && git clone --depth 1 --branch ${RTK_VER} ${RTKLIB_URL} \
   && (cd /root/RTKLIB/lib/iers/gcc/; make) \ 
   && (cd /root/RTKLIB/app/consapp/str2str/gcc; make; make install) \
   && (cd /root/RTKLIB/app/consapp/rtkrcv/gcc; make; make install) 
#   && cd /root \
#   && git clone ${NTRIP_URL} \
#   && cd /root/ntripcaster \
#   && git submodule update --init \ 
#   && mkdir -p /root/ntripcaster/build \ 
#   && (cd /root/ntripcaster/build; cmake ..) \
#   && (cd /root/ntripcaster/build; make) \
#   && cp /root/ntripcaster/build/ntripcaster /usr/local/bin/ 


FROM rinex20/another_ntripcaster:latest
LABEL maintainer="Jacky <cheungyong@gmail.com>"
ENV version=202109
ENV ntripcaster 0
ENV AUTORUN 1

# RUN apt-get update \
#  && apt-get install -y libev-dev \
#  && apt-get clean \
#  && mkdir /data/rtk -p
#  && mkdir /etc/ntripcaster -p

COPY --from=builder /usr/local/bin/* /usr/local/bin/
COPY entrypoint.sh /root/entrypoint.sh
COPY rtkrcv.conf /etc/rtk/rtkrcv.conf

RUN chmod a+x /root/entrypoint.sh

EXPOSE 8077 8078 8001-8008

ENTRYPOINT ["/root/entrypoint.sh"]
