AFFILIATION=caserver
USER=admin
PW=caserverpw
SERVER_HOST=localhost:7054

while getopts ':u:p:a:' o; do
    case $"${o}" in
        u)
            USER=$OPTARG
            ;;
        p)
            PW=$OPTARG
            ;;
        a)
            AFFILIATION=$OPTARG
            ;;
        s)
            SERVER_HOST=$OPTARG
            ;;
        *)
            # usage
            ;;
    esac
done

export FABRIC_CA_CLIENT_TLS_CERTFILES=$PWD/ca/tls-ca/crypto/ca-cert.pem
source $PWD/ca/setclient.sh $AFFILIATION $USER

mkdir -p organizations/peerOrganizations/$ORG/
mkdir -p organizations/peerOrganizations/$ORG/peers
mkdir -p organizations/peerOrganizations/$ORG/peers/$USER.$ORG
mkdir -p organizations/fabric-ca/$AFFILIATION

fabric-ca-client enroll -d -u https://$USER:$PW@$SERVER_HOST -M ${PWD}/organizations/peerOrganizations/$AFFILIATION/peers/$USER.$AFFILIATION/msp --tls.certfiles ${PWD}/ca/tls-ca/crypto/tls-cert.pem

#  --caname ca-$AFFILIATION

# TODO 
# if [ AFFILIATION != 'caserver' ];
# then
#     echo  "Copy admincerts"
#     cp -r $PWD/ca/client/caserver/admin/msp/signcerts/*  $FABRIC_CA_CLIENT_HOME/msp/admincerts/
# fi
