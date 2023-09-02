#! /bin/sh


function _func_AdGuard
while :
do
  echo -e " \033[1;34mAdGuard設定のスクリプトをダウンロードします\033[0;39m"
  read -p " 宜しいですか? [y/n]: " num
  case "${num}" in
    "y" ) wget --no-check-certificate -O /etc/config-software/adguard-config.sh https://raw.githubusercontent.com/site-u2023/config-software/main/adguard-config.sh
          sh /etc/config-software/adguard-config.sh
          break ;;
    "n" ) break ;;
  esac
done

function _func_AdBlock
while :
do
  echo -e " \033[1;32mAdBlock設定のスクリプトをダウンロードします\033[0;39m"
  read -p " 宜しいですか? [y/n]: " num
  case "${num}" in
    "y" ) wget --no-check-certificate -O /etc/config-software/adblock-config.sh https://raw.githubusercontent.com/site-u2023/config-software/main/adblock-config.sh
          sh /etc/config-software/adblock-config.sh
          break ;;
    "n" ) break ;;
  esac
done

while :
do
{
OPENWRT_RELEAS=`grep -o '[0-9]*' /etc/openwrt_version`
if [ "${OPENWRT_RELEAS:0:2}" = "23" ] || [ "${OPENWRT_RELEAS:0:2}" = "21" ] || [ "${OPENWRT_RELEAS:0:2}" = "22" ]; then
 echo -e " \033[1;37mバージョンチェック: OK\033[0;39m"
 else
 read -p " 非対応バージョンのため終了します"
 exit
fi
}
  echo -e " \033[1;37mad dns blockingconfig -------------------------------\033[0;39m"
  echo -e " \033[1;34m[g]\033[0;39m": AdGuard設定
  echo -e " \033[1;32m[b]\033[0;39m": AdBlock設定
  echo -e " \033[7;40m[q]\033[0;39m": 終了
  echo -e " \033[1;37m------------------------------------- August 27, 2023\033[0;39m"
  read -p " キーを選択してください [s/i/p/a or r/q]: " num
  case "${num}" in
    "g" ) _func_AdGuard ;;
    "b" ) _func_AdBlock ;;
    "q" ) exit ;;
  esac
 done 
