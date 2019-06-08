# https://www.webair.com/community/simple-stateful-load-balancer-with-iptables-and-nat/
# https://linuxgazette.net/108/odonovan.html 
# https://home.regit.org/netfilter-en/links-load-balancing/ 
echo "1" > /proc/sys/net/ipv4/ip_forward
# The following example shows a way to use iptables for basic round-robin load balancing, by redirecting
# packets two one of three ports based on a statistic counter.
#
# TCP packets for new sessions arriving on port 9000 will rotate between ports 9001, 9002 and 9003, where
# three identical copies of some application are expected to be listening.
#
# Packets that aren't TCP or that related to an already-established connection are left untouched, letting
# the standard iptables connection tracking machinery send it to the appropriate port.
#
# For this to work well, connections need to be relatively short. Ideally there would be an extra layer
# of load balancing in front that holds longer-term client keepalive connections and then opens short-lived
# connections to the app servers.

# Note that because this uses the PREROUTING chain it will work only for incoming connections from other hosts,
# not connections on local loopback.

# Always accept packets for already-active sessions.
iptables -A INPUT -m state --state RELATED,ESTABLISHED -j ACCEPT

# Default input policy is to ACCEPT
iptables -P INPUT ACCEPT

# One in three TCP packets go to port 9001
iptables -t nat -A PREROUTING -p tcp --dport 9000 -m statistic --mode nth --every 3 --packet 0 -j REDIRECT --to-port 9001
# One in the remaining two go to port 9002
iptables -t nat -A PREROUTING -p tcp --dport 9000 -m statistic --mode nth --every 2 --packet 0 -j REDIRECT --to-port 9002
# The remaining one always routes to port 9003
iptables -t nat -A PREROUTING -p tcp --dport 9000 -j REDIRECT --to-port 9003

# An alternative formulation would be to have one of the app processes listen on port 9000 itself
# and then drop the final rule, so packets that aren't matched by the statistics rules will just go to the port 9000 app by default.