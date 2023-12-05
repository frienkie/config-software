#! /bin/sh
# OpenWrt >= 21.02:


function _func_full_INST {
while :
do
  echo -e " \033[1;37mInstallation may fail\033[0;39m"
  echo -e " \033[1;37mpackage-config ---------------------------------------\033[0;39m"
  echo -e " \033[1;34m[f]: Japanese localisation\033[0;39m"
  echo -e " \033[1;33m[c]: English localisation\033[0;39m"
  echo -e " \033[1;37m[q]: Quit\033[0;39m"
  echo -e " \033[1;37m------------------------------------------------------\033[0;39m"
  read -p " Press any key [j/e or q]: " num 
  case "${num}" in
    "j" ) _func_full_INST_J ;;
    "e" ) _func_full_INST_E ;;
    "q" ) exit ;;
  esac
done

function _func_full_INST_J {
while :
do
  echo -e " \033[1;34Download automatic full installation scripts\033[0;39m"
  read -p " All right? [y/n]: " num
  case "${num}" in
    "y" ) wget --no-check-certificate -O /etc/config-software/package-auto-j.sh https://raw.githubusercontent.com/site-u2023/config-software/main/package-auto-j.sh
          sh /etc/config-software/package-auto-j.sh
          break ;;
    "n" ) break ;;
  esac
done
}

function _func_full_INST_E {
while :
do
  echo -e " \033[1;34Download automatic full installation scripts\033[0;39m"
  read -p " All right? [y/n]: " num
  case "${num}" in
    "y" ) wget --no-check-certificate -O /etc/config-software/package-auto-e.sh https://raw.githubusercontent.com/site-u2023/config-software/main/package-auto-e.sh
          sh /etc/config-software/package-auto-e.sh
          break ;;
    "n" ) break ;;
  esac
done
}

function _func_choice_INST {
while :
do
  echo -e " \033[1;33mDownload selective installation scripts\033[0;39m"
  read -p " All right? [y/n]: " num
  case "${num}" in
    "y" ) wget --no-check-certificate -O /etc/config-software/package-manual.sh https://raw.githubusercontent.com/site-u2023/config-software/main/package-manual.sh
          sh /etc/config-software/package-manual.sh
          break ;;
    "n" ) break ;;
  esac
done
}

function _func_after_INST {
while :
do
  echo -e " \033[1;31mDownload and run the script to confirm the installed package after flashing\033[0;39m"
  read -p " All right? [y/n]: " num
  case "${num}" in
    "y" ) wget --no-check-certificate -O /etc/config-software/install-config.sh https://raw.githubusercontent.com/site-u2023/config-software/main/install-config.sh
          sh /etc/config-software/install-config.sh
          read -p " Press any key"
          break ;;
    "n" ) break ;;
  esac
done
}

OPENWRT_RELEAS=`cat /etc/banner | grep OpenWrt | awk '{ print $2 }' | cut -c 1-2`
if [ "${OPENWRT_RELEAS}" = "23" ] || [ "${OPENWRT_RELEAS}" = "22" ] || [ "${OPENWRT_RELEAS}" = "21" ] || [ "${OPENWRT_RELEAS}" = "SN" ]; then
 echo -e " \033[1;37mversion check: OK\033[0;39m"
 else
 read -p " Exit due to different versions"
 exit
fi

while :
do
  echo -e " \033[1;37mInstallation may fail\033[0;39m"
  echo -e " \033[1;37mpackage-config ---------------------------------------\033[0;39m"
  echo -e " \033[1;34m[f]: Automatic full installation (Japanese or English)\033[0;39m"
  echo -e " \033[1;33m[c]: selective installation (Japanese)\033[0;39m"
  echo -e " \033[1;31m[a]: Confirmation of packages installed after flashing\033[0;39m"
  echo -e " \033[1;37m[q]: Quit\033[0;39m"
  echo -e " \033[1;37m------------------------------------------------------\033[0;39m"
  read -p " Press any key [f/c/a or q]: " num 
  case "${num}" in
    "f" ) _func_full_INST ;;
    "c" ) _func_choice_INST ;;
    "a" ) _func_after_INST ;;
    "q" ) exit ;;
  esac
done
