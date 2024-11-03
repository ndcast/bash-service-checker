#!/bin/bash

#    usage service-checker.sh <Service Name> [additional log entry] 
#         (e.g. /route/toscript/service-checker.sh nginx.service 'Starting A high performance')

serviceX=$1
additionalX=$2

function restartX {
 sudo systemctl restart $serviceX;
  for x in {1..3};do echo '.'; sleep 0.5;done
  echo 'New state:';
  systemctl status $serviceX;
  date >> $serviceX-restarts.log;
}

if [ -z $serviceX ];
then
        echo Empty arguments not doing anything;
      echo 'usage service-checker.sh <Service Name> [additional log entry]';
else
        echo getting state of service $serviceX;
        systemctl status $serviceX -n3 > $serviceX-active.state; 
        # use -n #  for the ammount of lines you need the keyword to appear, in most cases is 3, could be more or less depending on the service so evaluate accordingly 

        if [ -z $additionalX ];
        then
                if [ $(grep running $serviceX-active.state | wc -l) -lt 1 ];
                then
                  echo "service is NOT in running state, restarting":;
                  restartX;
                else
                  echo "service running , nothing to do";
                fi
        else
                echo "** note additional pattern in log was provided , seeking if the following  pattern NOT present : $additionalX "
                if [ $(grep -e running -e $additionalX $serviceX-active.state | wc -l) -lt 2 ];
                then
                  echo "service is not in running state or $additionalX not present, restarting":
                  restartX;
                else
                  echo "service running and $additionalX present, nothing to do";
                fi;
        fi
 fi
