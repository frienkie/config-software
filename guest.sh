#!/bin/sh


cat << "EOF" > /etc/init.d/guest_wifi
#!/bin/bash /etc/rc.common

TYPE="WPA2"
TRDISABLE="1"
SSID="_optout_nomap"
ENCRYPTION="psk-mixed"
TIMEOUT="60" # サービス停止までの時間

START=99
STOP=01

start() {
    DEL=`atq | awk '{ print $1 }' | sed -n 1p`
    if [ ${DEL} ]; then
    atrm ${DEL}
    fi
    echo "Please disable the service don't use guest Wi-Fi." > /root/.guest_comment1
    echo $TYPE > /root/.guest_type
    RANDOM_SSID="`openssl rand -base64 6`${SSID}"
    echo ${RANDOM_SSID} > /root/.guest_ssid
    PASSWORD=`openssl rand -base64 6`
    echo $PASSWORD > /root/.guest_password
    FOREGROUND=`openssl rand -hex 3`
    qrencode --foreground=${FOREGROUND} --inline --type=SVG --output=- --size 3 "WIFI:S:${RANDOM_SSID};T:${TYPE};R:${TRDISABLE};P:${PASSWORD};;" > /root/.guest_qr
    echo "color="yellow">Stops after "${TIMEOUT}" min @"  > /root/.guest_comment2
    WIFI_DEV="$(uci get wireless.@wifi-iface[0].device)"
    uci -q delete wireless.guest
    uci set wireless.guest="wifi-iface"
    uci set wireless.guest.device="${WIFI_DEV}"
    uci set wireless.guest.mode="ap"
    uci set wireless.guest.network="lan"
    uci set wireless.guest.ssid="${RANDOM_SSID}"
    uci set wireless.guest.encryption="${ENCRYPTION}"
    uci set wireless.guest.key="${PASSWORD}"
    uci set wireless.guest.macaddr="random"
    uci set wireless.guest.multicast_to_unicast_all='1'
    uci set wireless.guest.isolate='1'
    uci delete wireless.${WIFI_DEV}.disabled
    uci commit wireless
    wifi reload
    logger "perimeter Wi-Fi Guest ON"
    echo "service guest_wifi stop" | at now +${TIMEOUT} minutes
    exit 0
}

restart() {
    exit 0
}
stop() {
    DEL=`atq | awk '{ print $1 }' | sed -n 1p`
    if [ ${DEL} ]; then
    atrm ${DEL}
    fi
    echo "Please enable the service to use guest Wi-Fi." > /root/.guest_comment1
    qrencode --foreground="808080" --background="0000FF" --inline --type=SVG --output=- --size 3 "WIFI:S:Out of service.;T:WPA2;R:1;P:Out of service.;;" > /root/.guest_qr
    echo "color="red">Out of service"  > /root/.guest_comment2
    echo > /root/.guest_type
    echo > /root/.guest_ssid
    echo > /root/.guest_password
    uci -q delete wireless.guest
    uci commit wireless
    wifi reload
    logger "perimeter Guest Wi-Fi OFF"
    exit 0
}

EOF
chmod +x /etc/init.d/guest_wifi


cat << "EOF" > /www/cgi-bin/guest
#!/bin/bash

QR=$(</root/.guest_qr)
TYPE=$(</root/.guest_type)
SSID=$(</root/.guest_ssid)
PASSWORD=$(</root/.guest_password)
COMMENT1=$(</root/.guest_comment1)
COMMENT2=$(</root/.guest_comment2)
TIMEOUT=`atq | awk '{ print $5 }' | cut -d':' -f1,2`

echo "Content-Type: text/html"
echo ""
echo "<!DOCTYPE html>"
echo '<html lang="UTF-8">'
echo "<head>"
echo "<title>Guest Wi-Fi</title>"
echo '<meta name="viewport" content="width=device-width, height=device-height, initial-scale=1.0, minimum-scale=1.0">'
echo '<meta http-equiv="Cache-Control" content="no-cache, no-store, must-revalidate">'
echo '<meta http-equiv="Pragma" content="no-cache">'
echo '<meta http-equiv="Expires" content="0">'
echo "</head>"
echo '<body bgcolor="blue">'
echo "<div style='text-align:center;color:#fff;font-family:UnitRoundedOT,Helvetica Neue,Helvetica,Arial,sans-serif;font-size:28px;font-weight:500;'>"
echo "<h1>Guest Wi-Fi</h1>"
echo "<p><font>${COMMENT1}</font></p>"
echo "${QR}<br>"
echo "<p><font ${COMMENT2}<b>${TIMEOUT}.</b></font></p>"
echo "<p>${TYPE}</p>"
echo "<p>${SSID}</p>"
echo "<p>${PASSWORD}</p>"
echo "</div>"
echo "</body>"
echo "</html>"
EOF
chmod +x /www/cgi-bin/guest


cat << "EOF" > /www/guest.html
<?xml version="1.0" encoding="utf-8"?>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.1//EN" "http://www.w3.org/TR/xhtml11/DTD/xhtml11.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Cache-Control" content="no-cache, no-store, must-revalidate" />
<meta http-equiv="Pragma" content="no-cache" />
<meta http-equiv="Expires" content="0" />
<meta http-equiv="refresh" content="0; URL=cgi-bin/guest" />
<style type="text/css">
body { background: white; font-family: arial, helvetica, sans-serif; }
a { color: black; }
@media (prefers-color-scheme: dark) {
body { background: black; }
a { color: white; }
}
</style>
</head>
<body>
<a href="cgi-bin/guest/style.css?ver=240313" rel="stylesheet">LuCI - Lua Configuration Interface</a>
</body>
</html>
EOF
chmod +r /www/guest.html
echo -e " \033[1;37mIf a white QR code appears, it's a miracle.\033[0;39m"
