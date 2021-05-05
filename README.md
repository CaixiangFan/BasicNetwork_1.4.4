## Run a network using Docker-compose
    git clone https://github.com/CaixiangFan/BasicNetwork_1.4.4.git
    
    cd artifacts/channel/
    ./create-artifacts.sh
    cd ..
    docker-compuse up -d
    
## Creat channel and join
    ../createChannel.sh

## Deploy chaincode
    ./deployChaincode.sh