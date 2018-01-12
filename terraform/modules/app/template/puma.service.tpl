[Unit]
Description=Puma HTTP Server
After=network.target

[Service]
Type=simple
User=${app_user}
WorkingDirectory=/home/${app_user}/reddit
Environment=DATABASE_URL=${db_address}:${db_port}
ExecStart=/bin/bash -lc 'puma'
Restart=always

[Install]
WantedBy=multi-user.target
