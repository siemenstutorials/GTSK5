#!/bin/bash
##############################################################
#                                                            #
# Author：Changed By Siemenstutorials                        #
#                                                            #
# Youtube channel:https://www.youtube.com/c/siemenstutorials #
#                                                            # 
# GOST TO SOCKS5 v1.0                                        #
#                                                            #
##############################################################
#Install basic
rpm -q curl || yum install -y curl
rpm -q wget || yum install -y wget

#Check server ip

public_ip=${VPN_PUBLIC_IP:-''}
check_ip "$public_ip" || public_ip=$(dig @resolver1.opendns.com -t A -4 myip.opendns.com +short)
check_ip "$public_ip" || public_ip=$(wget -t 3 -T 15 -qO- http://ipv4.icanhazip.com)
check_ip "$public_ip" || exiterr "Cannot detect this server's public IP. Define it as variable 'VPN_PUBLIC_IP' and re-run this script."

#Download Gost
wget -N --no-check-certificate https://github.com/siemenstutorials/GTSK5/releases/download/v2.11.2/gost-linux-amd64-2.11.2.gz && gzip -d gost-linux-amd64-2.11.2.gz
mv gost-linux-amd64-2.11.2 gost
chmod +x gost

#Startup下载
wget -N --no-check-certificate https://raw.githubusercontent.com/siemenstutorials/GTSK5/master/startup.sh
chmod +x startup.sh

#Setting 

read -p "请输入用户名：" username
echo "username = ${username}"
read -p "请输入密码：" passwd
echo "passwd = ${passwd}"
read -p "请输入端口：" port
echo "port = ${port}"

#Socks5后台运行

nohup ./gost -L ${username}:${passwd}@:${port} socks5://:${port} >> /dev/null 2>&1 & 

#创建自启动文件

sed -i '2i nohup ./gost -L ${username}:${passwd}@:${port} socks5://:${port} >> /dev/null 2>&1 &' >> /dev/null 2>&1 &' startup.sh

#自动重启设置
echo "正在设置开机自动运行"
(echo "@reboot /root/startup.sh" ; crontab -l )| crontab
echo "开机自动运行设置完成"
#Socks5连接信息
echo "安装完成SOCKS5连接信息如下:"

echo "服务器IP: " ${public_ip}
echo "用户名: " ${username}
echo "密 码: " ${passwd}
echo "端 口: " ${port}

#yum install lsof  ##安装lsof命令
#lsof -i:8090  ##利用lsof命令查看端口占用的进程号，此处的8090为端口号
#kill -9 8888  ##此处的8888为进程PID号
