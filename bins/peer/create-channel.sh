# Orderer Address env variable is getting set in the set-env.sh
source $PWD/bins/peer/set-env.sh

export CHANNEL_TX_FILE=${PWD}/artefacts/default-channel.tx

# Execute the channel create command
peer channel create -o $ORDERER_ADDRESS -c $1 -f $CHANNEL_TX_FILE