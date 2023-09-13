#! /bin/sh

function _func_AdBlock {
while :
do
if [ "adblock" = "`opkg list-installed adblock | awk '{ print $1 }'`" ]; then
  echo -e " \033[1;37mAdBlockが既にインストールされています\033[0;39m"
fi
if [ "adblock-fast" = "`opkg list-installed adblock-fast | awk '{ print $1 }'`" ]; then
  echo -e " \033[1;37mAdBlock-fastが既にインストールされています\033[0;39m"
fi
  echo -e " \033[1;34mAdBlock ----------------------------------------------\033[0;39m"
  echo -e " \033[1;34m[a]\033[0;39m": AdBlockのインストールと設定（カスタムフィルターアドイン）
  echo -e " \033[1;32m[f]\033[0;39m": AdBlock-fastのインストールと設定（カスタムフィルターアドイン）
  echo -e " \033[1;31m[b]\033[0;39m": AdBlockのリムーブと以前の設定に復元
  echo -e " \033[1;33m[t]\033[0;39m": AdBlock-fastのリムーブと以前の設定に復元
  echo -e " \033[1;37m[q]\033[0;39m": 終了    
  echo -e " \033[1;34m------------------------------------------------------\033[0;39m"
  read -p " キーを選択して下さい [e/f/b/t or q]: " num
  case "${num}" in
    "a" ) _func_AdBlock_Confirm ;;
    "f" ) _func_AdBlock_fast_Confirm ;;
    "b" ) _func_AdBlock_Before ;;
    "t" ) _func_AdBlock_fast_Before ;;
    "q" ) exit ;;
  esac
done
}

function _func_AdBlock_fast_Confirm {
UPDATE="/tmp/opkg-lists/openwrt_telephony.sig"
if [ ! -e ${UPDATE} ]; then
opkg update
fi
while :
do
  ADBLOCK_FAST_VERSION=`opkg info adblock-fast | grep Version | awk '{ print $2 }'`
  echo -e " \033[1;32mインストール: adblock-fast $((`opkg info adblock-fast | grep Size | awk '{ print $2 }'`/1024))KB Version ${ADBLOCK_FAST_VERSION}\033[0;39m"
  echo -e " \033[1;32mインストール: luci-app-adblock-fast $((`opkg info luci-app-adblock-fast | grep Size | awk '{ print $2 }'`/1024))KB\033[0;39m"
  echo -e " \033[1;32mインストール: luci-i18n-adblock-fast-ja $((`opkg info luci-i18n-adblock-fast-ja | grep Size | awk '{ print $2 }'`/1024))KB\033[0;39m"
  echo -e " \033[1;32mアドイン: 豆腐フィルタ（有効）\033[0;39m"
  echo -e " \033[1;32mAdBlock-fastの設定とインストールを開始します\033[0;39m"
  read -p " 開始します [y/n]: " num
  case "${num}" in
    "y" ) _func_AdBlock_fast_SET ;;
    "n" ) break ;;
  esac
done
}

function _func_AdBlock_fast_SET {
wget --no-check-certificate -O /etc/config-software/adblock-fast.sh https://raw.githubusercontent.com/site-u2023/config-software/main/adblock-fast.sh
sh /etc/config-software/adblock-fast.sh 2> /dev/null
read -p " 何かキーを押してデバイスを再起動して下さい"
reboot
exit
}

function _func_AdBlock_Confirm {
UPDATE="/tmp/opkg-lists/openwrt_telephony.sig"
if [ ! -e ${UPDATE} ]; then
opkg update
fi
while :
do
  ADBLOCK_VERSION=`opkg info adblock | grep Version | awk '{ print $2 }'`
  echo -e " \033[1;32mインストール: adblock $((`opkg info adblock | grep Size | awk '{ print $2 }'`/1024))KB Version ${ADBLOCK_VERSION}\033[0;39m"
  echo -e " \033[1;32mインストール: luci-app-adblock $((`opkg info luci-app-adblock | grep Size | awk '{ print $2 }'`/1024))KB\033[0;39m"
  echo -e " \033[1;32mインストール: luci-i18n-adblock-ja $((`opkg info luci-i18n-adblock-ja | grep Size | awk '{ print $2 }'`/1024))KB\033[0;39m"
  echo -e " \033[1;32mインストール: tcpdump-mini $((`opkg info tcpdump-mini | grep Size | awk '{ print $2 }'`/1024))KB\033[0;39m"
  echo -e " \033[1;32mアドイン: 豆腐フィルタ（有効）\033[0;39m"
  echo -e " \033[1;34mAdBlockの設定とインストールを開始します\033[0;39m"
  read -p " 開始します [y/n]: " num
  case "${num}" in
    "y" ) _func_AdBlock_SET ;;
    "n" ) break ;;
  esac
done
}

function _func_AdBlock_SET {
wget --no-check-certificate -O /etc/config-software/adblock.sh https://raw.githubusercontent.com/site-u2023/config-software/main/adblock.sh
sh /etc/config-software/adblock.sh
read -p " 何かキーを押してデバイスを再起動して下さい"
reboot
exit
}

function _func_AdBlock_fast_Before {
while :
do
  echo -e " \033[1;33mAdblock-fastの設定を以前の設定に復元します\033[0;39m"
  echo -e " \033[1;37mリムーブ: adblock-fast\033[0;39m"
  echo -e " \033[1;37mリムーブ: luci-app-adblock-fast\033[0;39m"
  echo -e " \033[1;37mリムーブ: luci-i18n-adblock-fast-ja\033[0;39m"
  # echo -e " \033[1;37mリムーブ: tcpdump-mini\033[0;39m"
  read -p " 本当に宜しいですか? [y/n or r]: " num
  case "${num}" in
    "y" ) _func_AdBlock_fast_Restoration ;;
    "n" ) _func_AdBlock ;;
    "r" ) _func_AdBlock ;;
  esac
done
}

function _func_AdBlock_fast_Restoration {
service adblock-fast stop
service adblock-fast disable
opkg remove luci-i18n-adblock-fast-ja
opkg remove luci-app-adblock-fast
opkg remove adblock-fast
opkg remove ip6tables-mod-nat
opkg remove kmod-ipt-nat6
opkg --force-overwrite remove gawk grep sed coreutils-sort
rm -rf /etc/adblock-fast
read -p " 何かキーを押してデバイスを再起動して下さい"
reboot
exit
}

function _func_AdBlock_Before {
while :
do
  echo -e " \033[1;31mAdBlockの設定を以前の設定に復元します\033[0;39m"
  echo -e " \033[1;37mリムーブ: adblock\033[0;39m"
  echo -e " \033[1;37mリムーブ: luci-app-adblock\033[0;39m"
  echo -e " \033[1;37mリムーブ: luci-i18n-adblock-ja\033[0;39m"
  echo -e " \033[1;37mリムーブ: tcpdump-mini\033[0;39m"
  read -p " 本当に宜しいですか? [y/n or r]: " num
  case "${num}" in
    "y" ) _func_AdBlock_Restoration ;;
    "n" ) _func_AdBlock ;;
    "r" ) _func_AdBlock ;;
  esac
done
}

function _func_AdBlock_Restoration {
service adblock stop
service adblock disable
opkg remove luci-i18n-adblock-ja
opkg remove luci-app-adblock
opkg remove adblock
opkg remove tcpdump-mini
rm -rf /etc/adblock
read -p " 何かキーを押してデバイスを再起動して下さい"
reboot
exit
}


if [ "adguardhome" = "`opkg list-installed adguardhome | awk '{ print $1 }'`" ]; then
 read -p " AdGuardがインストールされている為終了します"
# exit
fi
OPENWRT_RELEAS=`grep -o '[0-9]*' /etc/openwrt_version`
if [ "${OPENWRT_RELEAS:0:2}" = "23" ] || [ "${OPENWRT_RELEAS:0:2}" = "22" ]; then
 echo -e " \033[1;37mバージョンチェック: OK\033[0;39m"
 _func_AdBlock
else
 read -p " バージョンが違うため終了します"
 exit
fi
