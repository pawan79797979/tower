#!/bin/bash

ip1=$1  #{1:?Please enter the ipaddress1}
ip2=$2  #{2:?Please enter the ipaddress2}
ip3=$3  #{3:?Please enter the ipaddress3}

if [ $(hostname -I) = $ip1 ]; then
 sudo sed -i 's/server.1=.*/server.1=0.0.0.0:2888:3888/' /opt/zookeeper/conf/zoo.cfg
fi

if [ $(hostname -I) = $ip2 ]; then
 sudo sed -i 's/server.2=.*/server.2=0.0.0.0:2888:3888/' /opt/zookeeper/conf/zoo.cfg
fi

if [ $(hostname -I) = $ip3 ]; then
 sudo sed -i 's/server.3=.*/server.3=0.0.0.0:2888:3888/' /opt/zookeeper/conf/zoo.cfg
fi
#else
#    echo "Please enter a valid, non-empty ipaddress"
#        exit 1

###############

if [ $(hostname -I) = $ip1 ]; then

sudo -s <<EOF
echo Now i am root
sudo echo "1" > /var/zookeeper/myid
cat /var/zookeeper/myid
EOF

fi

if [ $(hostname -I) = $ip2 ]; then

sudo -s <<EOF
echo Now i am root
sudo echo "2" > /var/zookeeper/myid
cat /var/zookeeper/myid
EOF

fi

if [ $(hostname -I) = $ip3 ]; then

sudo -s <<EOF
echo Now i am root
sudo echo "3" > /var/zookeeper/myid
cat /var/zookeeper/myid
EOF

fi

