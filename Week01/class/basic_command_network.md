**ST446 Distributed Computing for Big Data**
# Basic Network Commands

In this exercise, we demonstrate how to check your network settings and latency from a command line interface.

## 1. Find the hostname

A hostname is a label that is assigned to a device connected to a computer network and that is used to identify the device in various forms of electronic communication. We can use `hostname` to set or print the name of the current host.

Example:
```
LSE021353:week01 vojnovic$ hostname
LSE021353
```
For more about hostname command, run `man hostname`. You may do this for any other commands mentioned below.

## 2. Get the domain name / IP address

To obtain domain name or IP address (Internet Protocol address, a numerical label assigned to each device connected to a computer network) mapping, we can use `nslookup` or `host`.

### `nslookup`
`nslookup` querys the Domain Name System (DNS) interactively to obtain domain name or IP address mapping or for any other specific DNS record.

* Example using hostname:
    ```
    LSE021353:week01 vojnovic$ nslookup LSE021353
    Server:                   192.168.43.1
    Address:                192.168.43.1#53

    Name:   LSE021353
    Address: 192.168.43.103
    ```
* localhost (the default name describing the local computer address):
    ```
    LSE021353:week01 vojnovic$ nslookup localhost
    Server:                   192.168.43.1
    Address:                192.168.43.1#53

    Name:   localhost
    Address: 127.0.0.1
    ```
    ```
    LSE021353:week01 vojnovic$ nslookup 127.0.0.1
    Server:                   192.168.43.1
    Address:                192.168.43.1#53

    1.0.0.127.in-addr.arpa     name = localhost.
    ```

* External webpage example:
    ```
    LSE021353:week01 vojnovic$ nslookup console.cloud.google.com
    Server:                   192.168.43.1
    Address:                192.168.43.1#53

    Non-authoritative answer:
    console.cloud.google.com               canonical name = www3.l.google.com.
    Name:   www3.l.google.com
    Address: 172.217.23.14
    ```

### `host` (for linux/mac)
You should get the results similar to what you get from `nslookup`

Example:
```
LSE021353:week01 vojnovic$ host console.cloud.google.com
console.cloud.google.com is an alias for www3.l.google.com.
www3.l.google.com has address 172.217.23.14
www3.l.google.com has IPv6 address 2a00:1450:4009:806::200e
```

## 3. Test the connection and latency between two network connections

### `ping`
We use `ping` to test the reachability of a host on an Internet Protocol network.

* Example using wrong address:
    ```
    LSE021353:week01 vojnovic$ ping 127.0.0.0
    PING 127.0.0.0 (127.0.0.0): 56 data bytes
    Request timeout for icmp_seq 0
    Request timeout for icmp_seq 1
    Request timeout for icmp_seq 2
    Request timeout for icmp_seq 3
    ```

* localhost:
    ```
    LSE021353:week01 vojnovic$ ping 127.0.0.1
    PING 127.0.0.1 (127.0.0.1): 56 data bytes
    64 bytes from 127.0.0.1: icmp_seq=0 ttl=64 time=0.057 ms
    64 bytes from 127.0.0.1: icmp_seq=1 ttl=64 time=0.070 ms
    64 bytes from 127.0.0.1: icmp_seq=2 ttl=64 time=0.070 ms
    64 bytes from 127.0.0.1: icmp_seq=3 ttl=64 time=0.072 ms
    ^C
    --- 127.0.0.1 ping statistics ---
    4 packets transmitted, 4 packets received, 0.0% packet loss
    round-trip min/avg/max/stddev = 0.057/0.067/0.072/0.006 ms
    ```

* external website:
    ```
    LSE021353:week01 vojnovic$ ping console.cloud.google.com
    PING www3.l.google.com (172.217.23.14): 56 data bytes
    64 bytes from 172.217.23.14: icmp_seq=0 ttl=52 time=46.006 ms
    64 bytes from 172.217.23.14: icmp_seq=1 ttl=52 time=75.237 ms
    Request timeout for icmp_seq 2
    64 bytes from 172.217.23.14: icmp_seq=3 ttl=52 time=45.711 ms
    64 bytes from 172.217.23.14: icmp_seq=4 ttl=52 time=90.190 ms
    64 bytes from 172.217.23.14: icmp_seq=5 ttl=52 time=78.560 ms
    64 bytes from 172.217.23.14: icmp_seq=6 ttl=52 time=98.804 ms
    ^C
    --- www3.l.google.com ping statistics ---
    7 packets transmitted, 6 packets received, 14.3% packet loss
    round-trip min/avg/max/stddev = 45.711/72.418/98.804/20.284 ms
    ```

As you can imagine, round-trip time for localhost is faster than external website

### `traceroute`

`traceroute` is a computer network diagnostic tool for displaying the route and measuring transit delays of packets across an Internet Protocol network. The window equivalent is `tracert`

* Example on localhost:

    ```
    LSE021353:week01 vojnovic$ traceroute 127.0.0.1
    traceroute to 127.0.0.1 (127.0.0.1), 64 hops max, 52 byte packets
     1  localhost (127.0.0.1)  0.279 ms  0.056 ms  0.035 ms
    ```
* External website:

    ```
    LSE021353:week01 vojnovic$ traceroute console.cloud.google.com
    traceroute to www3.l.google.com (172.217.23.14), 64 hops max, 52 byte packets
     1  192.168.43.1 (192.168.43.1)  44.813 ms  3.198 ms  3.526 ms
     2  * * *
     3  192.168.213.21 (192.168.213.21)  56.204 ms  37.625 ms  26.938 ms
     4  192.168.213.22 (192.168.213.22)  29.471 ms  36.144 ms  34.486 ms
     5  * * *
     6  * * *
     7  63.130.105.130 (63.130.105.130)  37.598 ms  37.925 ms  37.641 ms
     8  72.14.216.237 (72.14.216.237)  42.412 ms  45.101 ms  34.594 ms
     9  108.170.246.193 (108.170.246.193)  31.672 ms  46.573 ms  61.272 ms
    10  108.170.233.199 (108.170.233.199)  51.453 ms
        108.170.233.197 (108.170.233.197)  66.801 ms
        108.170.233.199 (108.170.233.199)  103.359 ms
    11  lhr35s01-in-f14.1e100.net (172.217.23.14)  37.355 ms  48.363 ms  38.504 ms
    ```

## 4. Network connection information

`netstat` displays information about network connections

```
LSE021353:week01 vojnovic$ netstat
Active Internet connections
Proto Recv-Q Send-Q  Local Address          Foreign Address        (state)    
tcp4       0      0  lse021353.54260        52.109.12.21.https     ESTABLISHED
tcp4       0      0  lse021353.54259        lhr25s09-in-f10..https ESTABLISHED
tcp4       0      0  localhost.49167        localhost.54258        ESTABLISHED
tcp4       0      0  localhost.54258        localhost.49167        ESTABLISHED
tcp4       0      0  lse021353.54255        17.167.192.225.https   ESTABLISHED
tcp4       0      0  lse021353.54253        lhr35s05-in-f14..https ESTABLISHED
tcp4       0      0  localhost.49167        localhost.54252        ESTABLISHED
tcp4       0      0  localhost.54252        localhost.49167        ESTABLISHED
tcp4       0      0  lse021353.54246        40.101.73.162.https    ESTABLISHED
tcp4       0      0  lse021353.54245        40.101.73.162.https    ESTABLISHED
tcp4       0      0  lse021353.54242        lhr35s01-in-f14..https ESTABLISHED
tcp4       0      0  localhost.49167        localhost.54241        ESTABLISHED
tcp4       0      0  localhost.54241        localhost.49167        ESTABLISHED
tcp4       0      0  lse021353.54240        lhr35s01-in-f14..https ESTABLISHED
tcp4       0      0  localhost.49167        localhost.54239        ESTABLISHED
tcp4       0      0  localhost.54239        localhost.49167        ESTABLISHED
tcp4       0      0  lse021353.54236        wo-in-f188.1e100.5228  ESTABLISHED
tcp4       0      0  localhost.49167        localhost.54235        ESTABLISHED
tcp4       0      0  localhost.54235        localhost.49167        ESTABLISHED
tcp4       0      0  lse021353.54234        ham11s01-in-f4.1.https ESTABLISHED
tcp4       0      0  localhost.49167        localhost.54233        ESTABLISHED
tcp4       0      0  localhost.54233        localhost.49167        ESTABLISHED
tcp4       0      0  lse021353.54230        remote.lse.ac.uk.https ESTABLISHED
tcp4       0      0  lse021353.54227        40.100.173.194.https   ESTABLISHED
tcp4       0      0  lse021353.54226        40.100.173.194.https   ESTABLISHED
tcp4       0      0  lse021353.54225        40.100.173.194.https   ESTABLISHED
tcp6       0      0  fe80::aede:48ff:.54223 fe80::aede:48ff:.61000 ESTABLISHED
tcp4      31      0  lse021353.54205        162.125.64.3.https     CLOSE_WAIT
tcp4      31      0  lse021353.54160        162.125.33.7.https     CLOSE_WAIT
tcp4       0      0  lse021353.54150        162.125.18.133.https   ESTABLISHED
tcp4       0      0  lse021353.54149        162.125.18.133.https   ESTABLISHED
tcp4       0      0  lse021353.54143        40.101.48.98.https     ESTABLISHED
tcp4       0      0  lse021353.54118        ws-in-f188.1e100.5228  FIN_WAIT_2
tcp4       0      0  lse021353.54061        17.252.12.89.5223      ESTABLISHED
tcp4       0      0  localhost.cslistener   localhost.53752        ESTABLISHED
tcp4       0      0  localhost.53752        localhost.cslistener   ESTABLISHED
tcp4       0      0  localhost.8031         localhost.53744        ESTABLISHED
tcp4       0      0  localhost.53744        localhost.8031         ESTABLISHED
tcp4       0      0  localhost.51015        localhost.51043        ESTABLISHED
tcp4       0      0  localhost.51043        localhost.51015        ESTABLISHED
tcp4       0      0  localhost.51014        localhost.51042        ESTABLISHED
tcp4       0      0  localhost.51013        localhost.51041        ESTABLISHED
tcp4       0      0  localhost.51042        localhost.51014        ESTABLISHED
tcp4       0      0  localhost.51012        localhost.51040        ESTABLISHED
tcp4       0      0  localhost.51041        localhost.51013        ESTABLISHED
tcp4       0      0  localhost.51040        localhost.51012        ESTABLISHED
tcp4       0      0  localhost.51013        localhost.51039        ESTABLISHED
tcp4       0      0  localhost.51039        localhost.51013        ESTABLISHED
tcp6       0      0  localhost.ddi-tcp-1    localhost.51019        ESTABLISHED
tcp6       0      0  localhost.51019        localhost.ddi-tcp-1    ESTABLISHED
tcp4       0      0  localhost.50208        localhost.50237        ESTABLISHED
tcp4       0      0  localhost.50237        localhost.50208        ESTABLISHED
tcp4       0      0  localhost.50207        localhost.50236        ESTABLISHED
tcp4       0      0  localhost.50236        localhost.50207        ESTABLISHED
tcp4       0      0  localhost.50206        localhost.50235        ESTABLISHED
tcp4       0      0  localhost.50235        localhost.50206        ESTABLISHED
tcp4       0      0  localhost.50207        localhost.50233        ESTABLISHED
tcp4       0      0  localhost.50233        localhost.50207        ESTABLISHED
tcp4       0      0  localhost.50209        localhost.50232        ESTABLISHED
tcp4       0      0  localhost.50232        localhost.50209        ESTABLISHED
tcp6       0      0  localhost.ddi-tcp-1    localhost.50214        ESTABLISHED
tcp6       0      0  localhost.50214        localhost.ddi-tcp-1    ESTABLISHED
tcp4       0      0  localhost.49323        localhost.49349        ESTABLISHED
tcp4       0      0  localhost.49349        localhost.49323        ESTABLISHED
tcp4       0      0  localhost.49321        localhost.49348        ESTABLISHED
tcp4       0      0  localhost.49348        localhost.49321        ESTABLISHED
tcp4       0      0  localhost.49322        localhost.49347        ESTABLISHED
tcp4       0      0  localhost.49347        localhost.49322        ESTABLISHED
tcp4       0      0  localhost.49321        localhost.49346        ESTABLISHED
tcp4       0      0  localhost.49346        localhost.49321        ESTABLISHED
tcp4       0      0  localhost.49320        localhost.49345        ESTABLISHED
tcp4       0      0  localhost.49345        localhost.49320        ESTABLISHED
tcp6       0      0  localhost.ddi-tcp-1    localhost.49327        ESTABLISHED
tcp6       0      0  localhost.49327        localhost.ddi-tcp-1    ESTABLISHED
tcp4       0      0  localhost.49294        localhost.49319        ESTABLISHED
tcp4       0      0  localhost.49319        localhost.49294        ESTABLISHED
tcp4       0      0  localhost.49293        localhost.49318        ESTABLISHED
tcp4       0      0  localhost.49318        localhost.49293        ESTABLISHED
tcp4       0      0  localhost.49292        localhost.49317        ESTABLISHED
tcp4       0      0  localhost.49317        localhost.49292        ESTABLISHED
tcp4       0      0  localhost.49295        localhost.49316        ESTABLISHED
tcp4       0      0  localhost.49316        localhost.49295        ESTABLISHED
tcp4       0      0  localhost.49293        localhost.49314        ESTABLISHED
tcp4       0      0  localhost.49314        localhost.49293        ESTABLISHED
tcp6       0      0  localhost.ddi-tcp-1    localhost.49299        ESTABLISHED
tcp6       0      0  localhost.49299        localhost.ddi-tcp-1    ESTABLISHED
tcp6      31      0  broadband.bt.com.49217 2620:100:6020:3:.https CLOSE_WAIT
tcp4       0      0  localhost.49154        localhost.49212        ESTABLISHED
tcp4       0      0  localhost.49212        localhost.49154        ESTABLISHED
tcp4       0      0  localhost.49153        localhost.1023         ESTABLISHED
tcp4       0      0  localhost.1023         localhost.49153        ESTABLISHED
tcp6       0      0  fe80::aede:48ff:.49164 fe80::aede:48ff:.52032 ESTABLISHED
tcp4       0      0  localhost.54249        localhost.cslistener   TIME_WAIT  
tcp4       0      0  lse021353.54256        17.167.194.230.https   TIME_WAIT  
tcp4       0      0  lse021353.54254        40.100.174.18.https    TIME_WAIT  
tcp4       0      0  lse021353.54251        40.101.73.162.https    TIME_WAIT  
tcp4       0      0  lse021353.54237        40.101.73.162.https    TIME_WAIT  
tcp4       0      0  lse021353.54250        lhr35s06-in-f10..https TIME_WAIT  
tcp4       0      0  lse021353.54243        52.109.12.21.https     TIME_WAIT  
tcp4       0      0  lse021353.54244        lhr35s05-in-f65..https TIME_WAIT  
udp6       0      0  *.62383                *.*                               
udp4       0      0  *.65249                *.*                               
udp4       0      0  *.55864                *.*                               
udp4       0      0  *.62629                *.*                               
udp4       0      0  *.51488                *.*                               
udp4       0      0  *.58222                *.*                               
udp4       0      0  *.54552                *.*                               
udp4       0      0  *.53482                *.*                               
udp4       0      0  158.143.244.143.ntp    *.*                               
udp4       0      0  *.51085                *.*                               
udp4       0      0  *.53655                *.*                               
udp4       0      0  *.61684                *.*                               
udp4       0      0  *.59265                *.*                               
udp4       0      0  lse021353.56854        *.*                               
…
```
