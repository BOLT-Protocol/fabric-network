source $PWD/bins/peer/set-env.sh

export CC_LABEL=gocc.1.0-1.0
export CC_PACKAGE_FILE=$HOME/$CC_LABEL.tar.gz

peer lifecycle chaincode package $CC_PACKAGE_FILE -p ./fabcar/go --label $CC_LABEL