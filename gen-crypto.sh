# FIRST TIME MUST call with 'all' as argument
# If 'all' not passed then crypto not regenrated

rm -rf temp
rm  -rf ./artefacts/*

#1 Check if all was passed
if [ ! -z $1 ]; then
    if [ $1 == "all" ]; then
        #1. Generate the crypto
        echo "====> Generating the crypto-config"
        rm -rf crypto-config
        cryptogen generate --config=./crypto-config.yaml
    fi
else
    echo 'Use ./gen-crypto.sh   all      to regenerate the crypto'
fi

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


rm -rf temp/msps/**


