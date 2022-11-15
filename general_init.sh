./pixelmapload.sh
#sleep 1
echo "gtu 1us" | nc 192.168.7.10 23 -q 0
#./conf_ki.sh
./conf_zynq.sh
#sleep 1
echo "Done"

