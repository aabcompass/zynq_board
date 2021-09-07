dd=0
pix=0
echo "slowctrl line 1" | nc 192.168.7.10 23 -q 0
sleep $dd
echo "slowctrl asic 0" | nc 192.168.7.10 23 -q 0
sleep $dd
echo "slowctrl dac10 500" | nc 192.168.7.10 23 -q 0
sleep $dd
echo "slowctrl asic 1" | nc 192.168.7.10 23 -q 0
sleep $dd
echo "slowctrl dac10 500" | nc 192.168.7.10 23 -q 0
sleep $dd
echo "slowctrl asic 2" | nc 192.168.7.10 23 -q 0
sleep $dd
echo "slowctrl dac10 0" | nc 192.168.7.10 23 -q 0
sleep $dd
echo "slowctrl asic 3" | nc 192.168.7.10 23 -q 0
sleep $dd
echo "slowctrl dac10 0" | nc 192.168.7.10 23 -q 0
sleep $dd
echo "slowctrl asic 4" | nc 192.168.7.10 23 -q 0
sleep $dd
echo "slowctrl dac10 500" | nc 192.168.7.10 23 -q 0
sleep $dd
echo "slowctrl asic 5" | nc 192.168.7.10 23 -q 0
sleep $dd
echo "slowctrl dac10 500" | nc 192.168.7.10 23 -q 0
sleep $dd
echo "slowctrl asic 0" | nc 192.168.7.10 23 -q 0

echo "slowctrl pixel 2" | nc 192.168.7.10 23 -q 0
echo "slowctrl dac7 127" | nc 192.168.7.10 23 -q 0

# echo "slowctrl pixel 62" | nc 192.168.7.10 23 -q 0
# echo "slowctrl dac7 127" | nc 192.168.7.10 23 -q 0
# 
# echo "slowctrl pixel 61" | nc 192.168.7.10 23 -q 0
# echo "slowctrl dac7 127" | nc 192.168.7.10 23 -q 0
# 
# echo "slowctrl pixel 60" | nc 192.168.7.10 23 -q 0
# echo "slowctrl dac7 127" | nc 192.168.7.10 23 -q 0
# 
# echo "slowctrl pixel 59" | nc 192.168.7.10 23 -q 0
# echo "slowctrl dac7 127" | nc 192.168.7.10 23 -q 0
# 
# echo "slowctrl pixel 58" | nc 192.168.7.10 23 -q 0
# echo "slowctrl dac7 127" | nc 192.168.7.10 23 -q 0
# 
# echo "slowctrl pixel 57" | nc 192.168.7.10 23 -q 0
# echo "slowctrl dac7 127" | nc 192.168.7.10 23 -q 0
# 
# echo "slowctrl pixel 56" | nc 192.168.7.10 23 -q 0
# echo "slowctrl dac7 127" | nc 192.168.7.10 23 -q 0

sleep $dd
#for pix in {0..63}
#do
#    echo "slowctrl pixel $pix" | nc 192.168.7.10 23 -q 0
#    sleep $dd
#    echo "slowctrl dac7 0" | nc 192.168.7.10 23 -q 0
#    sleep $dd
#done
echo "slowctrl apply" | nc 192.168.7.10 23 -q 0
