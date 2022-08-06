#!/bin/bash

arch=$(uname -a)
# echo \#Architecture : $arch

phys=$(grep "physical id" /proc/cpuinfo | sort | uniq | wc -l)
# echo \#CPU Physical : $phys

virt=$(cat /proc/cpuinfo | grep processor | wc -l)
# echo \#CPU Virtual : $virt

usedram=$(free -m | grep "Mem" | awk '{print $3}')
totalram=$(free -m | grep "Mem" | awk '{print $2}')
ramutil=$(free -m | grep "Mem" | awk '{printf("%.2f"), $3/$2*100}')
# echo \#Memory Usage: $usedram/${totalram}MB $ramutil%

useddisk=$(df -Bm | grep /dev | grep -v -E '(tmp|boot)' | awk '{ut += $3} END {print ut}')
totaldisk=$(df -Bm | grep /dev | grep -v -E '(tmp|boot)' | awk '{tt += $2} END {print tt}')
diskutil=$(df -Bm | grep /dev | grep -v -E '(tmp|boot)' | awk '{ut += $3} {tt += $2} END {printf("%.2f"), ut/tt*100}')
# echo \#Disk Usage: $useddisk/${totaldisk}MB $diskutil%

usedcpu=$(top -bn1 | grep Cpu | cut -c 9- | awk '{printf("%.1f"), $1 + $3}')
# echo \#CPU Usage: $usedcpu%

lastboot=$(who -b | cut -c 23-)
# echo \#Last reboot: $lastboot

checklvm=$(cat /etc/fstab | grep /dev/mapper | wc -l)
countlvm=$(if [ $checklvm -ge 1 ]; then echo Yes; else echo No; fi)
# echo \#LVM Use: $countlvm

countTCP=$(netstat -at | grep tcp | grep -v tcp6 | wc -l)
# echo \#Connections TCP: $countTCP ESTABLISHED

countusers=$(users | wc -l)
# echo \#User log: $countusers

ip=$(hostname -I)
mac=$(cat /sys/class/net/*/address | head -1)
# echo \#Network: IP $ip \($mac\)

sudo=$(journalctl -q _COMM=sudo | grep COMMAND | wc -l)
# echo \#Sudo: $sudo cmd

wall "	#Architecture : $arch
		#CPU Physical : $phys
		#CPU Virtual : $virt
		#Memory Usage: $usedram/${totalram}MB $ramutil%
		#Disk Usage: $useddisk/${totaldisk}MB $diskutil%
		#CPU Usage: $usedcpu%
		#Last reboot: $lastboot
		#LVM Use: $countlvm
		#Connections TCP: $countTCP ESTABLISHED
		#User log: $countusers
		#Network: IP $ip ($mac)
		#Sudo: $sudo cmd	"