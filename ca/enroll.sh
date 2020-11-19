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

fabric-ca-client enroll -d -u https://$USER:$PW@$SERVER_HOST


# TODO 
if [ AFFILIATION != 'caserver' ];
then
    echo  "Copy admincerts"
    cp $PWD/ca/client/caserver/admin/msp/signcerts/*  $FABRIC_CA_CLIENT_HOME/msp/admincerts
fi
