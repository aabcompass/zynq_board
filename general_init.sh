./zb6.sh
./pixelmapload.sh
sleep 1
echo "gtu 1us" | nc 192.168.7.10 23 -q 0
./conf_zynq.sh
sleep 1
#./conf_l1.sh
echo "Done"

