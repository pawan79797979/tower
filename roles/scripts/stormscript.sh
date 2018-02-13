#!/bin/bash

ip1=$1  #{1:?Please enter the ipaddress1}
ip2=$2  #{2:?Please enter the ipaddress2}
ip3=$3  #{3:?Please enter the ipaddress3}



##IP of zookeeper##
sudo sed -i 's/# storm.zookeeper.servers:.*/storm.zookeeper.servers:\n       - "'$ip1'"\n       - "'$ip2'"\n       - "'$ip3'"/' /home/storm/apache-storm-1.0.2/conf/storm.yaml

##IP of Nimbus##
sudo sed -i 's/# nimbus.seeds:.*/nimbus.seeds: ["'$ip1'"]/' /home/storm/apache-storm-1.0.2/conf/storm.yaml
 
# Create new nimbus.service


###################

if [ $(hostname -I) = $ip1 ]; then


sudo -s <<EOF
rm -rf /etc/systemd/system/nimbus.service
cat <<EOT >> /etc/systemd/system/nimbus.service

[Unit]
Description=Apache Storm Nimbus Service
After=basic.target

[Service]
Type=simple
User=storm
Group=storm
WorkingDirectory=/home/storm/apache-storm-1.0.2/
ExecStart=/home/storm/apache-storm-1.0.2/bin/storm nimbus
Restart=on-failure
RestartSec=10

[Install]
WantedBy=multi-user.target

EOT
EOF
#####

sudo -s <<EOF
rm -rf /etc/systemd/system/storm-ui.service
cat <<EOT >> /etc/systemd/system/storm-ui.service
[Unit]
Description=Apache Storm UI Service
After=basic.target

[Service]
Type=simple
User=storm
ExecStart=/home/storm/apache-storm-1.0.2/bin/storm ui
Restart=on-abort

[Install]
WantedBy=multi-user.target

EOT
EOF
#####

fi

if [ $(hostname -I) = $ip2 ]; then


sudo -s <<EOF
rm -rf /etc/systemd/system/storm-supervisor.service
cat <<EOT >> /etc/systemd/system/storm-supervisor.service
[Unit]
Description=Apache Storm UI Service
After=basic.target

[Service]
Type=simple
User=storm
ExecStart=/home/storm/apache-storm-1.0.2/bin/storm supervisor
Restart=on-abort

[Install]
WantedBy=multi-user.target
EOT
EOF

fi

if [ $(hostname -I) = $ip3 ]; then


sudo -s <<EOF
rm -rf /etc/systemd/system/storm-supervisor.service
cat <<EOT >> /etc/systemd/system/storm-supervisor.service
[Unit]
Description=Apache Storm UI Service
After=basic.target

[Service]
Type=simple
User=storm
ExecStart=/home/storm/apache-storm-1.0.2/bin/storm supervisor
Restart=on-abort

[Install]
WantedBy=multi-user.target
EOT
EOF

fi
##
chmod 777 /home/storm/apache-storm-1.0.2
##

sudo systemctl start firewalld
sudo firewall-cmd --permanent --add-port=8080/tcp
sudo firewall-cmd --permanent --add-port=80/tcp
sudo firewall-cmd --permanent --add-port=6627/tcp 
sudo firewall-cmd --permanent --add-port=6700/tcp
sudo firewall-cmd --permanent --add-port=6701/tcp
sudo firewall-cmd --permanent --add-port=6702/tcp


#Starting Nimbus 
if [ $(hostname -I) = $ip1 ]; then
sudo systemctl start nimbus
sudo systemctl stop nimbus

#Starting UI
sudo systemctl start storm-ui
sudo systemctl stop storm-ui
fi

#Starting Supervisor

if [ $(hostname -I) = $ip2 ]; then

sudo systemctl start storm-supervisor
sudo systemctl stop storm-supervisor

sudo systemctl start storm-supervisor
sudo systemctl status storm-supervisor
fi

if [ $(hostname -I) = $ip3 ]; then

sudo systemctl start storm-supervisor
sudo systemctl stop storm-supervisor

sudo systemctl start storm-supervisor
sudo systemctl status storm-supervisor
fi



















