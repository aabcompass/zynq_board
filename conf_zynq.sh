echo "slowctrl all dac 500" | nc 192.168.7.10 23 -q 0
echo "hvps cathode 3 3 3 3 3 3 3 3 3" | nc 192.168.7.10 23 -q 0
echo "hvps setdac 3500 3500 3500 3500 3500 3500 3500 3500 3500" | nc 192.168.7.10 23 -q 0
echo "hvps turnon 1 1 1 1 1 1 1 1 1" | nc 192.168.7.10 23 -q 0
echo "hvps status gpio" | nc 192.168.7.10 23 -q 0
echo "hvps switching on 0" | nc 192.168.7.10 23 -q 0
echo "hvps cathode 3 3 3 3 3 3 3 3 3" | nc 192.168.7.10 23 -q 0


