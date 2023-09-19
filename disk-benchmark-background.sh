#!/bin/bash

# CS550 Assignment 1
# Team: Batkhishig Dulamsurankhor, Nitin Singh, Vaishnavi Papudesi Babu

elapsed_time="0"
sum="0"
count="0"
run_benchmark() {
	# runs dd command for benchmarking
	(time dd if=/dev/zero of=/tmp/test1.img bs=1GB count=5 oflag=dsync) 2>&1
}
extract_time() {
	# extracts time in seconds from time command
	echo "$output" | grep real | awk '{split($2,a,"m"); print (a[1]*60)+a[2]}'
}
extract_speed() {
	# extracts disk speed from dd command result
	speed=$(echo "$output" | grep -oE '[0-9.]+ [MG]B/s')
        unit=$(echo "$speed" | sed 's/[^MG]//g')
        value=$(echo "$speed" | sed 's/[^0-9.]//g')
        # convert GB/s to MB/s
        if [ "$unit" = "G" ]
	then
                value=$(bc <<< "$value * 1024")
        fi
	echo "$value"
}
echo "Running benchmark..."
# runs benchmark for at least 10 seconds
while [ $(bc <<< "$elapsed_time < 10") -eq 1 ]
do
	output=$(run_benchmark)
	echo "$output" >> ./disk-benchmark-background-log.txt
	real_time=$(extract_time "$output")
	value=$(extract_speed)
	sum=$(bc <<< "$sum + $value")
	count=$(bc <<< "$count + 1")
	elapsed_time=$(bc <<< "$elapsed_time + $real_time")
	sleep 0.1
done
average_speed=$(bc <<< "$sum / $count")
# convert MB/s to GB/s if the speed is over 1024MB/s
if [ $(bc <<< "$average_speed >= 1024") -eq 1 ]
then
	average_speed=$(echo "scale=2; $average_speed / 1024" | bc)
	average_speed=$(echo "$average_speed GB/s")
else
	average_speed=$(echo "$average_speed MB/s")
fi
echo -e "Result: \n \t took: $elapsed_time seconds \t disk speed: $average_speed" >> ./disk-benchmark-background-log.txt
echo -e "Result: \n \t took: $elapsed_time seconds \t disk speed: $average_speed"
