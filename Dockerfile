FROM arm64v8/ubuntu:latest as builder

ENV version=b31_mod_201906
ENV RTK_VER=demo5

RUN install_packages gfortran wget git

WORKDIR /data/rtk
ARG CONF_URL=https://raw.githubusercontent.com/rinex20/gnss_tools/master/conf/rtkrcv.conf
ARG RTKLIB_URL=https://github.com/rtklibexplorer/RTKLIB.git
# get conf file

# Get RTKLIB and compile only required components
RUN wget --no-check-certificate ${CONF_URL} -O rtkrcv.conf \
    && git clone --depth 1 --branch ${RTK_VER} ${RTKLIB_URL} \
    && (cd RTKLIB/lib/iers/gcc/; make) \
    && (cd RTKLIB/app/convbin/gcc/; make; make install) \
    && (cd RTKLIB/app/rnx2rtkp/gcc/; make; make install) \
    && (cd RTKLIB/app/pos2kml/gcc/; make; make install) \
    && (cd RTKLIB/app/str2str/gcc/; make; make install) \
    && (cd RTKLIB/app/rtkrcv/gcc/; make; make install) 


FROM arm64v8/ubuntu:latest
COPY --from=builder /usr/local/bin/* /usr/local/bin/

# run rtkrcv
EXPOSE 8077 8078 8001-8008
# CMD ["rtkrcv", "-p 8077 -m 8078 -o /data/rtk/conf/rtkrcv.conf"] 
CMD ["/usr/local/bin/rtkrcv", "-p", "8077", "-m", "8078", "-o" "/data/rtk/rtkrcv.conf"] 
