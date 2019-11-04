#!/bin/bash
#export DISPLAY=:0.0
#export DISPLAY=:0
#export XAUTHORITY=/home/kamal/.Xauthority
#declare -i LAST_VAL
declare -i LAP_BAT_LVL
BAT_LOG_ () {
if [[ $LAP_BAT_STAT == "Discharging" ]] && [[ $LAST_VAL != $LAP_BAT_LVL ]]
	then echo "$LAP_BAT_LVL% $CUR_DATE $1" >> /home/kamal/scripts/battery_check/BAT_LOG.txt
	else :
fi
}	

for i in {1..20}
do
LAST_VAL=$(tail -1 /home/kamal/scripts/battery_check/BAT_LOG.txt |cut -d\  -f1|sed 's/\%//1') 2> /dev/null
CUR_DATE=$(date)
LAP_BAT_STAT=$(cat /sys/class/power_supply/BAT0/status)
LAP_BAT_LVL=$(cat /sys/class/power_supply/BAT0/capacity)


if [[ $LAP_BAT_STAT == "Discharging" ]] && [[ $LAP_BAT_LVL -ge 71 ]]
	then BAT_LOG_ 
	else : 
fi
	if [[ $LAP_BAT_STAT == "Discharging" ]] && [[ $LAP_BAT_LVL -le 70 ]]
		then
		if [[ $(ps -aux |grep warning.wav|grep -v grep|wc -l) -ge 1 ]]
		then BAT_LOG_ "mplayer instance is running..." && break
		else 
		BAT_LOG_ "Calling Audio player!"
#		mplayer /home/kamal/scripts/battery_check/warning.wav 2>> /home/kamal/scripts/battery_check/BAT_LOG.txt
		/sbin/runuser -l kamal '/home/kamal/scripts/battery_check/audi.sh' 2> /dev/null 
#		XDG_RUNTIME_DIR=/run/user/`id -u` /usr/bin/aplay /home/kamal/scripts/battery_check/warning.wav 2>> /home/kamal/scripts/battery_check/BAT_LOG.txt # 'XDG_RUNTIME_DIR' variable helps background shells to take advantage of foreground previllages
		BAT_LOG_ "Audio file played..."
		fi
		sleep 2
		LAP_BAT_STAT=$(cat /sys/class/power_supply/BAT0/status)
		if [[ $LAP_BAT_STAT == "Charging" ]]
			then :
			else
			CUR_DATE=$(date); LAP_BAT_LVL=$(cat /sys/class/power_supply/BAT0/capacity)
			LAST_VAL=$(tail -1 /home/kamal/scripts/battery_check/BAT_LOG.txt |cut -d\  -f1|sed 's/\%//1')
			BAT_LOG_ "Issuing Shutdown command..."
			sleep 2
#			/sbin/init 0 2>> /home/kamal/scripts/battery_check/BAT_LOG.txt
			/sbin/shutdown -h now 2>> /home/kamal/scripts/battery_check/BAT_LOG.txt			
		fi
		else :
	fi	
sleep 2
done
