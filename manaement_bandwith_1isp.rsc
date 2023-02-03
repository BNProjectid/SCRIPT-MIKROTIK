
############################SCRIPT MANAGEMENT BANDWITH#######################

/queue type
add kind=pfifo name=piffo-packet pfifo-limit=5000
add kind=sfq name="sfq-game [beta]" sfq-allot=15140 sfq-perturb=1000
/queue tree
add name="GLOBAL TRAFFIC" parent=global queue=default
add max-limit=150M name="TOTAL DOWNLOAD" parent="GLOBAL TRAFFIC" queue=\
    pcq-download-default
add max-limit=100M name="TOTAL UPLOAD" parent="GLOBAL TRAFFIC" queue=\
    pcq-upload-default
add name="1.GAME DOWNLOAD" packet-mark=Game-Download parent="TOTAL DOWNLOAD" \
    priority=1 queue=pcq-download-default
add name="1.GAME UPLOAD" packet-mark=Game-Upload parent="TOTAL UPLOAD" \
    priority=1 queue=pcq-upload-default
add name="2.ICMP-DNS DOWNLOAD" packet-mark=ICMP-DNS-Download parent=\
    "TOTAL DOWNLOAD" queue=pcq-download-default
add name="2.ICMP-DNS UPLOAD" packet-mark=ICMP-DNS-Upload parent=\
    "TOTAL UPLOAD" queue=pcq-upload-default
add max-limit=150M name="3.ALL-TRAFFIC DOWNLOAD" parent="TOTAL DOWNLOAD" \
    queue=pcq-download-default
add max-limit=50M name="3.ALL-TRAFFIC UPLOAD" parent="TOTAL UPLOAD" queue=\
    pcq-upload-default
add limit-at=7M max-limit=50M name=1.UMUM-Download packet-mark=Umum-Download \
    parent="3.ALL-TRAFFIC DOWNLOAD" priority=7 queue=pcq-download-default
add limit-at=5M max-limit=30M name=1.UMUM-Upload packet-mark=Umum-Upload \
    parent="3.ALL-TRAFFIC UPLOAD" priority=7 queue=pcq-upload-default
add limit-at=1M max-limit=50M name=2.YOUTUBE-Download packet-mark=\
    Youtube-Download parent="3.ALL-TRAFFIC DOWNLOAD" priority=5 queue=\
    pcq-download-default
add limit-at=5M max-limit=30M name=2.YOUTUBE-Upload packet-mark=\
    Youtube-Upload parent="3.ALL-TRAFFIC UPLOAD" priority=5 queue=\
    pcq-upload-default
add limit-at=1M max-limit=20M name=3.Whatsapp-Download packet-mark=\
    Whatsapp-Download parent="3.ALL-TRAFFIC DOWNLOAD" priority=2 queue=\
    pcq-download-default
add limit-at=2M max-limit=50M name="4. Sosmed-Download" packet-mark=\
    Sosmed-Download parent="3.ALL-TRAFFIC DOWNLOAD" priority=4 queue=\
    pcq-download-default
add limit-at=2M max-limit=30M name=5.Marketplace-Download packet-mark=\
    Marketplace-Download parent="3.ALL-TRAFFIC DOWNLOAD" priority=3 queue=\
    pcq-download-default
add limit-at=5M max-limit=30M name=3.Whatsapp-Upload packet-mark=\
    Whatsapp-Upload parent="3.ALL-TRAFFIC UPLOAD" priority=2 queue=\
    pcq-upload-default
add limit-at=5M max-limit=30M name=4.Sosmed-Upload packet-mark=Sosmed-Upload \
    parent="3.ALL-TRAFFIC UPLOAD" priority=3 queue=pcq-upload-default
add limit-at=5M max-limit=30M name=5.Marketplac-Upload packet-mark=\
    Marketplace-Upload parent="3.ALL-TRAFFIC UPLOAD" priority=4 queue=\
    pcq-upload-default

/ip firewall address-list
add address=0.0.0.0/8 list=IP-Lokal
add address=10.0.0.0/8 list=IP-Lokal
add address=100.64.0.0/10 list=IP-Lokal
add address=127.0.0.0/8 list=IP-Lokal
add address=169.254.0.0/16 list=IP-Lokal
add address=172.16.0.0/12 list=IP-Lokal
add address=192.0.0.0/24 list=IP-Lokal
add address=192.0.2.0/24 list=IP-Lokal
add address=192.168.0.0/16 list=IP-Lokal
add address=198.18.0.0/15 list=IP-Lokal
add address=198.51.100.0/24 list=IP-Lokal
add address=203.0.113.0/24 list=IP-Lokal
add address=224.0.0.0/3 list=IP-Lokal
add address=172.16.1.0/24 list=IP-Lokal
add address=172.16.3.0/24 list=IP-Lokal

/ip firewall mangle
add action=change-ttl chain=postrouting comment=\
    " - change TTL by buananetpbun.github.io" dst-address=172.16.1.0/24 \
    new-ttl=set:1 out-interface=ether2 passthrough=no
add action=mark-connection chain=prerouting comment=ICMP-DNS \
    dst-address-list=!IP-Lokal new-connection-mark=ICMP-DNS passthrough=yes \
    protocol=icmp src-address-list=IP-Lokal
add action=mark-connection chain=prerouting dst-address-list=!IP-Lokal \
    dst-port=53 new-connection-mark=ICMP-DNS passthrough=yes protocol=udp \
    src-address-list=IP-Lokal
add action=mark-packet chain=forward connection-mark=ICMP-DNS in-interface=\
    pppoe-out1 new-packet-mark=ICMP-DNS-Download passthrough=no
add action=mark-packet chain=forward connection-mark=ICMP-DNS \
    new-packet-mark=ICMP-DNS-Upload out-interface=pppoe-out1 passthrough=no
add action=mark-connection chain=postrouting comment="GAME ONLINE" \
    dst-address-list=IP-Game new-connection-mark=Game-Online passthrough=yes \
    src-address-list=IP-Lokal
add action=mark-packet chain=forward connection-mark=Game-Online \
    in-interface=pppoe-out1 new-packet-mark=Game-Download passthrough=no
add action=mark-packet chain=forward connection-mark=Game-Online \
    new-packet-mark=Game-Upload out-interface=pppoe-out1 passthrough=no
add action=mark-connection chain=postrouting comment="KONEKSI UMUM" \
    dst-address-list=IP-Umum new-connection-mark=Koneksi-Umum passthrough=yes \
    src-address-list=IP-Lokal
add action=mark-packet chain=forward connection-mark=Koneksi-Umum \
    in-interface=pppoe-out1 new-packet-mark=Umum-Download passthrough=no
add action=mark-packet chain=forward connection-mark=Koneksi-Umum \
    new-packet-mark=Umum-Upload out-interface=pppoe-out1 passthrough=no
add action=mark-connection chain=postrouting comment=YOUTUBE \
    dst-address-list=IP-Youtube new-connection-mark=Koneksi-Youtube \
    passthrough=yes src-address-list=IP-Lokal
add action=mark-packet chain=forward connection-mark=Koneksi-Youtube \
    in-interface=pppoe-out1 new-packet-mark=Youtube-Download passthrough=no
add action=mark-packet chain=forward connection-mark=Koneksi-Youtube \
    new-packet-mark=Youtube-Upload out-interface=pppoe-out1 passthrough=no
add action=mark-connection chain=postrouting comment=Whatsapp \
    dst-address-list=IP-Whatsapps new-connection-mark=Koneksi-Whatsapps \
    passthrough=yes src-address-list=IP-Lokal
add action=mark-packet chain=forward connection-mark=Koneksi-Whatsapps \
    in-interface=pppoe-out1 new-packet-mark=Whatsapp-Download passthrough=no
add action=mark-packet chain=forward connection-mark=Koneksi-Whatsapps \
    new-packet-mark=Whatsapp-Upload out-interface=pppoe-out1 passthrough=no
add action=mark-connection chain=postrouting comment=Sosmed dst-address-list=\
    IP-Sosmed new-connection-mark=Koneksi-Sosmed passthrough=yes \
    src-address-list=IP-Lokal
add action=mark-packet chain=forward connection-mark=Koneksi-Sosmed \
    in-interface=pppoe-out1 new-packet-mark=Sosmed-Download passthrough=no
add action=mark-packet chain=forward connection-mark=Koneksi-Sosmed \
    new-packet-mark=Sosmed-Upload out-interface=pppoe-out1 passthrough=no
add action=mark-connection chain=postrouting comment=Marketplace \
    dst-address-list=IP-Marketplace new-connection-mark=Koneksi-Marketplace \
    passthrough=yes src-address-list=IP-Lokal
add action=mark-packet chain=forward connection-mark=Koneksi-Marketplace \
    in-interface=pppoe-out1 new-packet-mark=Marketplace-Download passthrough=\
    no
add action=mark-packet chain=forward connection-mark=Koneksi-Marketplace \
    new-packet-mark=Marketplace-Upload out-interface=pppoe-out1 passthrough=\
    no

/ip firewall raw
add action=add-dst-to-address-list address-list=IP-Game address-list-timeout=\
    3h chain=prerouting comment=PUBG dst-address-list=!IP-Lokal dst-port=\
    10012,17500 protocol=tcp src-address-list=IP-Lokal
add action=add-dst-to-address-list address-list=IP-Game address-list-timeout=\
    3h chain=prerouting dst-address-list=!IP-Lokal dst-port="10491,10010,10013\
    ,10612,20002,20001,20000,12235,13748,13972,13894,11455,10096,10039" \
    protocol=udp src-address-list=IP-Lokal
add action=add-dst-to-address-list address-list=IP-Game address-list-timeout=\
    3h chain=prerouting comment="FREE FIRE" dst-address-list=!IP-Lokal \
    dst-port=\
    6006,6008,6674,7006-7008,7889,8001-8012,9006,9137,10000-10015,11000-11019 \
    protocol=tcp src-address-list=IP-Lokal
add action=add-dst-to-address-list address-list=IP-Game address-list-timeout=\
    3h chain=prerouting dst-address-list=!IP-Lokal dst-port=\
    12006,12008,13006,15006,20561,39003,39006,39698,39779,39800 protocol=tcp \
    src-address-list=IP-Lokal
add action=add-dst-to-address-list address-list=IP-Game address-list-timeout=\
    3h chain=prerouting dst-address-list=!IP-Lokal dst-port=\
    6006,6008,6674,7006-7008,7889,8008,8001-8012,8130,8443,9008,9120 \
    protocol=udp src-address-list=IP-Lokal
add action=add-dst-to-address-list address-list=IP-Game address-list-timeout=\
    3h chain=prerouting dst-address-list=!IP-Lokal dst-port=\
    10000-10015,10100,11000-11019,12008,13008 protocol=udp src-address-list=\
    IP-Lokal
add action=add-dst-to-address-list address-list=IP-Game address-list-timeout=\
    3h chain=prerouting comment="MOBILE LEGENDS" dst-address-list=!IP-Lokal \
    dst-port="5000-5221,5224-5227,5229-5241,5243-5287,5289-5352,5354-5509,5517\
    ,5520-5529" protocol=tcp src-address-list=IP-Lokal
add action=add-dst-to-address-list address-list=IP-Game address-list-timeout=\
    3h chain=prerouting dst-address-list=!IP-Lokal dst-port=\
    5551-5559,5601-5700,8443,9000-9010,9443,10003,30000-30300 protocol=tcp \
    src-address-list=IP-Lokal
add action=add-dst-to-address-list address-list=IP-Game address-list-timeout=\
    3h chain=prerouting dst-address-list=!IP-Lokal dst-port=\
    2702,3702,4001-4009,5000-5221,5224-5241,5243-5287,5289-5352,5354-5509 \
    protocol=udp src-address-list=IP-Lokal
add action=add-dst-to-address-list address-list=IP-Game address-list-timeout=\
    3h chain=prerouting dst-address-list=!IP-Lokal dst-port=\
    5517-5529,5551-5559,5601-5700,8001,8130 protocol=udp src-address-list=\
    IP-Lokal
add action=add-dst-to-address-list address-list=IP-Game address-list-timeout=\
    3h chain=prerouting dst-address-list=!IP-Lokal dst-port=\
    8443,9000-9010,9120,9992,10003,30000-30300 protocol=udp src-address-list=\
    IP-Lokal
add action=add-dst-to-address-list address-list=IP-Game address-list-timeout=\
    3h chain=prerouting comment=AOV dst-address-list=!IP-Lokal dst-port=\
    10001-10094 protocol=tcp src-address-list=IP-Lokal
add action=add-dst-to-address-list address-list=IP-Game address-list-timeout=\
    3h chain=prerouting dst-address-list=!IP-Lokal dst-port=\
    10101-10201,10080-10110,17000-18000 protocol=udp src-address-list=\
    IP-Lokal
add action=add-dst-to-address-list address-list=IP-Game address-list-timeout=\
    3h chain=prerouting comment="CALL OF DUTY" dst-address-list=!IP-Lokal \
    dst-port=3013,10000-10019,18082,50000,65010,65050 protocol=tcp \
    src-address-list=IP-Lokal
add action=add-dst-to-address-list address-list=IP-Game address-list-timeout=\
    3h chain=prerouting dst-address-list=!IP-Lokal dst-port=\
    7085-7995,8700,9030,10010-10019,17000-20100 protocol=tcp \
    src-address-list=IP-Lokal
add action=add-dst-to-address-list address-list=IP-Umum address-list-timeout=\
    3h chain=prerouting comment="PORT UMUM" dst-address-list=!IP-Lokal \
    dst-port=80,81,443,8000-8081,21,22,23,81,88,5050,843,182,53 protocol=tcp \
    src-address-list=IP-Lokal
add action=add-dst-to-address-list address-list=IP-Umum address-list-timeout=\
    3h chain=prerouting dst-address-list=!IP-Lokal dst-port=\
    80,81,443,8000-8081,21,22,23,81,88,5050,843,182,53 protocol=udp \
    src-address-list=IP-Lokal
add action=add-dst-to-address-list address-list=IP-Youtube \
    address-list-timeout=30m chain=prerouting comment=YOUTUBE content=\
    .youtube.com dst-address-list=!IP-Lokal src-address-list=IP-Lokal
add action=add-dst-to-address-list address-list=IP-Youtube \
    address-list-timeout=30m chain=prerouting content=.googlevideo.com \
    dst-address-list=!IP-Lokal src-address-list=IP-Lokal
add action=add-dst-to-address-list address-list=IP-Whatsapps \
    address-list-timeout=30m chain=prerouting comment=Whatsapp \
    dst-address-list=!IP-Lokal dst-port=\
    3478,4244,5222,5223,5228,5288,5242,5349,34784,45395,50318,59234 protocol=\
    tcp src-address-list=IP-Lokal
add action=add-dst-to-address-list address-list=IP-Whatsapps \
    address-list-timeout=30m chain=prerouting dst-address-list=!IP-Lokal \
    dst-port=3478,4244,5222,5223,5228,5288,5242,5349,34784,45395,50318,59234 \
    protocol=udp src-address-list=IP-Lokal
add action=add-dst-to-address-list address-list=IP-Whatsapps \
    address-list-timeout=30m chain=prerouting content=.whatsapp.com \
    dst-address-list=!IP-Lokal src-address-list=IP-Lokal
add action=add-dst-to-address-list address-list=IP-Whatsapps \
    address-list-timeout=30m chain=prerouting content=.whatsapp.net \
    dst-address-list=!IP-Lokal src-address-list=IP-Lokal
add action=add-dst-to-address-list address-list=IP-Whatsapps \
    address-list-timeout=30m chain=prerouting content=g.whatsapp.net \
    dst-address-list=!IP-Lokal src-address-list=IP-Lokal
add action=add-dst-to-address-list address-list=IP-Sosmed \
    address-list-timeout=30m chain=prerouting comment=Tiktok content=\
    .tiktok.com dst-address-list=!IP-Lokal src-address-list=IP-Lokal
add action=add-dst-to-address-list address-list=IP-Sosmed \
    address-list-timeout=30m chain=prerouting content=.tiktokv.com \
    dst-address-list=!IP-Lokal src-address-list=IP-Lokal
add action=add-dst-to-address-list address-list=IP-Sosmed \
    address-list-timeout=30m chain=prerouting content=.tiktokcdn.com \
    dst-address-list=!IP-Lokal src-address-list=IP-Lokal
add action=add-dst-to-address-list address-list=IP-Sosmed \
    address-list-timeout=30m chain=prerouting content=.ttlivecdn.com \
    dst-address-list=!IP-Lokal src-address-list=IP-Lokal
add action=add-dst-to-address-list address-list=IP-Sosmed \
    address-list-timeout=30m chain=prerouting comment=Facebook content=\
    .facebook.net dst-address-list=!IP-Lokal src-address-list=IP-Lokal
add action=add-dst-to-address-list address-list=IP-Sosmed \
    address-list-timeout=30m chain=prerouting content=.facebook.com \
    dst-address-list=!IP-Lokal src-address-list=IP-Lokal
add action=add-dst-to-address-list address-list=IP-Sosmed \
    address-list-timeout=30m chain=prerouting content=.fbcdn.net \
    dst-address-list=!IP-Lokal src-address-list=IP-Lokal
add action=add-dst-to-address-list address-list=IP-Sosmed \
    address-list-timeout=30m chain=prerouting comment=Instagram content=\
    .instagram.com dst-address-list=!IP-Lokal src-address-list=IP-Lokal
add action=add-dst-to-address-list address-list=IP-Sosmed \
    address-list-timeout=30m chain=prerouting content=.cdninstagram.com \
    dst-address-list=!IP-Lokal src-address-list=IP-Lokal
add action=add-dst-to-address-list address-list=IP-Marketplace \
    address-list-timeout=30m chain=prerouting comment=Shoppe content=\
    .shopeemobile.com dst-address-list=!IP-Lokal src-address-list=IP-Lokal
add action=add-dst-to-address-list address-list=IP-Marketplace \
    address-list-timeout=30m chain=prerouting content=shopee.co.id \
    dst-address-list=!IP-Lokal src-address-list=IP-Lokal
add action=add-dst-to-address-list address-list=IP-Marketplace \
    address-list-timeout=30m chain=prerouting content=.shopee.co.id \
    dst-address-list=!IP-Lokal src-address-list=IP-Lokal
add action=add-dst-to-address-list address-list=IP-Marketplace \
    address-list-timeout=30m chain=prerouting content=.shopee.com \
    dst-address-list=!IP-Lokal src-address-list=IP-Lokal
add action=add-dst-to-address-list address-list=IP-Marketplace \
    address-list-timeout=30m chain=prerouting comment=Tokopedia content=\
    .tokopedia.com dst-address-list=!IP-Lokal src-address-list=IP-Lokal
add action=add-dst-to-address-list address-list=IP-Marketplace \
    address-list-timeout=30m chain=prerouting content=.tokopedia.net \
    dst-address-list=!IP-Lokal src-address-list=IP-Lokal
add action=add-dst-to-address-list address-list=IP-Marketplace \
    address-list-timeout=30m chain=prerouting comment=Lazada content=\
    .lazada.co.id dst-address-list=!IP-Lokal src-address-list=IP-Lokal
add action=add-dst-to-address-list address-list=IP-Marketplace \
    address-list-timeout=30m chain=prerouting content=.lazada.com \
    dst-address-list=!IP-Lokal src-address-list=IP-Lokal
add action=add-dst-to-address-list address-list=IP-Marketplace \
    address-list-timeout=30m chain=prerouting content=.lazada. \
    dst-address-list=!IP-Lokal src-address-list=IP-Lokal
add action=add-dst-to-address-list address-list=IP-Marketplace \
    address-list-timeout=30m chain=prerouting content=.alicdn.com \
    dst-address-list=!IP-Lokal src-address-list=IP-Lokal
