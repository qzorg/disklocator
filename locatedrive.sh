#!/bin/ash


switch=1
time=30

while getopts ":d:t:h:o" opt; do
    case $opt in
        d)
            drive=$OPTARG
            ;;
        t)
            time=$OPTARG ; switch=0
            ;;
	o)
            switch=1
            ;;
        \?) show_help
            exit 0
            ;;
        :)
            echo "Option -$OPTARG requires an argument">&2
            ;;
    esac
done

if [ "$drive" ]
then    
    if [ "$switch" == 1 ]
    then
        ison=$(cat /sys/class/block/$drive/../../enclosure*/locate)
	if [ "$ison" == 1 ]
	then
            echo "turning off"
            OUTPUT=$(echo 0 > $(echo /sys/class/block/$drive/../../enclosure*/locate))
            exit 0
	else
            echo "turning on"
            echo 1 > $(echo /sys/class/block/$drive/../../enclosure*/locate)
            exit 0
        fi
  
        else 
            $(echo 1 > $(echo /sys/class/block/$drive/../../enclosure*/locate) ; sleep $time ; echo 0 > $(echo /sys/class/block/$drive/../../enclosure*/locate)) &

     fi
    else
	echo "needs disk identifier ex. sda"
fi
