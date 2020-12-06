#!/bin/bash



sudo ip netns add sample1
sudo ip netns list
sudo iptables -L
sudo ip netns exec sample1 iptables -L #running the command: iptables -L inside the namespace

sudo ip netns exec sample1 bash #enter the bash shell of the namespace
iptables -L #running inside the namespace
iptables -A input -p tcp -m tcp --dport 80 -j accept
iptables -L
exit


