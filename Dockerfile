FROM scf37/base:latest

ENV XL2TPD_VERSION 1.3.7

RUN apt-get update \
    && apt-get install -y dnsutils python iptables lsof openswan gettext make g++ libssl-dev libpcap0.8-dev \
    && mkdir /opt/xl2tpd && cd /opt/xl2tpd \
    && wget https://github.com/xelerance/xl2tpd/archive/v${XL2TPD_VERSION}.tar.gz \
    && tar xf v${XL2TPD_VERSION}.tar.gz \
    && cd xl2tpd-${XL2TPD_VERSION} && make && make install \
    && apt-get remove -y make g++ && \
    #remove artifacts not covered by previous command (for some reasons)
    apt-get remove -y cpp-4.8 gcc-4.8 manpages manpages-dev && \
    apt-get autoremove -y && \
    find /usr/lib -name "*.a" -exec rm -rf {} \; && \
    rm -rf /usr/include && \
    rm -rf /usr/share/doc && \
    rm -rf /usr/share/man && \
    rm -rf /var/lib/apt/lists/* && \
    rm -rf /opt/*

COPY etc /opt/conf/etc
COPY start.sh /start.sh

ENTRYPOINT /start.sh