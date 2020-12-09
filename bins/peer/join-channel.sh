
if [ ! -d "artefacts" ]; then
	mkdir artefacts
fi

# Joins the peer
source $PWD/bins/peer/set-env.sh
export CHANNEL_BLOCK=${PWD}/artefacts/default-genesis.block

#1 Fetch the genesis for the channel - this leads to creation of
peer channel fetch oldest -o $ORDERER_ADDRESS -c defaultchannel $CHANNEL_BLOCK

echo  $ORDERER_ADDRESS
#2 Join the channel
peer channel join -b $CHANNEL_BLOCK -o $ORDERER_ADDRESS
