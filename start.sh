./send2zb.sh "instrument ver?"
./send2zb.sh "instrument internal 1pps"
./zb6.sh
./general_init.sh
./conf_l1.sh
#./send2zb.sh "pixelmap test PMTs" 
./send2zb.sh "instrument mode d1d3"
./send2zb.sh "instrument filenames lab"
./send2zb.sh "instrument start" 
