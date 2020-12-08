# Default var
NAME=defaultChaincode
CHANNEL=defaultchannel
SEQUENCE=1
CC_PACKAGE_ID=1
VERSION=1
# Get Args
while getopts ':c:C:n:s:v:' o; do
    case $"${o}" in
        C)
            CHANNEL=$OPTARG
            ;;
        n)
            NAME=$OPTARG
            ;;
        s)
            SEQUENCE=$OPTARG
            ;;
        v)
            VERSION=$OPTARG
            ;;
        *)
            # usage
            ;;
    esac
done

source $PWD/bins/peer/set-env.sh

peer lifecycle chaincode checkcommitreadiness -n $NAME -C $CHANNEL --sequence $SEQUENCE -v $VERSION