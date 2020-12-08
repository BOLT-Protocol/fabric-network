# Default var
NAME=defaultChaincode
CHANNEL=defaultchannel

# Get Args
while getopts ':C:n:' o; do
    case $"${o}" in
        C)
            CHANNEL=$OPTARG
            ;;
        n)
            NAME=$OPTARG
            ;;
        *)
            # usage
            ;;
    esac
done
source $PWD/bins/peer/set-env.sh

peer lifecycle chaincode querycommitted -n $NAME -C $CHANNEL