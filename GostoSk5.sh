#!/bin/bash

#Download
wget -N --no-check-certificate https://github.com/siemenstutorials/GTSK5/releases/download/v2.11.2/gost-linux-amd64-2.11.2.gz && gzip -d gost-linux-amd64-2.11.2.gz
mv gost-linux-amd64-2.11.2 gost
chmod +x gost

#setting 
read -p "Please Input Port：" port
read -p "Please Input Api：" api


nohup ./gost -L=:${port} -F=${api} >> /dev/null 2>&1 & 


#yum install lsof  ##安装lsof命令
#lsof -i:8090  ##利用lsof命令查看端口占用的进程号，此处的8090为端口号
#kill -9 8888  ##此处的8888为进程PID号
