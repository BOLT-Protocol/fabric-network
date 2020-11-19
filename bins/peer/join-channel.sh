

# Joins the peer
source $PWD/bins/peer/set-env.sh
# export CHANNEL_BLOCK=${PWD}/artefacts/default-genesis.block
export CHANNEL_BLOCK=${PWD}/artefacts/bolt-genesis.block

#1 Fetch the genesis for the channel - this leads to creation of
peer channel fetch 0 -o $ORDERER_ADDRESS -c boltchannel

echo  $ORDERER_ADDRESS
#2 Join the channel
peer channel join -b $CHANNEL_BLOCK -o $ORDERER_ADDRESS
