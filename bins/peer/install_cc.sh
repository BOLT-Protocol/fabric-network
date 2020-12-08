export CC_LABEL=gocc.1.0-1.0
export CC_PACKAGE_FILE=$HOME/$CC_LABEL.tar.gz

source $PWD/bins/peer/set-env.sh

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

peer lifecycle chaincode install $CC_PACKAGE_FILE