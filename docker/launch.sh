
# ORG
# PORT
# ORGMSP
# NAME

while getopts ':t:O:M:p:n:d:' o; do
    case $"${o}" in
        t)
            TYPE=$OPTARG
            ;;
        O)
            ORG=$OPTARG
            ;;
        M)
            ORGMSP=$OPTARG
            ;;
        p)
            PORT=$OPTARG
            ;;
        n)
            NAME=$OPTARG
            ;;
        d)
            DB_PORT=$OPTARG
            ;;
        *)
            # usage
            ;;
    esac
done

# if [ ! -z TYPE ]; then
#     exit 0
# fi

function setOrderer () {
    C_PATH=$PWD/crypto-config/${TYPE}Organizations/$ORG/${TYPE}s/$NAME.$ORG
    cd docker
    cp ./.env $C_PATH/.env
    cp ./docker-compose-orderer.yaml docker-compose-orderer.yaml
    sed -i '' "s/ORDERER_NAME=/ORDERER_NAME=$NAME/g" $C_PATH/.env
    sed -i '' "s/ORGMSP=/ORGMSP=$ORGMSP/g" $C_PATH/.env
    sed -i '' "s/PORT={PORT}/PORT=$PORT/g" $C_PATH/.env
    sed -i '' "s/DOMAIN=/DOMAIN=$NAME.$ORG/g" $C_PATH/.env
    sed -i '' "s/COMPOSE_PROJECT_NAME=/COMPOSE_PROJECT_NAME=$NAME.$ORG/g" $C_PATH/.env
    sed -i '' "s#MSP_PATH=#MSP_PATH=$C_PATH#g" $C_PATH/.env

    docker-compose -f docker-compose-orderer.yaml --env-file $C_PATH/.env up -d
}

function setPeer () {
    C_PATH=$PWD/crypto-config/${TYPE}Organizations/$ORG/${TYPE}s/$NAME.$ORG
    cd docker
    cp ./.env $C_PATH/.env

    sed -i '' "s/PEER_NAME=/PEER_NAME=$NAME.$ORG/g" $C_PATH/.env
    sed -i '' "s/ORGMSP=/ORGMSP=$ORGMSP/g" $C_PATH/.env
    sed -i '' "s/PORT={PORT}/PORT=$PORT/g" $C_PATH/.env
    sed -i '' "s/CHAINCODE_PORT={CC_PORT}/CHAINCODE_PORT=$((PORT+1))/g" $C_PATH/.env
    sed -i '' "s/DB_PORT={DB_PORT}/DB_PORT=$DB_PORT/g" $C_PATH/.env
    sed -i '' "s/DOMAIN=/DOMAIN=$ORG/g" $C_PATH/.env
    sed -i '' "s/COMPOSE_PROJECT_NAME=/COMPOSE_PROJECT_NAME=$NAME.$ORG/g" $C_PATH/.env
    sed -i '' "s#MSP_PATH=#MSP_PATH=$C_PATH#g" $C_PATH/.env
    docker-compose -f docker-compose-peer.yaml --env-file $C_PATH/.env up -d
} 

if [ "$TYPE" = "orderer" ]
then
    setOrderer
else
   setPeer
fi
