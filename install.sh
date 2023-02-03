sudo apt update && sudo apt upgrade -y
sudo apt install make build-essential libclang cmake protoc apt-transport-https ca-certificates curl software-properties-common
curl --proto '=https' --tlsv1.3 https://sh.rustup.rs -sSf | sh

echo "Downloading and installing Docker is started..."
curl -fsSL https://get.docker.com -o get-docker.sh && \
    sh get-docker.sh && \
    rm -rf get-docker.sh

usermod -aG docker $USER

systemctl enable docker
systemctl start docker
echo "Docker started..."

apt update && \
    apt install unzip

wget https://github.com/fleek-network/ursa/archive/refs/heads/main.zip && \
    unzip main.zip && \
    rm -rf main.zip && \
    cd ursa-main

DOCKER_BUILDKIT=1 docker build -t ursa:latest .

docker run -d -p 4069:4069 -p 6009:6009 -v $HOME/.ursa/:/root/.ursa/:rw --name ursa-cli -it ursa

source $HOME/.cargo/env



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
