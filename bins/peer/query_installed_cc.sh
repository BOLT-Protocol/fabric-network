source $PWD/bins/peer/set-env.sh
export CC_PACKAGE_FILE=$HOME/$CC_LABEL.tar.gz

# Get Args
while getopts ':f:' o; do
    case $"${o}" in
        f)
            CC_PACKAGE_FILE=$OPTARG
            ;;
        *)
            # usage
            ;;
    esac
done

peer lifecycle chaincode queryinstalled $CC_PACKAGE_FILE