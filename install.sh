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
