export EXPLORER=blockchain-explorer

git clone https://github.com/hyperledger/$EXPLORER
cp first-network.json $PWD/$EXPLORER/examples/net1/connection-profile
cp -r $PWD/crypto-config/peerOrganizations $PWD/$EXPLORER/examples/net1/crypto/

cd $EXPLORER

docker-compose up -d