echo "slowctrl all dac7 70 dac10 500" | nc 192.168.7.10 23 -q 0
echo "hvps cathode 3 3 3 3 3 3 3 3 3" | nc 192.168.7.10 23 -q 0
echo "hvps setdac 3700 3700 3700 3700 3700 3700 3700 3700 3700" | nc 192.168.7.10 23 -q 0
echo "hvps turnon 1 1 1 1 1 1 1 1 1" | nc 192.168.7.10 23 -q 0
echo "hvps status gpio" | nc 192.168.7.10 23 -q 0



