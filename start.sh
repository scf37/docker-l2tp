#!/bin/bash

function help {
    echo "IPsec/L2TP VPN service"
    echo "https://github.com/scf37/l2tp"
    echo "Runs IPsec/L2TP VPN service in docker container. Intended for home usage."
    echo "Params (must be passed via environment variables):"
    echo "    L2TP_PASSWORD password for CHAP2 authentication"
    echo "    LISTEN_ADDR Host interface IP for VPN to listen on"
    echo "Run string: docker run -it --rm --privileged --net=host -v /lib/modules:/lib/modules -v /data:/data/l2tp scf37/l2tp"
    
}

if [ ! -d "/lib/modules" ]; then
    echo "Error: container requires privileged mode"
    echo
    help

    exit 1
fi


mkdir -p /data/conf
cp -rn /opt/conf/* /data/conf/

if [ -z "$L2TP_PASSWORD" ] && grep -rq '$L2TP_PASSWORD' /data/conf  ; then
    echo "Error: L2TP_PASSWORD environment variable is not set"
    echo
    help
    exit 1
fi

if [ -z "$LISTEN_ADDR" ] && grep -rq '$LISTEN_ADDR' /data/conf  ; then
    echo "Error: LISTEN_ADDR environment variable is not set"
    echo
    help
    exit 1
fi



cd /data/conf
find . -type f | while read N
do
      mkdir -p /`dirname $N`
      cat $N | envsubst '$L2TP_PASSWORD;$LISTEN_ADDR' > /$N
done

echo "IPsec/L2TP VPN service"
echo "https://github.com/scf37/l2tp"
echo


service ipsec start

mkdir /var/run/xl2tpd
xl2tpd -D

