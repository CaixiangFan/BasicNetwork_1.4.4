#!/usr/bin/env bash

: "${FABRIC_VERSION:=1.4.4}"
: "${FABRIC_CA_VERSION:=1.4.4}"

# if the binaries are not available, download them
if [[ ! -d "bin" ]]; then
  curl -sSL http://bit.ly/2ysbOFE | bash -s -- ${FABRIC_VERSION} ${FABRIC_CA_VERSION} 0.4.14 -ds
fi

# Delete existing artifacts
rm -rf ./crypto-config/
rm -f ./genesis.block
rm -f ./mychannel.tx

# System channel
SYS_CHANNEL="sys-channel"

# channel name defaults to "mychannel"
CHANNEL_NAME="mychannel"

echo $CHANNEL_NAME

# Generate Crypto artifactes for organizations
./bin/cryptogen generate --config=./crypto-config.yaml --output=./crypto-config/
# Generate System Genesis block
./bin/configtxgen -profile OrdererGenesis -configPath . -channelID $SYS_CHANNEL -outputBlock ./genesis.block
# Generate channel configuration block
./bin/configtxgen -profile BasicChannel -configPath . -outputCreateChannelTx ./mychannel.tx -channelID $CHANNEL_NAME

# Rename the key files we use to be key.pem instead of a uuid
for KEY in $(find crypto-config -type f -name "*_sk"); do
    KEY_DIR=$(dirname ${KEY})
    mv ${KEY} ${KEY_DIR}/key.pem
done


echo "#######    Generating anchor peer update for Org1MSP  ##########"
./bin/configtxgen -profile BasicChannel -configPath . -outputAnchorPeersUpdate ./Org1MSPanchors.tx -channelID $CHANNEL_NAME -asOrg Org1MSP

echo "#######    Generating anchor peer update for Org2MSP  ##########"
./bin/configtxgen -profile BasicChannel -configPath . -outputAnchorPeersUpdate ./Org2MSPanchors.tx -channelID $CHANNEL_NAME -asOrg Org2MSP

chmod 777 -R *
