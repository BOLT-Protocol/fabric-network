source $PWD/bins/peer/set-env.sh
export CORE_PEER_LOCALMSPID=$MSP_ID"MSP"

peer channel signconfigtx -f $PWD/artefacts/bolt-channel.tx