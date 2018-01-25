#!/usr/bin/env bash

cd /opt
git clone https://github.com/Otus-DevOps-2017-11/reddit.git
cd reddit && bundle install

# create service fo app puma
cat << EOF > /etc/systemd/system/puma.service
[Unit]
Description=Service puma-app for reddit-server @ekobushka
After=network.target

[Service]
Type=simple
WorkingDirectory=/opt/reddit/
ExecStart=/usr/local/bin/puma
Restart=always
RestartSec=10

[Install]
WantedBy=multi-user.target
EOF

systemctl daemon-reload
systemctl start puma
systemctl enable puma
systemctl status puma
