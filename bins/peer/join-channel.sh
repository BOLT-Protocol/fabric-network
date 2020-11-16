
# Joins the peer
export CHANNEL_BLOCK=${PWD}/artefacts/default-genesis.block

#1 Fetch the genesis for the channel - this leads to creation of
peer channel fetch 0  -o 3.101.69.212:7050 -c defaultchannel

#2 Join the channel
peer channel join -b $CHANNEL_BLOCK -o 3.101.69.212:7050
