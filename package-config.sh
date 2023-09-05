#! /bin/sh
# OpenWrt >= 21.02:

OPENWRT_RELEAS=`grep -o '[0-9]*' /etc/openwrt_version`
if [ "${OPENWRT_RELEAS:0:2}" = "23" ] || [ "${OPENWRT_RELEAS:0:2}" = "21" ] || [ "${OPENWRT_RELEAS:0:2}" = "22" ]; then
 echo -e " \033[1;32mバージョンチェック: OK\033[0;39m"
else
 read -p " バージョンが違うため終了します"
 exit
fi

while :
do
  echo -e " \033[1;37mインストールは失敗する事があります\033[0;39m"
  echo -e " \033[1;34mpackage-config ---------------------------------------\033[0;39m"
  echo -e " \033[1;32m[f]\033[0;39m": 自動フルインストール（初心者向け）
  echo -e " \033[1;31m[c]\033[0;39m": 選択インストール
  echo -e " \033[1;37m[q]\033[0;39m": 終了
  echo -e " \033[1;37m------------------------------------------------------\033[0;39m"
  read -p " キーを選択してください [f/c or q]: " num 
  case "${num}" in
    "f" ) wget --no-check-certificate -O /etc/config-software/package-auto.sh https://raw.githubusercontent.com/site-u2023/config-software/main/package-auto.sh
          sh /etc/config-software/package-auto.sh ;;
    "c" ) wget --no-check-certificate -O /etc/config-software/package-manual.sh https://raw.githubusercontent.com/site-u2023/config-software/main/package-manual.sh
          sh /etc/config-software/package-manual.sh ;;
    "q" ) exit ;;
  esac
done
