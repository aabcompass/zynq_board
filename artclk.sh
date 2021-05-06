#!/bin/bash
exec 3<>/dev/tcp/192.168.7.10/23
for i in {0..63}
do
	echo -ne "dbg art clk" >&3
	timeout 0.1 cat <&3
	#sleep 0.1
done
echo "Всё"

