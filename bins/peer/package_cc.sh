CHAINCODE_PATH=./fabcar/go
export CC_LABEL=gocc.1.0-1.0
export CC_PACKAGE_FILE=$HOME/$CC_LABEL.tar.gz

# Get Args
while getopts ':f:p:l:' o; do
    case $"${o}" in
        f)
            CC_PACKAGE_FILE=$OPTARG
            ;;
        p)
            CHAINCODE_PATH=$OPTARG
            ;;
        l)
            CC_LABEL=$OPTARG
            CC_PACKAGE_FILE=$HOME/$CC_LABEL.tar.gz
            ;;
        *)
            # usage
            ;;
    esac
done

source $PWD/bins/peer/set-env.sh

peer lifecycle chaincode package $CC_PACKAGE_FILE -p $CHAINCODE_PATH --label $CC_LABEL