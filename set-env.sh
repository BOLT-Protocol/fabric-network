# Make sure that IP Addresses are setup properly
# Use PUBLIC IP Here


export ORDERER_ADDRESS=3.101.69.212:7050

export DEFAULT_EP=3.101.69.212:7051


FABRIC_CFG_PATH=$PWD

# Test Chaincode related properties
export CC_CONSTRUCTOR='{"Args":["init","a","100","b","200"]}'
export CC_NAME="gocc1"
export CC_PATH="chaincode_example02"
export CC_VERSION="1.0"
export CC_CHANNEL_ID="defaultchannel"
export CC_LANGUAGE="golang"

# Version 2.x
export INTERNAL_DEV_VERSION="1.0"
export CC2_PACKAGE_FOLDER="$HOME/packages"
export CC2_SEQUENCE=1
export CC2_INIT_REQUIRED="--init-required"

# Create the package with this name
export PACKAGE_NAME="$CC_NAME.$CC_VERSION-$INTERNAL_DEV_VERSION.tar.gz"
# Extracts the package ID for the installed chaincode
export LABEL="$CC_NAME.$CC_VERSION-$INTERNAL_DEV_VERSION"



export FABRIC_LOGGING_SPEC=info

function    usage {
    echo  "Usage: . ./set-env.sh    ORG_NAME"
    echo  "Sets the environment for the specific org"
}

export CURRENT_ORG_NAME=$1

echo "Setting environment for $CURRENT_ORG_NAME"

# Set environment variables based on the ORG_Name
case $CURRENT_ORG_NAME in
    "default")   export CORE_PEER_MSPCONFIGPATH=./crypto-config/peerOrganizations/default.com/users/Admin@default.com/msp
              export CORE_PEER_ADDRESS=$DEFAULT_EP
              export CORE_PEER_LOCALMSPID=DefaultMSP
        ;;
    #"budget") export CORE_PEER_MSPCONFIGPATH=./crypto-config/peerOrganizations/budget.com/users/Admin@budget.com/msp
    #          export CORE_PEER_ADDRESS=$BUDGET_EP
    #          export CORE_PEER_LOCALMSPID=BudgetMSP
    #    ;;
    #"expo")   export CORE_PEER_MSPCONFIGPATH=./crypto-config/peerOrganizations/expo.com/users/Admin@expo.com/msp
    #          export CORE_PEER_ADDRESS=$EXPO_EP
    #          export CORE_PEER_LOCALMSPID=ExpoMSP
    #    ;;
    

    *) usage
esac