# CS550 Assignment 1
# Team: Batkhishig Dulamsurankhor, Nitin Singh, Vaishnavi Papudesi Babu

# Pre-req
# install ping
# apt-get install iputils-ping

latency_file="network-test-latency.txt"
dns_list="network-test-machinelist.txt"

echo "Starting network test script"
while read dns || [ -n "$dns" ]
do
    rtt=`ping $dns -c 3 | tail -1| awk '{print $4}' | cut -d '/' -f 2`
    echo "$dns $rtt" >> $latency_file
done < $dns_list

echo "Execution Completed! Average latency for each DNS is displayed at $latency_file file"
