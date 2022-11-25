echo "artix altclk" | nc 192.168.7.10 23 -q 0
echo "acq zeropmt 4095 0 4095" | nc 192.168.7.10 23 -q 0
./send2zb.sh "hvps mapping 9 9 9 4 8 7 9 9 9"
