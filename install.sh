sudo apt update && sudo apt upgrade -y
sudo apt install make build-essential libclang cmake protoc apt-transport-https ca-certificates curl software-properties-common
curl --proto '=https' --tlsv1.3 https://sh.rustup.rs -sSf | sh
source $HOME/.cargo/env

wget -qO- "https://download.docker.com/linux/${DISTRIB_ID,,}/gpg" | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
echo "deb [arch=amd64 signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/${DISTRIB_ID,,} ${DISTRIB_CODENAME} stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt update
sudo apt install docker-ce docker-ce-cli containerd.io -y
docker_version=`apt-cache madison docker-ce | grep -oPm1 "(?<=docker-ce \| )([^_]+)(?= \| https)"`
sudo apt install docker-ce="$docker_version" docker-ce-cli="$docker_version" containerd.io -y

cd $HOME

git clone https://github.com/fleek-network/ursa.git && cd ursa make install

cd /etc/systemd/system
[Unit]
Description=My_Fleek

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
