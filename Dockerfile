FROM ubuntu:18.04 as builder

ENV version=20201209
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
#   && cd /data/rtk \
#   && wget ${CONF_URL} -O /data/rtk/rtkrcv.conf \
#   && wget ${NTRIP_CFG} -O /etc/ntripcaster/config.json \
   && git clone --depth 1 --branch ${RTK_VER} ${RTKLIB_URL} \
   && (cd RTKLIB/lib/iers/gcc/; make) \
   && (cd RTKLIB/app/str2str/gcc; make; make install) \
   && (cd RTKLIB/app/rtkrcv/gcc; make; make install) 
#   && cd /root \
#   && git clone ${NTRIP_URL} \
#   && cd /root/ntripcaster \
#   && git submodule update --init \ 
#   && mkdir -p /root/ntripcaster/build \ 
#   && (cd /root/ntripcaster/build; cmake ..) \
#   && (cd /root/ntripcaster/build; make) \
#   && cp /root/ntripcaster/build/ntripcaster /usr/local/bin/ 


FROM ubuntu:latest
LABEL maintainer="Jacky <cheungyong@gmail.com>"

# RUN apt-get update \
#  && apt-get install -y libev-dev \
#  && apt-get clean \
#  && mkdir /data/rtk -p 
#  && mkdir /etc/ntripcaster -p

COPY --from=builder /usr/local/bin/* /usr/local/bin/
COPY rtkrcv.conf /data/rtk/
#COPY --from=builder /etc/ntripcaster/* /etc/ntripcaster/
#COPY entrypoint.sh /usr/local/bin/

#RUN chmod +x /usr/local/bin/entrypoint.sh

# run rtkrcv
EXPOSE 8077 8078 8001-8008
#VOLUME ["/data/rtk", "/etc/ntripcaster"]
VOLUME /data/rtk
#CMD ["/usr/local/bin/ntripcaster", "/etc/ntripcaster/config.json"]

ENTRYPOINT ["/usr/local/bin/rtkrcv", "-p" ,"8077" ,"-m" ,"8078" ,"-o" ,"/data/rtk/rtkrcv.conf"]
#CMD ["/usr/local/bin/rtkrcv", "-p", "8077", "-m", "8078", "-o", "/data/rtk/rtkrcv.conf"] 
#ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
#ENTRYPOINT ["/bin/bash"]


