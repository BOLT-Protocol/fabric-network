# FIRST TIME MUST call with 'all' as argument
# If 'all' not passed then crypto not regenrated

# certificate authorities compose file
COMPOSE_FILE_CA=docker/docker-compose-ca.yaml
# default image tag
IMAGETAG="latest"
# default ca image tag
CA_IMAGETAG="latest"

source scriptUtils.sh

function createOrgs() {
    infoln "Generate certificates using Fabric CA's"

    IMAGE_TAG=${CA_IMAGETAG} docker-compose -f $COMPOSE_FILE_CA up -d 2>&1

    . crypto-config/fabric-ca/registerEnroll.sh

    while :
        do
            if [ ! -f "crypto-config/fabric-ca/defaultOrg/tls-cert.pem" ]; then
                sleep 1
            else
                break
            fi
        done

        infoln "Create DefaultOrg Identities"

        createDefaultOrg $2

        infoln "Create AsusOrg Identities"

        createAsusOrg $3

        infoln "Create OrdererOrg Identities"

        createOrderer $4

    # infoln "Generate CCP files for Org1 and Org2"

    # ./crypto-config/ccp-generate.sh

}

function buildFiles() {
    echo    "====> Generating : Organization MSPs : orgs-msp.tar"
    #2 Generate the orgs-msp.tar
    rm -rf temp/orgs-msp
    mkdir -p ./temp/orgs-msp/orderer
    cp -R crypto-config/ordererOrganizations/default.com/msp    temp/orgs-msp/orderer/msp
    mkdir -p temp/orgs-msp/default
    cp -R crypto-config/peerOrganizations/default.com/msp    temp/orgs-msp/default/msp
    mkdir -p temp/orgs-msp/asus
    cp -R crypto-config/peerOrganizations/asus.com/msp    temp/orgs-msp/asus/msp
    # Create the orgs-msp tar file
    mkdir artefacts
    cd temp
    tar -cf ../artefacts/orgs-msp.tar orgs-msp
    cd ../

    #3 Generate the orderer-msp.tar
    echo   "====> Generating : Orderer MSP : orderer-msp.tar"
    mkdir -p temp/orderer-msp
    cp -R crypto-config/ordererOrganizations/default.com/orderers/orderer.default.com/msp  temp/orderer-msp
    cd temp
    tar -cf ../artefacts/orderer-msp.tar orderer-msp
    cd ../

    #4 Generate the default-msp.tar
    echo   "====> Generating : default MSP : default-msp.tar"
    mkdir -p temp/msps
    cp -R crypto-config/peerOrganizations/default.com/peers/devpeer/msp                     temp/msps/peer
    cp -R crypto-config/peerOrganizations/default.com/users/Admin@default.com/msp              temp/msps/admin
    cp -R crypto-config/peerOrganizations/default.com/users/User1@default.com/msp              temp/msps/user1
    cd temp
    tar -cf ../artefacts/default-msp.tar msps
    cd ../

    #4 Generate the asus-msp.tar
    echo   "====> Generating : default MSP : default-msp.tar"
    mkdir -p temp/msps
    cp -R crypto-config/peerOrganizations/asus.com/peers/peer0.asus.com/msp              temp/msps/peer
    cp -R crypto-config/peerOrganizations/asus.com/peers/peer1.asus.com/msp              temp/msps/peer
    cp -R crypto-config/peerOrganizations/asus.com/peers/peer2.asus.com/msp              temp/msps/peer
    cp -R crypto-config/peerOrganizations/asus.com/users/Admin@asus.com/msp              temp/msps/admin
    cp -R crypto-config/peerOrganizations/asus.com/users/User1@asus.com/msp              temp/msps/user1
    cp -R crypto-config/peerOrganizations/asus.com/users/User2@asus.com/msp              temp/msps/user2
    cd temp
    tar -cf ../artefacts/default-msp.tar msps
    cd ../

    # rm -rf temp/msps/**
}
#1 Check if up was passed
if [ ! -z $1 ]; then
    if [ $1 == "up" ]; then
        ##1. Generate the crypto
        echo "====> Generating the crypto-config"
        rm -rf crypto-config/ordererOrganizations && rm -rf crypto-crypto/peerOrganizations
        createOrgs
        buildFiles
    fi
    if [ $1 == "down" ]; then
        infoln "====> docker kill && remove ca"
        IMAGE_TAG=${CA_IMAGETAG} docker-compose -f $COMPOSE_FILE_CA down --remove-orphans 2>&1
        sudo mkdir -p ./crypto-config/tmp/fabric-ca/asusOrg
        sudo mkdir -p ./crypto-config/tmp/fabric-ca/defaultOrg
        sudo mkdir -p ./crypto-config/tmp/fabric-ca/ordererOrg
        sudo rm -rf crypto-config/ordererOrganizations && rm -rf crypto-config/peerOrganizations
        sudo cp ./crypto-config/fabric-ca/registerEnroll.sh ./crypto-config/tmp/fabric-ca/registerEnroll.sh
        sudo cp ./crypto-config/fabric-ca/asusOrg/fabric-ca-server-config.yaml ./crypto-config/tmp/fabric-ca/asusOrg/fabric-ca-server-config.yaml
        sudo cp ./crypto-config/fabric-ca/defaultOrg/fabric-ca-server-config.yaml ./crypto-config/tmp/fabric-ca/defaultOrg/fabric-ca-server-config.yaml
        sudo cp ./crypto-config/fabric-ca/ordererOrg/fabric-ca-server-config.yaml ./crypto-config/tmp/fabric-ca/ordererOrg/fabric-ca-server-config.yaml
        sudo rm -Rf ./crypto-config/fabric-ca/
        sudo rm -f ./artefacts/*
        sudo mv -f ./crypto-config/tmp/fabric-ca/ ./crypto-config/
        sudo rm -Rf ./crypto-config/tmp/
    fi
else
    echo 'Use ./gen-crypto.sh   up      to regenerate the crypto'
fi






