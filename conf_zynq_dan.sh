dac=$1
sd="hvps setdac"
p=" "
#dac="3800" #high voltage
for ((i=1; i < 10; i++))
do
sd="$sd$p$dac"
done

echo "instrument ver" | nc 192.168.7.10 23 -q 0
echo "slowctrl all dac 700" | nc 192.168.7.10 23 -q 0
echo "hvps cathode 3 3 3 3 3 3 3 3 3" | nc 192.168.7.10 23 -q 0
echo "$sd" | nc 192.168.7.10 23 -q 0
echo "hvps turnon 1 1 1 1 1 1 1 1 1" | nc 192.168.7.10 23 -q 0
echo "hvps status gpio" | nc 192.168.7.10 23 -q 0
