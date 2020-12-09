FROM ubuntu:18.04 as builder

ENV version=20201209
ENV RTK_VER=demo5
ARG CONF_URL=https://raw.githubusercontent.com/rinex20/gnss_tools/master/conf/rtkrcv.conf
ARG RTKLIB_URL=https://github.com/rtklibexplorer/RTKLIB.git
# get conf file

RUN apt-get update \
  && apt-get install -y build-essential \
  && apt-get install -y git wget gfortran tar libev-dev \
   && mkdir -p /data/rtk \
   && cd /data/rtk \
   && wget ${CONF_URL} -O /data/rtk/rtkrcv.conf \
   && git clone --depth 1 --branch ${RTK_VER} ${RTKLIB_URL} \
   && (cd RTKLIB/lib/iers/gcc/; make) \
   && (cd RTKLIB/app/str2str/gcc; make; make install) \
   && (cd RTKLIB/app/rtkrcv/gcc; make; make install)


FROM ubuntu:18.04
COPY --from=builder /usr/local/bin/* /usr/local/bin/
COPY --from=builder /data/rtk/rtkrcv.conf /data/
# run rtkrcv
EXPOSE 8077 8078 8001-8008
VOLUME /data/rtk
ENTRYPOINT ["/usr/local/bin/rtkrcv", "-p" ,"8077" ,"-m" ,"8078" ,"-o" ,"/data/rtkrcv.conf"]
#CMD /usr/local/bin/rtkrcv -p 8077 -m 8078 

