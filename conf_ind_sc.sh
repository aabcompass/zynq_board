dd=0
pix=0
echo "slowctrl line 5" | nc 192.168.7.10 23 -q 0
sleep $dd
#echo "slowctrl asic 0" | nc 192.168.7.10 23 -q 0
#sleep $dd
#echo "slowctrl dac10 0" | nc 192.168.7.10 23 -q 0
#sleep $dd
#echo "slowctrl asic 1" | nc 192.168.7.10 23 -q 0
#sleep $dd
#echo "slowctrl dac10 0" | nc 192.168.7.10 23 -q 0
#sleep $dd
#echo "slowctrl asic 2" | nc 192.168.7.10 23 -q 0
#sleep $dd
#echo "slowctrl dac10 0" | nc 192.168.7.10 23 -q 0
#sleep $dd
#echo "slowctrl asic 3" | nc 192.168.7.10 23 -q 0
#sleep $dd
#echo "slowctrl dac10 0" | nc 192.168.7.10 23 -q 0
#sleep $dd
#echo "slowctrl asic 4" | nc 192.168.7.10 23 -q 0
#sleep $dd
#echo "slowctrl dac10 0" | nc 192.168.7.10 23 -q 0
#sleep $dd
echo "slowctrl asic 5" | nc 192.168.7.10 23 -q 0
sleep $dd
echo "slowctrl dac10 700" | nc 192.168.7.10 23 -q 0
sleep $dd
for pix in {0..63}
do
    echo "slowctrl pixel $pix" | nc 192.168.7.10 23 -q 0
    sleep $dd
    echo "slowctrl dac7 127" | nc 192.168.7.10 23 -q 0
    sleep $dd
done
echo "slowctrl apply" | nc 192.168.7.10 23 -q 0
