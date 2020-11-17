# Default var
NAME=defaultChaincode
CHANNEL=defaultchannel
SEQUENCE=1
CC_PACKAGE_ID=1
VERSION=1

# Get Args
while getopts ':c:C:n:s:' o; do
    case $"${o}" in
        c)
            CC_PACKAGE_ID=$OPTARG
            ;;
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

peer lifecycle chaincode approveformyorg -n $NAME -C $CHANNEL --sequence $SEQUENCE --init-required --package-id $CC_PACKAGE_ID -v $VERSION