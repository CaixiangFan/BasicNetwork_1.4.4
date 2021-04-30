## Run a network using Docker-compose
    git clone https://github.com/CaixiangFan/BasicNetwork_1.4.4.git
    ./artifacts/channel/create-artifacts.sh
    cd artifacts/
    docker-compuse up -d
## Creat channel and join
    ../createChannel.sh

## Deploy chaincode
    cd artifacts/src/github.com/fabcar/go
    go env -w GOPROXY=https://goproxy.io,direct
    go env -w GO111MODULE=on
    go mod vendor

change fabric-ccenv version to 1.4:
    nano ./artifacts/channel/config/core.yaml

    ./deployChaincode.sh