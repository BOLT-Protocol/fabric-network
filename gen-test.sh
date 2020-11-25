
./clean.sh
cryptogen generate --config=./crypto-config.yaml

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