#!/bin/bash
ok=`HEAD http://$1:$2/status|grep -c "Kbn-Name: kibana"`
if [ $ok -eq 0 ]; then
 exit 1
else
 exit 0
fi

