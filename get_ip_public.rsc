
########################Script Get IP PUBLIC#########################


add change-tcp-mss=yes name=pppoe-with-check on-up="# Variables\r\
    \n:local currentLocalSiteInterface \"pppoe-out1\"\r\
    \n:local privateRanges {192.168.0.0/16; 172.16.0.0/12; 10.0.0.0/8} \r\
    \n:local loopCount 20\r\
    \n\r\
    \n# Script\r\
    \n:local hadMatch\r\
    \n:local currentLoop 0\r\
    \n\r\
    \n:if ([/interface pppoe-client get [/interface pppoe-client find name=\$c\
    urrentLocalSiteInterface] running]) do={\r\
    \n   do {\r\
    \n      :set hadMatch false\r\
    \n      :local currentLocalSite [/ip address get [/ip address find interfa\
    ce=\$currentLocalSiteInterface] address]\r\
    \n      :local currentLocalSiteAddress ([:pick \$currentLocalSite 0 [:find\
    \_\$currentLocalSite \"/\"]] & \\\r\
    \n         (255.255.255.255 << (32 - [:pick \$currentLocalSite ([:find \$c\
    urrentLocalSite \"/\"] + 1) [:len \$currentLocalSite]]))) \r\
    \n         \r\
    \n      :foreach privateRange in=\$privateRanges do={ \r\
    \n         :if (([:pick \$privateRange 0 [:find \$privateRange \"/\"]] & \
    \\\r\
    \n            (255.255.255.255 << (32 - [:pick \$privateRange ([:find \$pr\
    ivateRange \"/\"] + 1) [:len \$privateRange]]))) = \\\r\
    \n            (\$currentLocalSiteAddress & (255.255.255.255 << (32 - [:pic\
    k \$privateRange ([:find \$privateRange \"/\"] + 1) [:len \$privateRange]]\
    )))) do={ \r\
    \n                /interface disable \$currentLocalSiteInterface\r\
    \n                :delay 2\r\
    \n                /interface enable \$currentLocalSiteInterface\r\
    \n                :set hadMatch true\r\
    \n            :log error \"WAN IP address matched private IP address - \$p\
    rivateRange\"\r\
    \n         } \r\
    \n      }\r\
    \n      :set currentLoop (\$currentLoop + 1)\r\
    \n  \r\
    \n      :if (\$hadMatch) do={\r\
    \n        :delay 2\r\
    \n      }\r\
    \n   } while ((\$currentLoop < \$loopCount) && (\$hadMatch))  \r\
    \n}"

/interface pppoe-client
add add-default-route=yes disabled=no interface=ether1 max-mtu=1500 name=\
    pppoe-out1 password=************** profile=pppoe-with-check user=***************