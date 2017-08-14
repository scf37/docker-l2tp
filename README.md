# l2tp
IPsec/L2TP Docker image.

##W hat is this

Docker image containing working IPSec/L2TP VPN server using CHAP2 authentication.

It is intended for single-user usage so auth will accept any username with correct password.

## Howto
 
1. edit /etc/sysctl.conf:

    `net.ipv4.ip_forward = 1`
2. refresh sysctl

    `sysctl -p`
3. if you want to to access Internet via this VPN, run

    `iptables -t nat -A POSTROUTING -s 10.0.5.0/24 -o eth0 -j MASQUERADE`
4. `docker create --name cvpn2 --restart always --privileged --net=host -v /lib/modules:/lib/modules -v /data/l2tp:/data -e L2TP_PASSWORD=helloworld -e LISTEN_ADDR=41.42.43.44 scf37/l2tp`

## Advanced topics

### Configuration

Container will copy default configuration to /data/conf NOT overwriting existing files. So feel free to modify configs at /data/l2tp/conf on host as you wish.

### Limitations

I was unable to make L2TP work when client is behind NAT with default rsasig authentication. However, for some blizzare reason Windows VPN client with PSK auth works behind NAT!

Unfortunately, my router does not support PSK and configuring L2TP client for Linux is too much pain.
