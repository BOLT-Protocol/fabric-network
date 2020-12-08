source $PWD/bins/peer/set-env.sh
NAME=defaultChaincode
CHANNEL=defaultchannel
ARG='{"Args": ["init"]}'

# Get Args
while getopts ':C:n:c:' o; do
    case $"${o}" in
        n)
            NAME=$OPTARG
            ;;
        C)
            CHANNEL=$OPTARG
            ;;
        c)
            ARG=$OPTARG
            ;;
        *)
            # usage
            ;;
    esac
done

peer chaincode invoke -n $NAME -C $CHANNEL -c $ARG --isInit