sh gen-crypto.sh all
sh gen-genesis-channeltx.sh

./bins/orderer/launch.sh &
./bins/peer/launch.sh &

./bins/peer/join-channel.sh
./start-explorer.sh

# cd docker
# docker-compose up -d