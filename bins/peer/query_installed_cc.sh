source $PWD/bins/peer/set-env.sh
export CC_PACKAGE_FILE=$HOME/$CC_LABEL.tar.gz

# Get Args
while getopts ':f:l:' o; do
    case $"${o}" in
        f)
            CC_PACKAGE_FILE=$OPTARG
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

peer lifecycle chaincode queryinstalled $CC_PACKAGE_FILE