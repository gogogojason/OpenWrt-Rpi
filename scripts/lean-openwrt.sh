#!/bin/bash
#=================================================
# Description: DIY script
# Lisence: MIT
# Author: P3TERX
# Blog: https://p3terx.com
#=================================================
# Modify default IP
#sed -i 's/192.168.1.1/192.168.50.5/g' package/base-files/files/bin/config_generate
# cd $WORK_PATH 目录下,先运行的 public.h -> 设备.h -> scripts/feeds install -a
# 定义部分以及需要添加对应APP必须的文件
device_name='MyRouter'                                                      # 自定义设备名
wifi_name="RMWiFi"                                                          # 自定义Wifi 名字
wifi_name5g="RMWiFi_5G"                                                          # 自定义Wifi 名字
lan_ip='192.168.2.1'                                                        # 自定义Lan Ip地址
utc_name='Asia\/Shanghai'                                                   # 自定义时区
ver_name='D201205'                                                          # 版本号
delete_bootstrap=false                                                      # 是否删除默认主题 true 、false
default_theme='luci-theme-edge'                                        # 默认主题 结合主题文件夹名字
theme_argon='https://github.com/gogogojason/luci-theme-edge -b 18.06'             # 主题地址
#theme_argon='https://github.com/jerrykuku/luci-theme-argon.git'             # 主题地址
openClash_url='https://github.com/vernesong/OpenClash.git'                  # OpenClash包地址
adguardhome_url='https://github.com/rufengsuixing/luci-app-adguardhome.git' # adguardhome 包地址
lienol_url='https://github.com/Lienol/openwrt-package.git'                  # Lienol 包地址
vssr_url_rely='https://github.com/jerrykuku/lua-maxminddb.git'              # vssr lua-maxminddb依赖
vssr_url='https://github.com/jerrykuku/luci-app-vssr.git'                   # vssr地址
filter_url='https://github.com/destan19/OpenAppFilter.git'                  # AppFilter 地址
smartdns_url='https://github.com/pymumu/openwrt-smartdns'                   # SmartDNS运行程序
smartdnsapp_url='https://github.com/pymumu/luci-app-smartdns.git'           # SmartDNS-App
serverchan_url='https://github.com/tty228/luci-app-serverchan.git'          # serverchan备份包
upgrade_url='https://github.com/gogogojason/upgrade.git'

#下面是执行具体操作

echo "修改机器名称"
sed -i "s/OpenWrt/$device_name/g" package/base-files/files/bin/config_generate

echo "修改wifi名称"
#sed -i "s/OpenWrt/$wifi_name/g" package/kernel/mac80211/files/lib/wifi/mac80211.sh
sed -i "s/OpenWrt_2G/$wifi_name/g" package/lean/mt/drivers/mt_wifi/files/mt7603.dat
sed -i "s/OpenWrt_5G/$wifi_name5g/g" package/lean/mt/drivers/mt_wifi/files/mt7615.dat
#sed -i "s/OpenWrt_5G/$wifi_name5g/g" package/lean/mt/drivers/mt_wifi/files/mt7612.dat
#sed -i "s/OpenWrt_5G/$wifi_name5g/g" package/lean/mt/drivers/mt7615d/files/mt7615.1.5G.dat
#sed -i "s/OpenWrt_5G/$wifi_name5g/g" package/lean/mt/drivers/mt7615d/files/mt7615.2.dat
#sed -i "s/MTK_AP3/$wifi_name5g/g" package/lean/mt/drivers/mt_wifi/files/mt7615.dat

echo "设置lan ip"
sed -i "s/192.168.1.1/$lan_ip/g" package/base-files/files/bin/config_generate

#echo "修改argon主题背景色"
#sed -i "s/#5e72e4/#00C000/g" feeds/otherpackges/luci-theme-argon_new/luasrc/view/themes/argon/header.htm

echo '添加主题argon'
git clone $theme_argon package/lean/luci-theme-edge
#echo 'CONFIG_PACKAGE_luci-theme-argon-mc=y' >> .config

echo "修改时区"
sed -i "s/'UTC'/'CST-8'\n   set system.@system[-1].zonename='$utc_name'/g" package/base-files/files/bin/config_generate

echo "修改默认主题"
sed -i 's/+luci-theme-bootstrap/+luci-theme-edge/g' feeds/luci/collections/luci/Makefile
sed -i "s/bootstrap/argon/g" feeds/luci/modules/luci-base/root/etc/config/luci
#sed -i '/\+luci-theme-bootstrap/d' package/feeds/luci/luci/Makefile
sed -i '/set luci.main.mediaurlbase=\/luci-static\/bootstrap/d' feeds/luci/themes/luci-theme-bootstrap/root/etc/uci-defaults/30_luci-theme-bootstrap

echo "修改版本信息"
sed -i "s/R20.10.20/R20.10.20\/hfy166 Ver.$ver_name/g" package/lean/default-settings/files/zzz-default-settings

#echo '添加在线升级'
#git clone $upgrade_url package/lean/luci-app-gpsysupgrade
#echo 'CONFIG_PACKAGE_luci-app-gpsysupgrade=y' >> .config

echo '添加serverchan'
git clone --depth=1 $serverchan_url package/lean/luci-app-serverchan
#echo 'CONFIG_PACKAGE_luci-app-serverchan=y' >> .config

echo '添加主题argon'
git clone $theme_argon package/lean/luci-theme-edge

echo '添加adguardhome'
git clone $adguardhome_url package/lean/luci-app-adguardhome

echo '添加HelloWord,并使用包默认的配置'  # TODO 这个的配置文件和SSP 冲突
git clone $vssr_url_rely package/lean/lua-maxminddb
git clone $vssr_url package/lean/luci-app-vssr

# Clone community packages to package/community
mkdir package/community
pushd package/community

# Add Lienol's Packages
git clone --depth=1 https://github.com/Lienol/openwrt-package

# Add luci-app-passwall
git clone --depth=1 https://github.com/xiaorouji/openwrt-passwall

# Add luci-app-vssr <M>
git clone --depth=1 https://github.com/jerrykuku/lua-maxminddb.git
git clone --depth=1 https://github.com/jerrykuku/luci-app-vssr

# Add mentohust & luci-app-mentohust
git clone --depth=1 https://github.com/BoringCat/luci-app-mentohust
git clone --depth=1 https://github.com/KyleRicardo/MentoHUST-OpenWrt-ipk

# Add minieap & luci-proto-minieap
git clone --depth=1 https://github.com/ysc3839/luci-proto-minieap
svn co https://github.com/project-openwrt/openwrt/trunk/package/ntlf9t/minieap

# Add ServerChan
git clone --depth=1 https://github.com/tty228/luci-app-serverchan

# Add OpenClash
git clone --depth=1 -b master https://github.com/vernesong/OpenClash

# Add luci-app-onliner (need luci-app-nlbwmon)
git clone --depth=1 https://github.com/rufengsuixing/luci-app-onliner

# Add luci-app-adguardhome
svn co https://github.com/Lienol/openwrt/trunk/package/diy/luci-app-adguardhome
svn co https://github.com/Lienol/openwrt/trunk/package/diy/adguardhome

# Add luci-app-diskman
git clone --depth=1 https://github.com/lisaac/luci-app-diskman
mkdir parted
cp luci-app-diskman/Parted.Makefile parted/Makefile

# Add luci-app-dockerman
rm -rf ../lean/luci-app-docker
git clone --depth=1 https://github.com/KFERMercer/luci-app-dockerman
git clone --depth=1 https://github.com/lisaac/luci-lib-docker

# Add luci-app-gowebdav
git clone --depth=1 https://github.com/project-openwrt/openwrt-gowebdav

# Add luci-app-jd-dailybonus
git clone --depth=1 https://github.com/jerrykuku/luci-app-jd-dailybonus

# Add luci-theme-argon
git clone --depth=1 -b 18.06 https://github.com/jerrykuku/luci-theme-argon
git clone --depth=1 https://github.com/jerrykuku/luci-app-argon-config
rm -rf ../lean/luci-theme-argon

# Add tmate
git clone --depth=1 https://github.com/project-openwrt/openwrt-tmate

# Add subconverter
git clone --depth=1 https://github.com/tindy2013/openwrt-subconverter

# Add gotop
svn co https://github.com/project-openwrt/openwrt/trunk/package/ctcgfw/gotop

# Add smartdns
svn co https://github.com/pymumu/smartdns/trunk/package/openwrt ../smartdns
svn co https://github.com/project-openwrt/openwrt/trunk/package/ntlf9t/luci-app-smartdns ../luci-app-smartdns

# Add udptools
git clone --depth=1 https://github.com/bao3/openwrt-udp2raw
git clone --depth=1 https://github.com/bao3/openwrt-udpspeeder
git clone --depth=1 https://github.com/bao3/luci-udptools

# Add OpenAppFilter
git clone --depth=1 https://github.com/destan19/OpenAppFilter
popd

# Mod zzz-default-settings
pushd package/lean/default-settings/files
sed -i "/commit luci/i\uci set luci.main.mediaurlbase='/luci-static/argon'" zzz-default-settings
sed -i '/http/d' zzz-default-settings
sed -i '/exit/i\chmod +x /bin/ipv6-helper' zzz-default-settings
popd

# Fix libssh
pushd feeds/packages/libs
rm -rf libssh
svn co https://github.com/openwrt/packages/trunk/libs/libssh
popd

# Use Lienol's https-dns-proxy package
pushd feeds/packages/net
rm -rf https-dns-proxy
svn co https://github.com/Lienol/openwrt-packages/trunk/net/https-dns-proxy
popd

# Use snapshots syncthing package
pushd feeds/packages/utils
rm -rf syncthing
svn co https://github.com/openwrt/packages/trunk/utils/syncthing
popd

# Fix mt76 wireless driver
pushd package/kernel/mt76
rm -f Makefile
wget https://raw.githubusercontent.com/openwrt/openwrt/master/package/kernel/mt76/Makefile
sed -i '/mt7662u_rom_patch.bin/a\\techo mt76-usb disable_usb_sg=1 > $\(1\)\/etc\/modules.d\/mt76-usb' Makefile
popd

# Add po2lmo
git clone https://github.com/openwrt-dev/po2lmo.git
pushd po2lmo
make && sudo make install
popd

# Change default shell to zsh
sed -i 's/\/bin\/ash/\/usr\/bin\/zsh/g' package/base-files/files/etc/passwd
