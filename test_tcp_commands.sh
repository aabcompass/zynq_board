#!/bash/bin
while :
do
	echo "instrument ver?" | nc 192.168.7.10 23 -q 0
done
