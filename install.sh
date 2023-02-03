sudo apt update && sudo apt upgrade -y
sudo apt install make build-essential libclang cmake protoc
curl --proto '=https' --tlsv1.3 https://sh.rustup.rs -sSf | sh
source $HOME/.cargo/env
cd $HOME
# качаем бінарник
git clone https://github.com/fleek-network/ursa.git && cd ursa make install

cd /etc/systemd/system
[Unit]
Description=My_Fleek

# создать свой сервис

tee <<EOF /etc/systemd/system/fleek.service

[Unit]
Description=My_Fleek
After=network.target

[Service]
User=$Skika
ExecStart=/root/.cargo/bin/ursa
WorkingDirectory=$HOME/ursa
Restart=on-failure
RestartSec=10
LimitNOFILE=65535

[Install]
WantedBy=multi-user.target
EOF

sleep 10

systemctl daemon-reload
systemctl enable fleek
systemctl restart fleek
echo "Good"
