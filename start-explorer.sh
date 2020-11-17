export EXPLORER=blockchain-explorer

git clone https://github.com/hyperledger/$EXPLORER
cp explorer-config/first-network.json $PWD/$EXPLORER/examples/net1/connection-profile
cp explorer-config/docker-compose.yaml $PWD/$EXPLORER
cp -r $PWD/crypto-config/peerOrganizations $PWD/$EXPLORER/examples/net1/crypto/

cd $EXPLORER

docker-compose up
docker ps