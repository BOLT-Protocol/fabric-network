#!/bin/bash
# Script for the generation of the 
# genesis block & create channel tx files
# Both files written under the artefacts subfolder

#1 Make sure the orgs-msp.tar is available
mkdir -p ./temp
tar -xvf $PWD/artefacts/orgs-msp.tar -C temp 

#2 Generate the Genesis block
export FABRIC_CFG_PATH=$PWD
GENESIS_FILE=./artefacts/bolt-genesis.block
CHANNEL_NAME=boltchannel
echo "====> Generating Genesis"
configtxgen -profile BoltOrdererGenesis -channelID $CHANNEL_NAME -outputBlock $GENESIS_FILE

#3 Generate the default channel transaction file
CHANNEL_TX_FILE=./artefacts/bolt-channel.tx
CHANNEL_NAME=boltchannel
echo "====> Generating Channel Tx"
configtxgen -profile BoltChannel -outputCreateChannelTx $CHANNEL_TX_FILE -channelID $CHANNEL_NAME

rm -rf ./temp/*
